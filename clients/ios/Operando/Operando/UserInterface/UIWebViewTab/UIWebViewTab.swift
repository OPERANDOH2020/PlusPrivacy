//
//  UIWebViewTab.swift
//  Operando
//
//  Created by Costin Andronache on 3/17/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import WebKit

fileprivate let kIconsMessageHandler = "iconsMessageHandler"

class UIWebViewTab: RSNibDesignableView, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate,
LongPressGestureDelegate {
    
    @IBOutlet weak var addressBarView: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webToolbarView: UIWebToolbarView!
    @IBOutlet weak var addressTF: UITextField!
    
    private(set) var webView: WKWebView?
    
    private var callbacks: UIWebViewTabCallbacks?
    private var urlHistory: [URL] = []
    private var currentURLIndex: Int = 0;
    private var whenWebviewFinishesLoading: VoidBlock?
    private var longPressRecognizer: LongPressGestureRecognizer?
    
    var currentNavigationModel: UIWebViewTabNavigationModel? {
        return UIWebViewTabNavigationModel(urlList: self.urlHistory, currentURLIndex: self.currentURLIndex)
    }
    
    //MARK: -
    
    override func commonInit() {
        super.commonInit()
        self.activityIndicator.isHidden = true
        self.addressTF.delegate = self
        self.styleGoButton()
        
        
    }
    

    func setupWith(model: UIWebViewTabNewWebViewModel, callbacks: UIWebViewTabCallbacks?) {
        self.callbacks = callbacks
        
        let webView = self.buildWebView(with: model.setupParameter)
        self.commonSetupWith(webView: webView, navigationModel: model.navigationModel)
        self.longPressRecognizer = LongPressGestureRecognizer(webView: webView)
        self.longPressRecognizer?.longPressGestureDelegate = self
        
    }
    
    private func buildWebView(with param: WebViewSetupParameter) -> WKWebView {
        
        let webViewWithConfiguration: (_ conf: WKWebViewConfiguration) -> WKWebView = { conf in
            let webView = WKWebView(frame: .zero, configuration: conf)
            
            if let path = Bundle.main.path(forResource: "FingerprintPreventing", ofType: "js") {
                if let source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
                    let userScript = WKUserScript(source: source as String, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
                    webView.configuration.userContentController.addUserScript(userScript)
                    
                }
            }
            return webView
        }
        
        switch param {
        case .fullConfiguration(let configuration):
            return webViewWithConfiguration(configuration);
            
        case .processPool(let processPool):
            let conf = self.createConfigurationWith(processPool: processPool)
            return webViewWithConfiguration(conf)
        }
    }
    
    
    
    func changeNumberOfItems(to numOfItems: Int){
        self.webToolbarView.changeNumberOfItems(to: numOfItems)
    }
    
    private func styleGoButton(){
        let title: NSMutableAttributedString = NSMutableAttributedString(string: "Go")
        let range: NSRange = NSMakeRange(0, 2);
        let color: UIColor = UIColor(colorLiteralRed: 0, green: 169.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        
        title.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: range)
        title.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        title.addAttribute(NSUnderlineColorAttributeName, value: color, range: range)
        title.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        self.goButton.setAttributedTitle(title, for: UIControlState.normal)
    }
    
    
    private func commonSetupWith(webView: WKWebView, navigationModel: UIWebViewTabNavigationModel?){
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.webView = webView
        self.constrain(webView: webView)
        self.contentView?.bringSubview(toFront: self.activityIndicator)
        self.webToolbarView.setupWith(callbacks: self.callbacksForToolbar())
        
        if let navigationModel = navigationModel {
            self.changeNavigationModel(to: navigationModel, callback: nil)
        }
    }
    
    func changeNavigationModel(to model: UIWebViewTabNavigationModel, callback: VoidBlock?) {
        self.urlHistory = model.urlList
        self.currentURLIndex = model.currentURLIndex;
        self.navigateTo(url: model.urlList[model.currentURLIndex], callback: callback)
        self.addressTF.text = model.urlList[model.currentURLIndex].absoluteString
    }
    
    func createDescriptionWithCompletionHandler(_ handler: ((_ description: WebTabDescription) -> Void)?){
        guard let webView = self.webView else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(webView.bounds.size, true, 0);
        webView.drawHierarchy(in: webView.bounds, afterScreenUpdates: true);
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.getPageTitle { pageTitle in
            handler?(WebTabDescription(name: pageTitle ?? "", screenshot: snapshotImage, favIconURL: ""))
        }
        
    }
    
    
    func getPageTitle(in callback: ((_ title: String?) -> Void)?){
        callback?(self.webView?.title)
    }
    
    
    @IBAction func didPressGoButton(_ sender: Any) {
        guard let text = self.addressTF.text else {
            return
        }
        self.goWith(userInput: text)
    }
    
    
    
    private func goWith(userInput: String) {
        
        let navigateBlock: (_ url: URL) -> Void = { url in
            self.addNewURLInHistory(url)
            self.navigateTo(url: url, callback: nil)
        }
        
        if let url = URL.tryBuildWithHttp(with: userInput) {
            navigateBlock(url)
            return
        }
        
        if let url = self.callbacks?.urlForUserInput(userInput) {
            navigateBlock(url)
        }
    }
    
    
    private func navigateTo(url: URL, callback: VoidBlock?) {
        let request = URLRequest(url: url)
        self.webView?.load(request)
        weak var weakSelf = self
        
        self.whenWebviewFinishesLoading = {
            callback?()
            weakSelf?.whenWebviewFinishesLoading = nil
        }
    }
    
    
    private func constrain(webView: WKWebView) {
        guard let contentView = self.contentView else {
            return
        }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let buildConstraintForAttribute: (_ attr: NSLayoutAttribute) -> NSLayoutConstraint = { attr in
            return NSLayoutConstraint(item: webView, attribute: attr, relatedBy: .equal, toItem: contentView, attribute: attr, multiplier: 1.0, constant: 0);
        }
        
        let constraints: [NSLayoutConstraint] = [buildConstraintForAttribute(.right), buildConstraintForAttribute(.left),
                                                NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.addressBarView, attribute: .bottom, multiplier: 1.0, constant: 0),
                                                
                                                 NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.webToolbarView, attribute: .top, multiplier: 1.0, constant: 0)]
        
        self.contentView?.addSubview(webView)
        self.contentView?.addConstraints(constraints)
        self.contentView?.setNeedsLayout()
        self.contentView?.layoutIfNeeded()
    }
    
    private func addNewURLInHistory(_ url: URL) {
        guard !self.urlHistory.contains(url) else {
            return
        }
        
        if self.urlHistory.count == 0 {
            self.currentURLIndex = 0;
        } else {
            self.currentURLIndex += 1;
        }
        
        self.urlHistory.append(url)
        
        
    }
    
    private func goBack() {
        guard currentURLIndex - 1 >= 0 else {
            return
        }
        
        self.currentURLIndex -= 1;
        self.navigateTo(url: self.urlHistory[self.currentURLIndex], callback: nil)
    }
    
    private func goForward () {
        guard self.currentURLIndex + 1 < self.urlHistory.count else {
            return
        }
        
        self.currentURLIndex += 1;
        self.navigateTo(url: self.urlHistory[self.currentURLIndex], callback: nil)
    }
    
    private func callbacksForToolbar() -> UIWebToolbarViewCallbacks {
        weak var weakSelf = self
        
        return UIWebToolbarViewCallbacks(onBackPress: {
            weakSelf?.goBack()
        }, onForwardPress: {
            weakSelf?.goForward()
        }, onTabsPress: self.callbacks?.whenUserChoosesToViewTabs);
        
    }

    private func createConfigurationWith(processPool: WKProcessPool) -> WKWebViewConfiguration {
        
        let configuration = WKWebViewConfiguration()
        configuration.processPool = processPool
        if #available(iOS 9.0, *) {
            configuration.allowsAirPlayForMediaPlayback = false
            configuration.allowsPictureInPictureMediaPlayback = false;
            configuration.requiresUserActionForMediaPlayback = true;
        } else {
            // Fallback on earlier versions
        };
        configuration.allowsInlineMediaPlayback = false;
        return configuration
        
    }
    
    //MARK: -
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.isHidden = true
        guard let url = webView.url else {
            return
        }
        self.addNewURLInHistory(url)
        self.addressTF.text = url.absoluteString
        self.whenWebviewFinishesLoading?()
    }
    
    //MARK: -
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        return self.callbacks?.whenCreatingExternalWebView?(configuration, navigationAction)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        weak var weakAlertController = alertController
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            weakAlertController?.dismiss(animated: true, completion: completionHandler)
            completionHandler()
        }
        alertController.addAction(action)
        
        self.callbacks?.whenPresentingAlertController?(alertController)
        
    }
    
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        weak var weakAlertController = alertController
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completionHandler(true)
            weakAlertController?.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
            weakAlertController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        self.callbacks?.whenPresentingAlertController?(alertController)
        
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let textField = UITextField(frame: .zero)
        textField.text = defaultText
        
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        weak var weakAlertController = alertController
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completionHandler(weakAlertController?.textFields?.first?.text)
            weakAlertController?.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
            weakAlertController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addTextField { tf in
            tf.text = defaultText
        }
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.callbacks?.whenPresentingAlertController?(alertController)
        
    }
    
    //MARK: TextView delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        self.goWith(userInput: textField.text ?? "")
        return true
    }
    
    
    //MARK: LongPressRecognizer delegate
    
    func longPressRecognizer(longPressRecognizer: LongPressGestureRecognizer, didLongPressElements elements: [LongPressElementType : NSURL]) {
        guard let linkURL = elements[.Link] else {
            return
        }
        
        let alertController = UIAlertController(title: linkURL.absoluteString ?? "", message: nil, preferredStyle: .actionSheet)
        
        let openInNewTabAction: UIAlertAction = UIAlertAction(title: "Open in new tab", style: .default) { [unowned self] action in
            self.callbacks?.whenUserOpensInNewTab?(linkURL as URL)
        }
        
        let copyAction: UIAlertAction = UIAlertAction(title: "Copy URL", style: .default) { _ in
            UIPasteboard.general.string = linkURL.absoluteString
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(openInNewTabAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        
        self.callbacks?.whenPresentingAlertController?(alertController)
    }
}
