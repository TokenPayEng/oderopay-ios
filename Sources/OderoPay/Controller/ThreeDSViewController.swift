//
//  ThreeDSViewController.swift
//  
//
//  Created by Imran Hajiyev on 10.10.22.
//

import UIKit
import WebKit

class ThreeDSViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var htmlContent: String = String()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
