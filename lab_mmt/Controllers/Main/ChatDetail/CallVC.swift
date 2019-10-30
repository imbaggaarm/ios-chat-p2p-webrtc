//
//  CallVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 10/29/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//


import UIKit
import WebRTC

class CallVC: UIViewController {

    var localVideoView: UIView?
    private let webRTCClient: MyWebRTCClient

    init(webRTCClient: MyWebRTCClient) {
        self.webRTCClient = webRTCClient
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if arch(arm64)
            // Using metal (arm64 only)
            let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
            localRenderer.videoContentMode = .scaleAspectFill
            remoteRenderer.videoContentMode = .scaleAspectFill
        #else
            // Using OpenGLES for the rest
            let localRenderer = RTCEAGLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
            let remoteRenderer = RTCEAGLVideoView(frame: self.view.frame)
        #endif

//        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
//        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)
        
        localVideoView = UIView()
        view.addSubview(localVideoView!)
        view.addConstraintsWith(format: "V:[v0]-20-|", views: localVideoView!)
        view.addConstraintsWith(format: "H:[v0]-20-|", views: localVideoView!)
        localVideoView?.widthAnchor(equalTo: view.widthAnchor, multiplier: 0.25, constant: 0)
        localVideoView?.heightAnchor(equalTo: view.heightAnchor, multiplier: 0.25, constant: 0)
        
        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.view)
        self.view.sendSubviewToBack(remoteRenderer)
    }
    
    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    
    @IBAction private func backDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

