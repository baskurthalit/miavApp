
import UIKit
import WebKit

class WebViewController: UIViewController {
    var url = String()
    @IBOutlet weak var safeView: UIView!
    
    let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeView.addSubview(webView)
        
        if let safeUrl = URL(string: url){
            webView.load(URLRequest(url: safeUrl))
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    


}
