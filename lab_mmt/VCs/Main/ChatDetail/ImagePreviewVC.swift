//
//  ImagePreviewVC.swift
//  lab_mmt
//
//  Created by Imbaggaarm on 11/5/19.
//  Copyright © 2019 Tai Duong. All rights reserved.
//

import UIKit

class ImagePreviewVC: BaseViewControllerLayout {
    let imageView: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        temp.backgroundColor = AppColor.black
        return temp
    }()
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        view.addSubviews(subviews: imageView)
        imageView.makeFullWithSuperView()
    }
}
