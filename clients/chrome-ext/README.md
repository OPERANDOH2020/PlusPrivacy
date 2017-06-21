PlusPrivacy Chrome Extension
=========================
This is a Chrome Browser Extension and it's based on ADP (https://github.com/adblockplus/adblockpluschrome).
The extension connects to your OPERANDO account and protect your privacy data.

Building the extension
----------------------

### Requirements
- [Python 2.7](https://www.python.org)
- [The Jinja2 module](http://jinja.pocoo.org/docs)
- [The PIL module](http://www.pythonware.com/products/pil/)

### Building the extension for development environment
    ./op-clients-chrome-ext/build/build_operando.py
	
### Building the extension for release/testing environment
    ./op-clients-chrome-ext/build/build_operando.py	release
After the build process the parent directory should contain the following directories:
    - adblockpluschrome
    - op-clients-chrome-ext
    - devenv.chrome.extension
devenv.chrome.extension is the extension. Drag and drop in Chrome -> Settings -> Extensions to install it.


SOMETHIGN