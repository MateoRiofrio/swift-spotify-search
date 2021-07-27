//
//  AuthViewController.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    public var completionHandler: ((Bool) -> Void)?
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero,
                                configuration: config)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connect to Spotify"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        guard let url = AuthManager.shared.getAuthorizationUri() else { return }
        webView.load(URLRequest(url: url))
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // get code from url after succesful user log in
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return
        }
        webView.isHidden = true

        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.completionHandler?(success)
            }
        }

    }

}
