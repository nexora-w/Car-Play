//
//  CarPlaySafari.swift
//  TDS Video
//
//  Created by Nexora on 13/04/2025.
//

import UIKit
import WebKit
import AVKit
import SafariServices
class CustomSafariController: CarPlayViewControllerProtocol, WKNavigationDelegate, WKUIDelegate {

    static let shared = CustomSafariController()
    var webView: SFSafariViewController?
    var cursorImageView: UIImageView?
    var containerView: UIView?
    var IsIncar: Bool = false
    var CPwindow:UIWindow?
    private var zoomScale: CGFloat = 1.0
    
    func initView(){
        
        // Initialize and configure the container view
        containerView = UIView(frame: self.view.frame)
        containerView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(containerView!)


        
        // Initialize and configure the cursor image view
        let cursorImage = UIImage(named: "Cursor") // Replace with your cursor image name
        cursorImageView = UIImageView(image: cursorImage)
        cursorImageView!.frame = CGRect(x: 100, y: 100, width: 30, height: 30) // Set initial position and size
        self.view.addSubview(cursorImageView!)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func CarViewDidLoad(_ window: UIWindow?) {
        CPwindow = window

    }

    override func loadViewIncar(_ window: UIWindow?) -> CarPlayViewControllerProtocol {
        for subview in window!.subviews {
            subview.removeFromSuperview()
            print(subview)
        }
        
         window?.isUserInteractionEnabled = true
         window?.rootViewController = UIViewController()
         window?.rootViewController?.view.isUserInteractionEnabled = true

         // Use the shared instance of CustomWebViewController
         let webViewController = self
//         guard let webViewController = self.webViewController else { return }

         // Properly add the CustomWebViewController's view to the window
         if let rootViewController = window?.rootViewController {
             CustomWebViewController.shared.IsIncar = true
             rootViewController.addChild(webViewController)
             rootViewController.view.addSubview(webViewController.view)
             webViewController.view.frame = rootViewController.view.bounds
             webViewController.didMove(toParent: rootViewController)
             webViewController.CarViewDidLoad(window)
//             webViewController.view.isUserInteractionEnabled = true
         }
        return webViewController
    }


    func loadURL(_ url: URL) {
//        let request = URLRequest(url: url)
        webView = SFSafariViewController(url: url)
        self.present(webView!, animated: true)
    }

//    // Function to move the cursor up
//    func moveCursorUp(by amount: CGFloat) {
//        guard let cursorImageView = self.cursorImageView else { return }
//        let newCenter = CGPoint(x: cursorImageView.center.x, y: cursorImageView.center.y - amount)
//        UIView.animate(withDuration: 0.3) {
//            cursorImageView.center = newCenter
//        }
//    }
//
//    // Function to move the cursor down
//    func moveCursorDown(by amount: CGFloat) {
//        guard let cursorImageView = self.cursorImageView else { return }
//        let newCenter = CGPoint(x: cursorImageView.center.x, y: cursorImageView.center.y + amount)
//        UIView.animate(withDuration: 0.3) {
//            cursorImageView.center = newCenter
//        }
//    }
//
//    // Function to move the cursor left
//    func moveCursorLeft(by amount: CGFloat) {
//        guard let cursorImageView = self.cursorImageView else { return }
//        let newCenter = CGPoint(x: cursorImageView.center.x - amount, y: cursorImageView.center.y)
//        UIView.animate(withDuration: 0.3) {
//            cursorImageView.center = newCenter
//        }
//    }
//
//    // Function to move the cursor right
//    func moveCursorRight(by amount: CGFloat) {
//        guard let cursorImageView = self.cursorImageView else { return }
//        let newCenter = CGPoint(x: cursorImageView.center.x + amount, y: cursorImageView.center.y)
//        UIView.animate(withDuration: 0.3) {
//            cursorImageView.center = newCenter
//        }
//    }
//
//    // Function to select (click) the element at the cursor position
//    func select() {
//        guard let cursorImageView = self.cursorImageView else { return }
//        guard let webView = self.webView else { return }
//        
//        // Convert cursor position to webView's coordinate system
//        let cursorPointInView = cursorImageView.center
//        let cursorPointInWebView = webView.convert(cursorPointInView, from: self.view)
//        
//        let js = "document.elementFromPoint(\(Int(cursorPointInWebView.x)), \(Int(cursorPointInWebView.y))).click();"
//        webView.evaluateJavaScript(js, completionHandler: nil)
//    }
//
//    // Function to scroll the web view
//    func scrollBy(x: CGFloat, y: CGFloat) {
//        let js = "window.scrollBy(\(x), \(y));"
//        webView?.evaluateJavaScript(js, completionHandler: nil)
//    }
//
//    func resizeContent(by scale: CGFloat) {
//        zoomScale *= scale
//        let js = "document.body.style.zoom = '\(zoomScale)'"
//        webView?.evaluateJavaScript(js, completionHandler: nil)
//    }
//
//    // Function to resize the container view
//    func resize(by scale: CGFloat) {
//        // Ensure scale is positive
//        guard scale > 0 else { return }
//
//        guard let containerView = containerView else { return }
//        // Get the current frame of the container view
//        var currentFrame = containerView.frame
//
//        // Calculate the new width and height
//        let newWidth = currentFrame.width * scale
//        let newHeight = currentFrame.height * scale
//
//        // Optionally, maintain the center of the container view
//        let currentCenter = containerView.center
//
//        // Set the new frame size
//        currentFrame.size = CGSize(width: newWidth, height: newHeight)
//        containerView.frame = currentFrame
//
//        // Optionally, set the center back to the original
//        containerView.center = currentCenter
//    }
//
//    // Function to reset the zoom level to 1
//    func resetZoom() {
//        zoomScale = 1.0
//        let js = "document.body.style.zoom = '1.0'"
//        webView?.evaluateJavaScript(js, completionHandler: nil)
//    }
//
//    func reloadPage() {
//        zoomScale = 1.0
//        let js = "document.location.reload();"
//        webView?.evaluateJavaScript(js, completionHandler: nil)
//    }
//
//    // Toggle hidden cursor
//    func toggleCursor() {
//        guard let cursorImageView = self.cursorImageView else { return }
//        if cursorImageView.isHidden {
//            UIView.animate(withDuration: 0.3) {
//                cursorImageView.isHidden = false
//            }
//        } else {
//            UIView.animate(withDuration: 0.3) {
//                cursorImageView.isHidden = true
//            }
//        }
//    }
//
//    // WKUIDelegate method to prevent full-screen video playback
//    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        return nil
//    }
//
//    // WKUIDelegate method to handle JavaScript alerts
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        completionHandler()
//    }
//
//    func moveHorizontally(by offset: CGFloat) {
//        guard let containerView = containerView else { return }
//        var currentFrame = containerView.frame
//        currentFrame.origin.x += offset
//        containerView.frame = currentFrame
//        print(containerView.frame)
//    }
//
//    func moveVertically(by offset: CGFloat) {
//        guard let containerView = containerView else { return }
//        var currentFrame = containerView.frame
//        currentFrame.origin.y += offset
//        containerView.frame = currentFrame
//        print(containerView.frame)
//    }
//    
//    // Prevent YouTube app from opening
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = navigationAction.request.url {
//            let urlString = url.absoluteString
//            print("Attempting to load: \(urlString)")
//
//      
//            if navigationAction.navigationType == .linkActivated {
//                // If the URL is a YouTube link, ensure it loads in the web view
//                if urlString.contains("youtube.com") || urlString.contains("youtu.be") {
//                    decisionHandler(.cancel)
//                    webView.load(navigationAction.request)
//                    return
//                }
//            }
//
//            // Prevent external apps from opening
//            if navigationAction.targetFrame == nil {
//                webView.load(navigationAction.request)
//                decisionHandler(.cancel)
//                return
//            }
//        }
//        decisionHandler(.allow)
//    }
//    // Print URL when it changes
//            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//                if let currentURL = webView.url?.absoluteString {
//                    print("Page Loaded: \(currentURL)")
//                    TDSVideoAPI.shared.sendURL(URLString: currentURL)
//                }
//            }
//    
//    
//  
//    
//    
//    func saveZoomSettings(_ settings: ZoomSettings, forDomain domain: String) {
//        var allSettings = loadAllZoomSettings()
//        allSettings[domain] = settings
//
//        if let data = try? JSONEncoder().encode(allSettings) {
//            UserDefaults.standard.set(data, forKey: "DomainZoomSettings")
//        }
//    }
//
//    func loadZoomSettings(forDomain domain: String) -> ZoomSettings? {
//        let allSettings = loadAllZoomSettings()
//        return allSettings[domain]
//    }
//
//    func loadAllZoomSettings() -> [String: ZoomSettings] {
//        if let data = UserDefaults.standard.data(forKey: "DomainZoomSettings"),
//           let settings = try? JSONDecoder().decode([String: ZoomSettings].self, from: data) {
//            return settings
//        }
//        return [:]
//    }
//    func extractDomain(from urlString: String) -> String? {
//        guard let url = URL(string: urlString) else { return nil }
//        return url.host
//    }
//    
//    
//    func saveViewSettings() {
//        guard let url = webView?.url, let domain = extractDomain(from: url.absoluteString),
//              let containerView = containerView else { return }
//
//        let frame = containerView.frame
//        let settings = ZoomSettings(
//            widthMultiplier: frame.width / (CPwindow?.bounds.width ?? 0),
//            heightMultiplier: frame.height / (CPwindow?.bounds.height ?? 0),
//            originX: frame.origin.x,
//            originY: frame.origin.y
//        )
//        saveZoomSettings(settings, forDomain: domain)
//        print("Settings saved for \(domain)")
//    }

}
