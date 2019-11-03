//
//  IMBBaseWebViewController.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit
import WebKit

class IMBBaseWebViewController: BaseViewControllerLayout, WKNavigationDelegate {
    
    let activityIndicator = UIActivityIndicatorView()
    let webView = WKWebView()
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColor.black
        webView.backgroundColor = AppColor.black
        webView.isOpaque = false
        activityIndicator.color = UIColor.white
        
        setUpLayout()
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(webView)
        webView.makeFullWidthWithSuperView()
        webView.topAnchor(equalTo: view.topAnchor)
        webView.bottomAnchor(equalTo: view.bottomAnchor)
        
        view.addSubview(activityIndicator)
        activityIndicator.makeCenter(with: activityIndicator.superview!)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func loadWebViewWith(url: URL) {
        self.url = url
        
        if webView.navigationDelegate == nil {
            webView.navigationDelegate = self
        }
        
        let request = URLRequest.init(url: url)
        activityIndicator.startAnimating()
        webView.load(request)
    }
}

