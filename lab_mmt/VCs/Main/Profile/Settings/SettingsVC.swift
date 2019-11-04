//
//  SettingsVC.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/13/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

class SettingsVC: SettingsVCLayout, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var accountSettingDetails: [SettingCellDetail]!
    
    let heightOfSettingsCell: CGFloat = {
        switch AppConstant.myScreenType {
        case .iPhone5: return 40
        default: return 55
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblEmail.text = UserProfile.this.email
        
        let privacyPolicyDetail = SettingCellDetail.init(icon: nil, title: AppString.settingsVCPrivacyPolicyTxt, isHighlightedTitle: false, isShowButAtRightCorner: true, titleAligment: .left)
        let termsOfUseDetail = SettingCellDetail.init(icon: nil, title: AppString.settingsVCTermsOfUseTxt, isHighlightedTitle: false, isShowButAtRightCorner: true, titleAligment: .left)
        let appInfoDetail = SettingCellDetail.init(icon: nil, title: AppString.settingsVCAppInfoTxt, isHighlightedTitle: false, isShowButAtRightCorner: true, titleAligment: .left)
        let supportDetail = SettingCellDetail.init(icon: nil, title: AppString.settingsVCSupportTxt, isHighlightedTitle: false, isShowButAtRightCorner: true, titleAligment: .left)
        let logoutDetail = SettingCellDetail.init(icon: nil, title: AppString.settingsVCLogoutTxt, isHighlightedTitle: true, isShowButAtRightCorner: false, titleAligment: .center)
        
        accountSettingDetails = [privacyPolicyDetail, termsOfUseDetail, appInfoDetail, supportDetail, logoutDetail]
        
        setUpCollectionView()
        
    }
    
    func startAnimation() {
        activityIndicator.startAnimating()
        blackBackgroundView.isHidden = false
    }
    
    func stopAnimation() {
        activityIndicator.stopAnimating()
        blackBackgroundView.isHidden = true
    }
    
    let accountSettingCellID = "accountSettingCellID"
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SettingCVCell.self, forCellWithReuseIdentifier: accountSettingCellID)
    }
    
    deinit {
        print(self.description + " " + #function)
    }
}

extension SettingsVC {
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountSettingDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: accountSettingCellID, for: indexPath) as! SettingCVCell
            let row = indexPath.row
            cell.detail = accountSettingDetails[row]
            
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: widthOfScreen - 40, height: heightOfSettingsCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            showPrivacyPolicyVC()
        case 1:
            showTermsOfUseVC()
        case 2:
            showAppInfoVC()
        case 3:
            showSupportVC()
        case 4:
            handleLogOut()
        default:
            break
        }
    }
    
    func showPrivacyPolicyVC() {
        //setPrefersLargeTitles(isPrefer: false)
        let ppVC = SettingDetailPrivacyPolicyVC()
        show(ppVC, sender: nil)
    }
    
    func showTermsOfUseVC() {
        
        let touVC = SettingDetailTermsOfUseVC()
        show(touVC, sender: nil)
    }
    
    func showAppInfoVC() {
        
        let appInfoVC = SettingDetailAppInfoVC()
        show(appInfoVC, sender: nil)
    }
    
    func showSupportVC() {
        
        let supportVC = SettingDetailSupportVC()
        show(supportVC, sender: nil)
    }
    
    func handleLogOut() {
        let completion: ((UIAlertAction) -> Void) = {[unowned self] (action) in
            self.startAnimation()
            APIClient.logout()
                .execute(onSuccess: {[weak self] (response) in
                    if response.success {
                        self?.clearCache()
                        self?.handleDismissToWelcomeVC()
                    } else {
                        self?.letsAlert(withMessage: "Đăng xuất thất bại, xin vui lòng thử lại sau.")
                    }
                }) {[weak self] (error) in
                    self?.letsAlert(withMessage: "Đăng xuất thất bại, xin vui lòng thử lại sau.")
            }
        }
        presentLogoutAlert(actionCompletion: completion)
    }
    
    private func clearCache() {
        myFriends = []
        chatRooms = []
        
        AppUserDefaults.sharedInstance.removeUserAccount()
        AppUserDefaults.sharedInstance.clearCache()
    }
    
    func presentLogoutAlert(actionCompletion: @escaping (UIAlertAction) -> Void) {
        let logOutVC = UIAlertController(title: "", message: "Bạn chắc chắn muốn đăng xuất?", preferredStyle: .actionSheet)
        
        let logOut = UIAlertAction(title: "Đăng xuất", style: .destructive, handler: actionCompletion)
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        logOutVC.addAction(logOut)
        logOutVC.addAction(cancel)
        present(logOutVC, animated: true, completion: nil)
    }
    
    func handleDismissToWelcomeVC() {
//        let presentingVC = self.presentingViewController!
//        let rootVC = self.presentingViewController!.presentingViewController!.presentingViewController
        
        SignalingClient.shared.disconnect()
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
