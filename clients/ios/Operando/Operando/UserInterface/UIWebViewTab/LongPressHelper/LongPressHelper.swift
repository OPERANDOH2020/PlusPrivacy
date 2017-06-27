/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* Must make public the changes, probably in the app description
   on iTunes.
 */

import Foundation
import WebKit
import UIKit

enum LongPressElementType {
    case Image
    case Link
}

protocol LongPressGestureDelegate: class {
    func longPressRecognizer(longPressRecognizer: LongPressGestureRecognizer, didLongPressElements elements: [LongPressElementType: NSURL])
}

class LongPressGestureRecognizer: UILongPressGestureRecognizer, UIGestureRecognizerDelegate {
    private weak var webView: WKWebView!
    weak var longPressGestureDelegate: LongPressGestureDelegate?
    
    override init(target: (Any)?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    required init?(webView: WKWebView) {
        super.init(target: nil, action: nil)
        self.webView = webView
        delegate = self
        self.minimumPressDuration *= 0.9
        self.addTarget(self, action: #selector(SELdidLongPress(_:)))
        
        if let path = Bundle.main.path(forResource: "LongPress", ofType: "js") {
            if let source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) {
                let userScript = WKUserScript(source: source as String, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
                self.webView.configuration.userContentController.addUserScript(userScript)
                self.webView.addGestureRecognizer(self)
            }
        }
    }
    
    // MARK: - Gesture Recognizer Delegate Methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Long Press Gesture Handling
    func SELdidLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            //Finding actual touch location in webView
            var touchLocation = gestureRecognizer.location(in: self.webView)
            touchLocation.x -= self.webView.scrollView.contentInset.left
            touchLocation.y -= self.webView.scrollView.contentInset.top
            touchLocation.x /= self.webView.scrollView.zoomScale
            touchLocation.y /= self.webView.scrollView.zoomScale
            
            self.webView.evaluateJavaScript("findElementsAtPoint(\(touchLocation.x),\(touchLocation.y))", completionHandler: { result, error in
                if let result = result as? [String: Any] {
                    self.analyzeWKMessageBody(result)
                }
            })
        }
    }
    
    /// Recursively call block on view and its subviews
    private func recursiveBlockOnViewAndSubviews(mainView: UIView, block:(_ view: UIView) -> Void) {
        block(mainView)
        mainView.subviews.map(){ self.recursiveBlockOnViewAndSubviews(mainView: $0 as UIView, block: block) }
    }
    
    /// Find location in screen corresponding to webview - in case it is zoomed or scrolled
    private func rectLocationInWebView(webView:WKWebView,locationRect:CGRect) -> CGRect {
        var rect = locationRect
        var scale = self.webView.scrollView.zoomScale
        rect.origin.x *= scale
        rect.origin.y *= scale
        rect.size.width *= scale
        rect.size.height *= scale
        rect.origin.x += self.webView.scrollView.contentInset.left;
        rect.origin.y += self.webView.scrollView.contentInset.top;
        
        return rect
    }
    
    // MARK: - BrowserHelper Mehods
    class func name() -> String {
        return "BrowserLongPressGestureRecognizer"
    }
    
    func scriptMessageHandlerName() -> String? {
        return "longPressMessageHandler"
    }
    
    
    
    func analyzeWKMessageBody(_ elementsDict: [String: Any]) {

        var elements = [LongPressElementType: NSURL]()
        if let hrefElement = elementsDict["hrefElement"] as? [String: String] {
            if let hrefStr: String = hrefElement["hrefLink"] {
                if let linkURL = NSURL(string: hrefStr) {
                    elements[LongPressElementType.Link] = linkURL
                }
            }
        }
        if let imageElement = elementsDict["imageElement"] as? [String: String] {
            if let imageSrcStr: String = imageElement["imageSrc"] {
                if let imageURL = NSURL(string: imageSrcStr) {
                    elements[LongPressElementType.Image] = imageURL
                }
            }
        }
        
        if elements.count > 0 {
            var disableGestures: [UIGestureRecognizer] = []
            self.recursiveBlockOnViewAndSubviews(mainView: self.webView) { view in
                if let gestureRecognizers = view.gestureRecognizers {
                    for g in gestureRecognizers {
                        if g != self && g.isEnabled == true {
                            g.isEnabled = false
                            disableGestures.append(g)
                        }
                    }
                }
            }
            
            self.longPressGestureDelegate?.longPressRecognizer(longPressRecognizer: self, didLongPressElements: elements)
            disableGestures.map({ $0.isEnabled = true })
        }
    }
}
