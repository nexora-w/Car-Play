import UIKit
import WebKit

class CustomWebViewController: UIViewController, CarPlayViewControllerProtocol {
    static let shared = CustomWebViewController()
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }
    
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func loadViewIncar(_ window: UIWindow?) -> CarPlayViewControllerProtocol? {
        guard let window = window else { return nil }
        
        window.rootViewController = self
        view.frame = window.bounds
        return self
    }
} 