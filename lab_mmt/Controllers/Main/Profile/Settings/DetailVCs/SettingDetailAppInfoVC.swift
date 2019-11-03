//
//  SettingDetailAppInfoVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit
import MessageUI

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}

class SettingDetailAppInfoVC: SettingDetailAppInfoVCLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        butSendContactEmail.addTarget(self, action: #selector(handleTapButSendContactEmail), for: .touchUpInside)
        
        btnOpenFanpage.addTarget(self, action: #selector(handleTapBtnOpenFanpage), for: .touchUpInside)
    }
    
    @objc func handleTapButSendContactEmail() {
        handleSendEmail(title: "Xin chào", emailTo: AppString.contactEmail)
    }
    
    @objc func handleTapBtnOpenFanpage() {
        UIApplication.tryURL(urls: ["https://m.me/bkschedule", "https://www.facebook.com/bkschedule"])
    }
}

//MARK: HANDLE SEND SUPPORT EMAIL
extension SettingDetailAppInfoVC: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func handleSendEmail(title: String, emailTo: String) {
        if MFMailComposeViewController.canSendMail() {
            
            let navigationBar = UINavigationBar.appearance()
            
            //are used to reset later
            let tintColor = navigationBar.tintColor
            let barTintColor = navigationBar.barTintColor
            let titleTextAttributes = navigationBar.titleTextAttributes
            
            navigationBar.tintColor = AppColor.themeColor
            navigationBar.barTintColor = AppColor.black
//            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColor.themeColor, NSAttributedString.Key.font: AppFont.navigationBarTitleFont]
            
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            mailComposeVC.setSubject(title)
        
            mailComposeVC.setToRecipients([emailTo])
            present(mailComposeVC, animated: true, completion: nil)
            
            //reset navigation bar
            navigationBar.tintColor = tintColor
            navigationBar.barTintColor = barTintColor
            navigationBar.titleTextAttributes = titleTextAttributes
        } else {
            alertError(message: "Không thể mở cửa sổ gửi email. Hãy kiểm tra lại trong phần Cài Đặt thiết bị của bạn.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        //DISMISS CONTROLLER
        controller.dismiss(animated: true, completion: nil)
        
        //CHECK ERROR
        if error == nil {
            if result == .sent {
                let alertError = UIAlertController(title: "Đã gửi", message: "Gửi email thành công. Chúng tôi sẽ phản hồi bạn sớm nhất có thể. Cảm ơn bạn.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {action in
                })
                alertError.addAction(ok)
                present(alertError, animated: true, completion: nil)
            }
        } else {
            alertError(message: "Không thể gửi email. Vui lòng thử lại sau.")
        }
    }
    
    func alertError(message: String) {
        let alertError = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertError.addAction(ok)
        present(alertError, animated: true, completion: nil)
    }
}

