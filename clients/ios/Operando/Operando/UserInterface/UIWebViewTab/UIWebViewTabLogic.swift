//
//  UIWebViewTabLogic.swift
//  Operando
//
//  Created by Costin Andronache on 7/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import WebKit


struct UIWebViewTabLogicOutlets {
    let contentView:  UIView?
    let goButton: UIButton?
    let addressTF: UITextField?
    let activityIndicator: UIActivityIndicatorView?
    let addressBarView: UIView?
}

class UIWebViewTabLogic: NSObject, WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate,
LongPressGestureDelegate {
    

    private let outlets: UIWebViewTabLogicOutlets?
    private(set) var webView: WKWebView?
    
    private var callbacks: UIWebViewTabCallbacks?
    private var urlHistory: [URL] = []
    private var currentURLIndex: Int = 0;
    private var whenWebviewFinishesLoading: VoidBlock?
    private var longPressRecognizer: LongPressGestureRecognizer?
    
    var currentNavigationModel: UIWebViewTabNavigationModel? {
        return UIWebViewTabNavigationModel(urlList: self.urlHistory, currentURLIndex: self.currentURLIndex)
    }
    
    //MARK: - public methods and initializer
    

    init(outlets: UIWebViewTabLogicOutlets?){
        self.outlets = outlets;
        super.init()
        
        self.outlets?.activityIndicator?.isHidden = true
        self.outlets?.addressTF?.delegate = self
        self.outlets?.goButton?.addTarget(self, action: #selector(didPressGoButton(_:)), for: .touchUpInside)
    }
    
    
    func setupWith(model: UIWebViewTabNewWebViewModel, callbacks: UIWebViewTabCallbacks?) {
        self.callbacks = callbacks
        
        let webView = self.buildWebView(with: model.setupParameter)
        self.commonSetupWith(webView: webView, navigationModel: model.navigationModel)
        self.longPressRecognizer = LongPressGestureRecognizer(webView: webView)
        self.longPressRecognizer?.longPressGestureDelegate = self
        
    }
    
    func goBack() {
        guard currentURLIndex - 1 >= 0 else {
            return
        }
        
        self.currentURLIndex -= 1;
        self.navigateTo(url: self.urlHistory[self.currentURLIndex], callback: nil)
    }
    
    func goForward () {
        guard self.currentURLIndex + 1 < self.urlHistory.count else {
            return
        }
        
        self.currentURLIndex += 1;
        self.navigateTo(url: self.urlHistory[self.currentURLIndex], callback: nil)
    }
    
    func changeNavigationModel(to model: UIWebViewTabNavigationModel, callback: VoidBlock?) {
        self.urlHistory = model.urlList
        self.currentURLIndex = model.currentURLIndex;
        self.navigateTo(url: model.urlList[model.currentURLIndex], callback: callback)
        self.outlets?.addressTF?.text = model.urlList[model.currentURLIndex].absoluteString
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
    
    //MARK: END OF public methods and initializer
    
    
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
    
    
    private func commonSetupWith(webView: WKWebView, navigationModel: UIWebViewTabNavigationModel?){
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.webView = webView
        self.constrain(webView: webView)
        
        if let activityIndicator = self.outlets?.activityIndicator {
            self.outlets?.contentView?.bringSubview(toFront: activityIndicator)
            
        }
        if let navigationModel = navigationModel {
            self.changeNavigationModel(to: navigationModel, callback: nil)
        }
    }
    
    
    
    
    @IBAction func didPressGoButton(_ sender: Any) {
        guard let text = self.outlets?.addressTF?.text else {
            return
        }
        self.goWith(userInput: text)
    }
    
    
    
    private func goWith(userInput: String) {
        
        if let url = URL.tryBuildWithHttp(with: userInput) {
            self.navigateTo(url: url, callback: nil)
            return
        }
        
        if let url = self.callbacks?.urlForUserInput(userInput) {
            self.navigateTo(url: url, callback: nil)
        }
    }
    
    
    private func navigateTo(url: URL, callback: VoidBlock?) {
        let request = URLRequest(url: url)
        self.webView?.load(request)
        weak var weakSelf = self
        
        self.whenWebviewFinishesLoading = {
            
            weakSelf?.addInHistoryCurrentLoaded(url: url)

            callback?()
            weakSelf?.whenWebviewFinishesLoading = nil
        }
    }
    
    
    private func constrain(webView: WKWebView) {
        guard let contentView = self.outlets?.contentView,
            let addressBarView = self.outlets?.addressBarView else {
            return
        }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let buildConstraintForAttribute: (_ attr: NSLayoutAttribute) -> NSLayoutConstraint = { attr in
            return NSLayoutConstraint(item: webView, attribute: attr, relatedBy: .equal, toItem: contentView, attribute: attr, multiplier: 1.0, constant: 0);
        }
        
        let constraints: [NSLayoutConstraint] = [buildConstraintForAttribute(.right), buildConstraintForAttribute(.left),
                                                 NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: addressBarView, attribute: .bottom, multiplier: 1.0, constant: 0),
                                                 
                                                 NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0)]
        
        contentView.addSubview(webView)
        contentView.addConstraints(constraints)
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    private func addInHistoryCurrentLoaded(url: URL) {
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
    
    //MARK: - WKWebViewDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        
        weak var weakSelf = self
        self.whenWebviewFinishesLoading = {
            guard let url = navigationAction.request.url else {
                return
            }
            weakSelf?.addInHistoryCurrentLoaded(url: url)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.outlets?.activityIndicator?.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.outlets?.activityIndicator?.isHidden = true
        guard let url = webView.url else {
            return
        }
        self.outlets?.addressTF?.text = url.absoluteString
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
    
    //MARK: TextField  delegate
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
