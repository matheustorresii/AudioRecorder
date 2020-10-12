//
//  AboutViewController.swift
//  AudioRecorder
//
//  Created by Matheus Torres on 10/10/20.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func setupWebView() {
        let url = URL(string: "https://github.com/matheustorresii")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}

extension AboutViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}
