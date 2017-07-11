Object.defineProperty(navigator, 'plugins', {
    writeable: true,
    configurable: true,
    enumerable: true,
    value: [window.navigator.plugins[0]]
});

window.plugins = "Plugin 1: Chrome PDF Viewer; Portable Document Format; internal-pdf-viewer.";
window.navigator.plugins = "Plugin 1: Chrome PDF Viewer; Portable Document Format; internal-pdf-viewer.";

window.navigator = null;
var __originalNavigator = navigator;
//navigator = null;
//navigator = new Object();
//navigator.__proto__ = __originalNavigator;
navigator.__defineGetter__('userAgent', function () { return "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36"; });
navigator.__defineGetter__('plugins', function () { return []; });