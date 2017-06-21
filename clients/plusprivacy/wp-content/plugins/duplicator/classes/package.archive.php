<?php
if ( ! defined( 'DUPLICATOR_VERSION' ) ) exit; // Exit if accessed directly

require_once (DUPLICATOR_PLUGIN_PATH . 'classes/package.archive.zip.php');
require_once (DUPLICATOR_PLUGIN_PATH . 'lib/forceutf8/Encoding.php');

/**
 * The base class for all filter types Directories/Files/Extentions
 */
class DUP_Archive_Filter_Scope_Base
{
	//All internal storage items that duplicator decides to filter
	public $Core = array();
	
	//Items when creating a package or template that a user decides to filter
	public $Instance = array();
}

/**
 * The filter types that belong to directories
 */
class DUP_Archive_Filter_Scope_Directory extends DUP_Archive_Filter_Scope_Base
{
	//Items that are not readable
	public $Warning = array();
	
	//Items that are not readable
	public $Unreadable = array();
}

/**
 * The filter types that belong to files
 */
class DUP_Archive_Filter_Scope_File extends DUP_Archive_Filter_Scope_Directory
{
	//Items that are too large
	public $Size = array();
}

/**
 * The filter information object which store all information about the filtered
 * data that is gathered to the execution of a scan process
 */
class DUP_Archive_Filter_Info
{
	//Contains all folder filter info
	public $Dirs = array();
	
	//Contains all file filter info
	public $Files = array();
	
	//Contains all extensions filter info
	public $Exts = array();
	
	public $UDirCount  = 0;
	public $UFileCount = 0;
	public $UExtCount  = 0;
	
	public function __construct()
    {
		$this->Dirs  = new DUP_Archive_Filter_Scope_Directory();
		$this->Files = new DUP_Archive_Filter_Scope_File();
		$this->Exts  = new DUP_Archive_Filter_Scope_Base();
	}
}


class DUP_Archive 
{
	//PUBLIC
	public $FilterDirs;
	public $FilterExts;
	public $FilterDirsAll = array();
	public $FilterExtsAll = array();
	public $FilterOn;
	public $File;
	public $Format;
	public $PackDir;		
	public $Size = 0;
	public $Dirs  = array();
	public $Files = array();
	public $FilterInfo;
	
	//PROTECTED
	protected $Package;
	
	public function __construct($package) 
	{
		$this->Package   = $package;
		$this->FilterOn  = false;
		$this->FilterInfo = new DUP_Archive_Filter_Info();
	}
	
	public function Build($package) 
	{
		try 
		{
			$this->Package = $package;
			if (!isset($this->PackDir) && ! is_dir($this->PackDir)) throw new Exception("The 'PackDir' property must be a valid diretory.");
			if (!isset($this->File)) throw new Exception("A 'File' property must be set.");
		
			$this->Package->SetStatus(DUP_PackageStatus::ARCSTART);
			switch ($this->Format) 
			{
				case 'TAR':			break;
				case 'TAR-GZIP': 	break;
				default:
					if (class_exists(ZipArchive))
					{
						$this->Format = 'ZIP';
						DUP_Zip::Create($this);
					} 
					break;
			}
			
			$storePath = "{$this->Package->StorePath}/{$this->File}";
			$this->Size   = @filesize($storePath);
			$this->Package->SetStatus(DUP_PackageStatus::ARCDONE);
		
		} 
		catch (Exception $e) 
		{
			echo 'Caught exception: ',  $e->getMessage(), "\n";
		}
	}
	
	public function GetFilterDirAsArray() 
	{
		return array_map('DUP_Util::SafePath', explode(";", $this->FilterDirs, -1));
	}
	
	public function GetFilterExtsAsArray() 
	{
		return explode(";", $this->FilterExts, -1);
	}
	
	/**
	 *  Get the directory size recursively, but don't calc the snapshot directory, exclusion diretories
	 *  @link http://msdn.microsoft.com/en-us/library/aa365247%28VS.85%29.aspx Windows filename restrictions
	 */	
	public function Stats() 
	{
		$this->createFilterInfo();
		$this->getDirs();
		$this->getFiles();
		return $this;
	}
	
