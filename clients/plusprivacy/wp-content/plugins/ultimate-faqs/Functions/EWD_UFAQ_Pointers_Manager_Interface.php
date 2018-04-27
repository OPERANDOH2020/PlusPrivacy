<?php
interface UFAQPointersManagerInterface {

  /**
  * Load pointers from file and setup id with prefix and version.
  * Cast pointers to objects.
  */
  public function parse();

  /**
  * Remove from parse pointers dismissed ones and pointers
  * that should not be shown on given page
  *
  * @param string $page Current admin page file
  */
  public function filter( $page );

}

?>