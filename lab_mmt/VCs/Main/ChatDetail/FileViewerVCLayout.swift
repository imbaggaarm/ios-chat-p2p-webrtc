//
//  FileViewerVCLayout.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/4/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit
import WebKit

class FileViewerVCLayout: BaseViewControllerLayout {
    
    var attachment: Attachment
    
    var url: URL
    
    init(attachment: Attachment, url: URL) {
        self.attachment = attachment
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let webView: WKWebView = {
        let temp = WKWebView()
        temp.backgroundColor = .black
        return temp
    }()
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubview(webView)
        view.addConstraintsWith(format: "V:|[v0]", views: webView)
        view.addConstraintsWith(format: "H:|[v0]|", views: webView)
        webView.width(constant: widthOfScreen)
        webView.height(constant: heightOfScreen)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = attachment.name
        let request = URLRequest.init(url: url)
        webView.load(request)
//        pdfView.load(attachment.payload, mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", characterEncodingName: "UTF-8", baseURL: URL.init(string: "http://localhost/")!)
        
    }
}
