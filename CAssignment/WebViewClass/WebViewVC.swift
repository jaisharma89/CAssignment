//
//  WebViewVC.swift
//  CAssignment
//
//  Created by Optimum  on 20/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit
import WebKit


class WebViewVC: UIViewController, WKNavigationDelegate  {
    
    var webView: WKWebView!
    var urlStr : String!
    let activityView = UIActivityIndicatorView(style: .medium)
    // MARK: UIView LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book a Room"
        if let url = URL(string: urlStr)
        {
            self.showActivityIndicator(activityView: activityView)
            webView.load(URLRequest(url: url))
            
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideActivityIndicator(activityView: activityView)
    }
    
}

