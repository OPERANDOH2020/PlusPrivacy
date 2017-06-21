#!/usr/bin/env python
# coding: utf-8

IGNORE_PATTERNS = ('.idea','.gitignore','.git')

import os, sys, subprocess,shutil
from shutil import copytree, ignore_patterns

def firstOperandoBuild():		
	os.chdir('adblockpluschrome')
	os.system("git reset --hard d2ba23e")
	os.system("python build.py -t chrome devenv")
	os.chdir('..')
	return


def buildOperando():		
	os.chdir('adblockpluschrome')
	os.system("python build.py -t chrome devenv")
	os.chdir('..')
	return

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.join(BASE_DIR, "..");
os.chdir(BASE_DIR)
extensionFolder = os.getcwd()
BASE_DIR = os.path.join(BASE_DIR, "..");
os.chdir(BASE_DIR)

#print extensionFolder
#sys.exit(0)


if not os.path.exists(os.path.join(BASE_DIR,"adblockpluschrome")):
    	os.system('git clone "https://github.com/adblockplus/adblockpluschrome"')
        firstOperandoBuild()
	    #TODO update

files = [
{
	"src":extensionFolder,
	"dest":"adblockpluschrome/operando",
	"is_directory":1
},
{
	"src":"build/override/adblockpluschrome/_locales",
	"dest":"adblockpluschrome/_locales",
	"is_directory":1
},
{
  "src": "build/override/manifest.json.tmpl",
  "dest": "adblockpluschrome/buildtools/manifest.json.tmpl",
  "is_directory":0
},
{
  "src": "build/override/metadata.common",
  "dest": "adblockpluschrome/metadata.common",
  "is_directory":0
}, {
  "src": "build/override/metadata.chrome",
  "dest": "adblockpluschrome/metadata.chrome",
  "is_directory":0
}, {
  "src": "build/override/packagerChrome.py",
  "dest": "adblockpluschrome/buildtools/packagerChrome.py",
  "is_directory":0
}, {
  "src": "build/override/popup.html",
  "dest": "adblockpluschrome/popup.html",
  "is_directory":0
}, {
  "src": "build/override/popup.css",
  "dest": "adblockpluschrome/skin/popup.css",
  "is_directory":0
},
{
  "src": "build/override/options.html",
  "dest": "adblockpluschrome/options.html",
  "is_directory":0
},{
    "src": "build/override/options.js",
    "dest": "adblockpluschrome/options.js",
    "is_directory":0
  },
  {
      "src": "build/override/popup.js",
      "dest": "adblockpluschrome/popup.js",
      "is_directory":0
  },
 {
  "src": "build/override/firstRun.html",
  "dest": "adblockpluschrome/adblockplusui/firstRun.html",
  "is_directory":0
},
 {
   "src": "build/override/adblockplus/chrome/locale/en-US/meta.properties",
   "dest": "adblockpluschrome/adblockplus/chrome/locale/en-US/meta.properties",
   "is_directory":0
 },
  {
    "src": "build/override/adblockplus/chrome/locale/ro/meta.properties",
    "dest": "adblockpluschrome/adblockplus/chrome/locale/ro/meta.properties",
    "is_directory":0
  },
  {
      "src": "build/override/adblockpluschrome/chrome/ext/background.js",
      "dest": "adblockpluschrome/chrome/ext/background.js",
      "is_directory":0
    }
  ]

configFiles = [
    {
        "src":"util/config/Config.production.js",
        "dest":"adblockpluschrome/operando/util/Config.js"
    },
    {
        "src":"util/config/Config.debug.js",
        "dest":"adblockpluschrome/operando/util/Config.js"
    }
]

for file in files:
	if file['is_directory'] == 1:
	    if os.path.exists(os.path.join(BASE_DIR,file['dest'])):
                shutil.rmtree(os.path.join(BASE_DIR,file['dest']))
	    copytree(os.path.join(extensionFolder,file['src']), os.path.join(BASE_DIR,file['dest']),ignore=ignore_patterns('.gitignore', '.git','.idea'))
	else:
		shutil.copy2(os.path.join(extensionFolder,file['src']), os.path.join(BASE_DIR,file['dest']))


if len(sys.argv) > 1:
    if sys.argv[1] == "release":
        shutil.copy2(os.path.join(extensionFolder,configFiles[0]['src']), os.path.join(BASE_DIR,configFiles[0]['dest']))
else:
    shutil.copy2(os.path.join(extensionFolder,configFiles[1]['src']), os.path.join(BASE_DIR,configFiles[1]['dest']))


buildOperando()
if os.path.exists(os.path.join(BASE_DIR,"devenv.chrome.extension")):
    shutil.rmtree(os.path.join(BASE_DIR,"devenv.chrome.extension"))
copytree(os.path.join(BASE_DIR,"adblockpluschrome/devenv.chrome"), os.path.join(BASE_DIR,"devenv.chrome.extension"))

print "Buld finished! Drag and drop devenv.chrome into your chrome extensions page"