	//Build Filter Data
	private function createFilterInfo()
    {
		//FILTER: INSTANCE ITEMS
		//Add the items generated at create time
		if ($this->FilterOn)
        {
			$this->FilterInfo->Dirs->Instance = array_map('DUP_Util::SafePath', explode(";", $this->FilterDirs, -1));
			$this->FilterInfo->Exts->Instance = explode(";", $this->FilterExts, -1);
        }
		
		//FILTER: CORE ITMES
		//Filters Duplicator free packages & All pro local directories
		$this->FilterInfo->Dirs->Core[] = DUPLICATOR_SSDIR_PATH;

		$this->FilterDirsAll = array_merge($this->FilterInfo->Dirs->Instance, 
				                           $this->FilterInfo->Dirs->Core);
		
		$this->FilterExtsAll = array_merge($this->FilterInfo->Exts->Instance,
				                           $this->FilterInfo->Exts->Core);
	}
	
	
	//Get All Directories then filter
	private function getDirs() 
	{
		
		$rootPath = DUP_Util::SafePath(rtrim(DUPLICATOR_WPROOTPATH, '//' ));
		$this->Dirs = array();
		
		//If the root directory is a filter then we will only need the root files
        if (in_array($this->PackDir, $this->FilterDirsAll))
        {
            $this->Dirs[] = $this->PackDir;
        }
        else
        {
			$this->Dirs = $this->dirsToArray($rootPath, $this->FilterDirsAll);
            $this->Dirs[] = $this->PackDir;
        }
		
		//Filter Directories
		//Invalid test contains checks for: characters over 250, invlaid characters, 
		//empty string and directories ending with period (Windows incompatable)
		foreach ($this->Dirs as $key => $val) 
		{		
			//WARNING: Find OS items that may have issues
			// was commented out in pro
			$name = basename($val); 
			
			$warn_test  =  strlen($val) > 250 
						|| preg_match('/(\/|\*|\?|\>|\<|\:|\\|\|)/', $name) 
						|| trim($name) == "" 
						|| (strrpos($name, '.') == strlen($name) - 1  && substr($name, -1) == '.')
						|| preg_match('/[^\x20-\x7f]/', $name);
			if ($warn_test) 
			{
				$this->FilterInfo->Dirs->Warning[] = DUP_Encoding::toUTF8($val);
			} 
			
			//UNREADABLE: Directory is unreadable flag it
			if (! is_readable($this->Dirs[$key])) 
			{
				unset($this->Dirs[$key]);
				$this->FilterInfo->Dirs->Unreadable[] = $val;
				$this->FilterDirsAll[] = $val;
			}
		}
	}
	
	//Get all files and filter out error prone subsets
	private function getFiles() 
	{
		foreach ($this->Dirs as $key => $val) 
		{
			$files = DUP_Util::ListFiles($val);
			foreach ($files as $filePath) 
			{
				$fileName = basename($filePath);
				if (!is_dir($filePath))
				{
					if (!in_array(@pathinfo($filePath, PATHINFO_EXTENSION), $this->FilterExtsAll)) 
					{
						//Unreadable
						if (!is_readable($filePath))
						{
							$this->FilterInfo->Files->Unreadable[]  = $filePath;
							continue;
						}
						
						$fileSize = @filesize($filePath);
						$fileSize = empty($fileSize) ? 0 : $fileSize; 
						$invalid_test = strlen($filePath) > 250 || 
										preg_match('/(\/|\*|\?|\>|\<|\:|\\|\|)/', $fileName) || 
										trim($fileName) == "";

						if ($invalid_test || preg_match('/[^\x20-\x7f]/', $fileName))
						{
							$filePath = DUP_Encoding::toUTF8($filePath);
							$this->FilterInfo->Files->Warning[] = $filePath;
						} 
						$this->Size += $fileSize;
						$this->Files[] = $filePath;
					
						
						if ($fileSize > DUPLICATOR_SCAN_WARNFILESIZE) 
						{
							$this->FilterInfo->Files->Size[] = $filePath . ' [' . DUP_Util::ByteSize($fileSize) . ']';
						}
					} 
				}
			}
		}
	}
	
    //Recursive function to get all Directories in a wp install
    //Older PHP logic which is more stable on older version of PHP
	//NOTE RecursiveIteratorIterator is problematic on some systems issues include:
    // - error 'too many files open' for recursion
    // - $file->getExtension() is not reliable as it silently fails at least in php 5.2.9 
    // - issues with when a file has a permission such as 705 and trying to get info (had to fallback to pathinfo)
	// - basic conclusion wait on the SPL libs untill after php 5.4 is a requiremnt
	// - since we are in a tight recursive loop lets remove the utiltiy call DUP_Util::SafePath("{$path}/{$file}") and 
	//   squeeze out as much performance as we possible can
	
	private function dirsToArray($path, $filterDirsAll)
    {
        $items = array();
        $handle = @opendir($path);
        if ($handle)
        {
            while (($file = readdir($handle)) !== false)
            {
                if ($file != '.' && $file != '..')
                {
					$fullPath = str_replace("\\", '/', "{$path}/{$file}");

					if (is_dir($fullPath))
                    {
						$addDir = true;
						
						//Remove path filter directories
						foreach ($filterDirsAll as $filterDir)
						{
							$trimmedFilterDir = rtrim($filterDir, '/');
							
							if ($fullPath == $trimmedFilterDir || strstr($fullPath, $trimmedFilterDir . '/')) 
							{
								$addDir = false;
								break;
							}														
						}
																				
						if($addDir)
						{
							$items = array_merge($items, $this->dirsToArray($fullPath, $filterDirsAll));
							$items[] = $fullPath;
						}
                    }
                }
            }
            closedir($handle);
        }
		
        return $items;
    }
}
?>