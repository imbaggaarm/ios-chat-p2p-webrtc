//
//  IMBView.swift
//  appMapBoxSwiftTemp
//
//  Created by Tai Duong on 1/13/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit


class IMBView: UIView
{
    var height: CGFloat{
        get {
            return self.frame.size.height
        }
        set(newValue){
            //self.height = newValue
            self.frame.size.height = newValue
            
        }
    }
    var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set(newValue){
            self.frame.size.width = newValue
            //sef.width = newValue
        }
    }
    var x: CGFloat{
        get {
            return self.frame.origin.x
        
        }
        set(newValue){
            self.frame.origin.x = newValue
            //self.x = newValue
        }
    }

    var y: CGFloat{
        get {
            return self.frame.origin.y
        }
        set(newValue){
            self.frame.origin.y = newValue
            //self.y = newValue
        }
    }
    var cornerRadius: CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set(newValue){
            self.layer.cornerRadius = newValue
            //self.cornerRadius = newValue
        }
    }

}

class IMBTextField: UITextField
{
    var errorTitle: String?
    
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    var isError = false
    var errorTextColor: UIColor = .red
    var errorBorderColor: UIColor = .red
    
    func alertMyError() {
        self.alertError(error: errorTitle ?? "", borderColor: errorBorderColor, txtColor: errorTextColor)
        //self.alertError(error: errorTitle ?? "")
    }
    
    func turnOffAlertError(borderColor: UIColor = .clear, borderWidth: CGFloat = 0, placeHolder: String = "") {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        self.placeholder = placeHolder
    }
    
    func checkAndAlertError() -> Bool {
        if self.isEmpty {
            self.alertMyError()
            return true
        }
        return false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setLeftPadding(width: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IMBLabelView: IMBViewView {
    let leftLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftLabel.textAlignment = .center
        leftView.addSubview(leftLabel)
        leftLabel.makeFull(with: leftView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IMBViewView: UIView {
    
    let leftView = UIView()
    let rightView = UIView()
    
    private var ratioToReturn: CGFloat?
    private var widthAnchorOfLeftView = NSLayoutConstraint()
    
    var isActiveRatio: Bool {
        get {
            return widthAnchorOfLeftView.isActive
        }
        set {
            widthAnchorOfLeftView.isActive = newValue
        }
    }
    
    var leftViewWidthRatioWithRightView: CGFloat? {
        get {
            return ratioToReturn
        }
        set {
            widthAnchorOfLeftView.isActive = false
            widthAnchorOfLeftView = leftView.widthAnchor.constraint(equalTo: rightView.widthAnchor, multiplier: newValue!)
            widthAnchorOfLeftView.isActive = true
            ratioToReturn = newValue
        }
    }
    
    var leftViewBackgroundColor: UIColor? {
        get {
            return leftView.backgroundColor
        }
        set {
            leftView.backgroundColor = newValue
        }
    }
    
    var rightViewBackgroundColor: UIColor? {
        get {
            return rightView.backgroundColor
        }
        set {
            rightView.backgroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(subviews: leftView, rightView)
        
        //vertical
        addSameConstraintsWith(format: "V:|[v0]|", for: leftView, rightView)
        
        //horizontal
        widthAnchorOfLeftView = leftView.widthAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 1)
        widthAnchorOfLeftView.isActive = true
        
        leftConstraintOfLeftView = leftView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        leftConstraintOfLeftView.isActive = true
        
        leftConstraintOfRightView = rightView.leftAnchor.constraint(equalTo: leftView.rightAnchor, constant: 0)
        leftConstraintOfRightView.isActive = true
        
        rightConstraintOfRightView = rightView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        rightConstraintOfRightView.isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var leftConstraintOfLeftView: NSLayoutConstraint!
    
    var leftConstraintOfRightView: NSLayoutConstraint!
    var rightConstraintOfRightView: NSLayoutConstraint!
    
    var spacing: CGFloat {
        get {
            return leftConstraintOfRightView.constant
        }
        set {
            leftConstraintOfRightView.constant = newValue
        }
    }
    
    func setLeftSpacing(spacing: CGFloat) {
        leftConstraintOfLeftView.constant = spacing
    }
    func setRightSpacing(spacing: CGFloat) {
        rightConstraintOfRightView.constant = -spacing
    }
}

class IMBViewTextField: IMBViewView {
    let textField = IMBTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rightView.addSubviews(subviews: textField)
        textField.makeFull(with: rightView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IMBTextFieldTextField: IMBViewView {
    let leftTextField = IMBTextField()
    let rightTextField = IMBTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView.addSubview(leftTextField)
        rightView.addSubview(rightTextField)
        leftTextField.makeFull(with: leftView)
        rightTextField.makeFull(with: rightView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IMBLabelTextField: IMBViewTextField {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView.addSubviews(subviews: label)
        label.makeFull(with: leftView)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = UIColor.init(hexString: "#716F6F")
        textField.backgroundColor = UIColor.init(hexString: "#989898")
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .white
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IMBViewLabel: UIView
{
    private var ratioToReturn: CGFloat?
    private var widthAnchorOfVLabel = NSLayoutConstraint()
    let leftView: UIView = UIView()
    let titleLabel = UILabel()
    
    var leftViewWidthRatioWithTitleLabel: CGFloat? {
        get {
            return ratioToReturn
        }
        set {
            widthAnchorOfVLabel.isActive = false
            widthAnchorOfVLabel = leftView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: newValue!)
            widthAnchorOfVLabel.isActive = true
            
            ratioToReturn = newValue
        }
    }
    
    var labelBackgroundColor: UIColor? {
        get {
            return titleLabel.backgroundColor
        }
        set {
            titleLabel.backgroundColor = newValue
        }
    }
    
    var leftViewBackgroundColor: UIColor? {
        get {
            return leftView.backgroundColor
        }
        set {
            leftView.backgroundColor = newValue
        }
    }
    
    var textColor: UIColor? {
        get {
            return titleLabel.textColor
        }
        
        set {
            titleLabel.textColor = newValue
        }
    }
    var font: UIFont? {
        get {
            return titleLabel.font
        }
        set {
            titleLabel.font = newValue
        }
    }
    var textAlignment: NSTextAlignment {
        get {
            return titleLabel.textAlignment
        }
        
        set {
            titleLabel.textAlignment = newValue
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        leftView.translatesAutoresizingMaskIntoConstraints = false
        widthAnchorOfVLabel = leftView.widthAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 1)
        widthAnchorOfVLabel.isActive = true
        
        super.init(frame: frame)
        textAlignment = .center
        self.addSubviews(subviews: leftView, titleLabel)
        self.addSameConstraintsWith(format: "V:|[v0]|", for: leftView, titleLabel)
        self.addConstraintsWith(format: "H:|[v0]-2-[v1]|", views: leftView, titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
class IMBLabelLabel: IMBViewLabel
{
    private let leftLabel: UILabel = UILabel()
    
    var leftLabelTextColor: UIColor? {
        get {
            return leftLabel.textColor
        }
        
        set {
            leftLabel.textColor = newValue
        }
    }
    var leftLabelFont: UIFont? {
        get {
            return leftLabel.font
        }
        set {
            leftLabel.font = newValue
        }
    }
    
    var leftLabelTextAligment: NSTextAlignment {
        get {
            return leftLabel.textAlignment
        }
        set {
            leftLabel.textAlignment = newValue
        }
    }
    var leftTitle: String? {
        get {
            return leftLabel.text
        }
        set {
            leftLabel.text = newValue
        }
    }
    
    var leftLabelBackgroundColor: UIColor? {
        get {
            return leftLabel.backgroundColor
        }
        set {
            leftLabel.backgroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftLabel.textAlignment = .center
        leftLabel.textColor = .white
        
        leftView.addSubview(leftLabel)
        leftLabel.makeFull(with: leftView)
        titleLabel.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class IMBIconRightView: IMBViewView {
    let imgVIcon: UIImageView = UIImageView()
    var renderingMode: UIImage.RenderingMode = .alwaysOriginal
    var iCon: UIImage? {
        get {
            return imgVIcon.image
        }
        set {
            if renderingMode == .alwaysTemplate {
                imgVIcon.image = newValue?.withRenderingMode(.alwaysTemplate)
            } else {
                imgVIcon.image = newValue
            }
            
        }
    }
    
    
    
    var iConViewBackgroundColor: UIColor? {
        get {
            return imgVIcon.backgroundColor
        }
        set {
            imgVIcon.backgroundColor = newValue
        }
    }
    
    var iConTintColor: UIColor? {
        get {
            return imgVIcon.tintColor
        }
        
        set {
            imgVIcon.tintColor = newValue
        }
    }
    
    //
    init(frame: CGRect, renderingMode: UIImage.RenderingMode, ratio: CGFloat) {
        
        super.init(frame: frame)
        //imgvicon
        self.renderingMode = renderingMode
        leftView.addSubview(imgVIcon)
        imgVIcon.makeCenter(with: leftView)
        imgVIcon.makeRatio(ratio: ratio, with: leftView, isSquare: true)
    }
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class IMBIconLabel: IMBViewLabel
{
    private let imgVIcon: UIImageView = UIImageView()
    var renderingMode: UIImage.RenderingMode = .alwaysOriginal
    var iCon: UIImage? {
        get {
            return imgVIcon.image
        }
        set {
            if renderingMode == .alwaysTemplate {
                imgVIcon.image = newValue?.withRenderingMode(renderingMode)
            } else {
                imgVIcon.image = newValue
            }
            
        }
    }
    
    var iConViewBackgroundColor: UIColor? {
        get {
            return imgVIcon.backgroundColor
        }
        set {
            imgVIcon.backgroundColor = newValue
        }
    }
    
    var iConTintColor: UIColor? {
        get {
            return imgVIcon.tintColor
        }
        
        set {
            imgVIcon.tintColor = newValue
        }
    }
    
    //
    init(frame: CGRect, renderingMode: UIImage.RenderingMode, ratio: CGFloat) {
        
        super.init(frame: frame)
        //imgvicon
        self.renderingMode = renderingMode
        leftView.addSubview(imgVIcon)
        imgVIcon.makeCenter(with: leftView)
        imgVIcon.makeRatio(ratio: ratio, with: leftView, isSquare: true)
        textAlignment = .left
    }
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IMBIconTextField: IMBViewTextField
{
    private let imgVIcon: UIImageView = UIImageView()
    var renderingMode: UIImage.RenderingMode = .alwaysOriginal
    var iCon: UIImage? {
        get {
            return imgVIcon.image
        }
        set {
            if renderingMode == .alwaysTemplate {
                imgVIcon.image = newValue?.withRenderingMode(.alwaysTemplate)
            } else {
                imgVIcon.image = newValue
            }
            
        }
    }
    
    
    
    var iConViewBackgroundColor: UIColor? {
        get {
            return imgVIcon.backgroundColor
        }
        set {
            imgVIcon.backgroundColor = newValue
        }
    }
    
    var iConTintColor: UIColor? {
        get {
            return imgVIcon.tintColor
        }
        
        set {
            imgVIcon.tintColor = newValue
        }
    }
    
    //
    init(frame: CGRect, renderingMode: UIImage.RenderingMode, ratio: CGFloat) {
        
        super.init(frame: frame)
        //imgvicon
        self.renderingMode = renderingMode
        leftView.addSubview(imgVIcon)
        imgVIcon.makeCenter(with: leftView)
        imgVIcon.makeRatio(ratio: ratio, with: leftView, isSquare: true)
        
    }
    //
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IMBIconView: UIView {
    private let imgV: UIImageView = UIImageView()
    var renderingMode: UIImage.RenderingMode = .alwaysOriginal
    var icon: UIImage? {
        get {
            return imgV.image
        }
        set {
            if renderingMode == .alwaysTemplate {
                imgV.image = newValue?.withRenderingMode(.alwaysTemplate)
            } else {
                imgV.image = newValue
            }
        }
    }
    var iconTintColor: UIColor {
        get {
            return imgV.tintColor
        }
        set {
            imgV.tintColor = newValue
        }
    }
    var iConColor: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }
    init(frame: CGRect, renderingMode: UIImage.RenderingMode) {
        super.init(frame: frame)
        self.renderingMode = renderingMode
        addSubview(imgV)
        imgV.makeCenter(with: self)
        imgV.makeRatio(ratio: 0.75, with: self, isSquare: true)
    }
    init(frame: CGRect, ratio: CGFloat, renderingMode: UIImage.RenderingMode) {
        super.init(frame: frame)
        self.renderingMode = renderingMode
        addSubview(imgV)
        imgV.makeCenter(with: self)
        imgV.makeRatio(ratio: ratio, with: self, isSquare: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IMBInformationView: IMBView {
    let bottomTriangle: UIImageView = {
        let temp = UIImageView()
        temp.image = UIImage.init(named: "scrollContentViewControlButton")?.withRenderingMode(.alwaysTemplate)
        temp.tintColor = .white
        temp.backgroundColor = .clear
        return temp
    }()
    let contentView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .clear
        temp.layer.cornerRadius = 5
        temp.clipsToBounds = true
        temp.addBlurEffect(with: .dark)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(subviews: bottomTriangle, contentView)
        addConstraintsWith(format: "V:|[v0][v1(10)]|", views: contentView, bottomTriangle)
        
        addConstraintsWith(format: "H:|[v0]|", views: contentView)
        bottomTriangle.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        bottomTriangle.widthAnchor.constraint(equalToConstant: 15).isActive = true
        setUpContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContentView() {
        
    }
}

class IMBBlurLabel: IMBView {
    let label: UILabel = UILabel()
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    var textColor: UIColor {
        get {
            return label.textColor
        }
        set {
            label.textColor = newValue
        }
    }
    
    var font: UIFont {
        get {
            return label.font
        }
        set {
            label.font = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return label.textAlignment
        }
        set {
            label.textAlignment = newValue
        }
    }
    
    init(frame: CGRect = .zero, style: UIBlurEffect.Style = .dark) {
        super.init(frame: frame)
        addBlurEffect(with: style)
        label.backgroundColor = .clear
        textAlignment = .center
        addSubviews(subviews: label)
        label.makeFull(with: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IMBVerticalViewView: IMBView {
    let topView = UIView()
    let bottomView = UIView()
    
    private var privateHeightRatio: CGFloat = 1
    private var heightOfView: NSLayoutConstraint!
    var isActiveHeightRatio: Bool {
        get {
            return heightOfView.isActive
        }
        set {
            heightOfView.isActive = newValue
        }
    }
    

    var heightRatio: CGFloat {
        get {
            return privateHeightRatio
        }
        set {
            privateHeightRatio = newValue
            heightOfView.isActive = false
            heightOfView = topView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: newValue)
            heightOfView.isActive = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topViewBackgroundColor = .clear
        bottomViewBackgroundColor = .clear
        
        addSubviews(subviews: topView, bottomView)
        
        //both
        
        //vertical
        addConstraintsWith(format: "V:|[v0]", views: topView)
        addConstraintsWith(format: "V:[v0]|", views: bottomView)
        topConstraintOfBottomView = bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0)
        topConstraintOfBottomView.isActive = true
        
        heightOfView = topView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 1)
        heightOfView.isActive = true
        //horizontal
        //addSameConstraintsWith(format: "H:|[v0]|", for: topView, bottomView)
        leftConstraintOfTopView = topView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        leftConstraintOfTopView.isActive = true
        rightConstraintOfTopView = topView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        rightConstraintOfTopView.isActive = true
        
        leftConstraintOfBottomView = bottomView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        leftConstraintOfBottomView.isActive = true
        rightConstraintOfBottomView = bottomView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        rightConstraintOfBottomView.isActive = true
        
    }
    
    var leftConstraintOfTopView = NSLayoutConstraint()
    var rightConstraintOfTopView = NSLayoutConstraint()
    
    var topConstraintOfBottomView = NSLayoutConstraint()
    var leftConstraintOfBottomView = NSLayoutConstraint()
    var rightConstraintOfBottomView = NSLayoutConstraint()
    
    
    var spacing: CGFloat {
        get {
            return topConstraintOfBottomView.constant
        }
        set {
            topConstraintOfBottomView.constant = newValue
        }
    }
    
    func setLeftAndRightInsetsOfTopView(left: CGFloat, right: CGFloat) {
        leftConstraintOfTopView.constant = left
        rightConstraintOfTopView.constant = -right
        
    }
    
    func setLeftAndRightInsetsOfBottomView(left: CGFloat, right: CGFloat) {
        leftConstraintOfBottomView.constant = left
        rightConstraintOfBottomView.constant = -right
        
    }
    
    var topViewBackgroundColor: UIColor {
        get {
            return topView.backgroundColor!
        }
        set {
            topView.backgroundColor = newValue
        }
    }
    
    var bottomViewBackgroundColor: UIColor {
        get {
            return bottomView.backgroundColor!
        }
        set {
            bottomView.backgroundColor = newValue
        }
    }
    
    func setTopView(subview: UIView) {
        topView.addSubview(subview)
        subview.makeFullWithSuperView()
    }
    
    func setBottomView(subview: UIView) {
        bottomView.addSubview(subview)
        subview.makeFullWithSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class IMBVerticalLabelView: IMBVerticalViewView {
    let lblTitle = UILabel()
    
    var font: UIFont {
        get {
            return lblTitle.font
        }
        set {
            lblTitle.font = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return lblTitle.textAlignment
        }
        set {
            lblTitle.textAlignment = newValue
        }
    }
    
    var title: String {
        get {
            return lblTitle.text ?? ""
        }
        set {
            lblTitle.text = newValue
        }
    }
    
    var titleColor: UIColor {
        get {
            return lblTitle.textColor
        }
        set {
            lblTitle.textColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lblTitle.backgroundColor = .clear
        setTopView(subview: lblTitle)
        isActiveHeightRatio = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK CUSTOM BUTTON WITH SHADOW
class IMBButton: UIButton {
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width/2).cgPath
            shadowLayer.fillColor = backgroundColor?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.7
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }        
    }
}


public enum KeyboardLanguage: String {
    case en = "en"
    case vi = "vi"
}

class IMBTextView: UITextView {
    
    private func getKeyboardLanguage() -> String? {
        return defaultKeyboardLanguage?.rawValue // here you can choose keyboard any way you need
    }
    
    override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for tim in UITextInputMode.activeInputModes {
                if tim.primaryLanguage!.contains(language) {
                    return tim
                }
            }
        }
        return super.textInputMode
    }
    
    var defaultKeyboardLanguage: KeyboardLanguage? = .vi
    
    var placeHolder: String?
    
    var placeHolderFont: UIFont?
    
    var placeHolderColor: UIColor?
    
    var normalTextColor: UIColor?
    
    var normalFont: UIFont?
    
    var isShowPlaceHolder = true
    
    override var text: String! {
        didSet {
            textColor = normalTextColor ?? .black
            font = normalFont ?? UIFont.appFont(size: 16, weight: .regular)
            isShowPlaceHolder = false
        }
    }
    
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//    
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func setPlaceHolder() {
        text = placeHolder ?? ""
        textColor = placeHolderColor
        font = placeHolderFont
        //textAlignment = .left
        isShowPlaceHolder = true
    }
    
    let keyBoardAccessoryBar: UIToolbar = {
        let temp = UIToolbar()
//        temp.tintColor = UIColor.init(hexString: kIconTintColor)
        temp.frame = CGRect(x: 0, y: 0, width: widthOfScreen, height: 44)
        temp.backgroundColor = .white
        temp.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        temp.setShadowImage(UIImage(), forToolbarPosition: .any)
        return temp
    }()
    var doneButtonTitle = "Xong"
    func setReturnAccessoryView() {
        self.inputAccessoryView = keyBoardAccessoryBar
        let doneEditButton = UIBarButtonItem(title: doneButtonTitle, style: .done, target: self, action: #selector(handleEndEditing))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        keyBoardAccessoryBar.setItems([flexSpace, doneEditButton], animated: false)
    }
    
    @objc func handleEndEditing() {
        self.endEditing(true)
    }
    
    
}

class IMBNoDataLabelView: UIView {
    
    private let noDataLabel: UILabel = {
        let temp = UILabel()
        temp.backgroundColor = .clear
        temp.textAlignment = .center
        temp.numberOfLines = 0
        return temp
    }()
    var noDataText: String? {
        get {
            return noDataLabel.text
        }
        set {
            noDataLabel.text = newValue
        }
    }
    
    var noDataFont: UIFont {
        get {
            return noDataLabel.font
        }
        set {
            noDataLabel.font = newValue
        }
    }
    
    var noDataTextAlignment: NSTextAlignment {
        get {
            return noDataLabel.textAlignment
        }
        set {
            noDataLabel.textAlignment = newValue
        }
    }
    
    var textColor: UIColor {
        get {
            return noDataLabel.textColor
        }
        set {
            noDataLabel.textColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.addSubview(noDataLabel)
        
        addSubview(contentView)
        
        addConstraint(NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        
        contentView.makeRatio(ratio: 0.9, with: self)
        noDataLabel.makeCenter(with: contentView)
        contentView.addConstraintsWith(format: "V:|[v0]|", views: noDataLabel)
        contentView.addConstraintsWith(format: "H:|[v0]|", views: noDataLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class IMBNoDataView: IMBView {
//    private let lblTitle = UILabel()
//    private let imageView: UIImageView = {
//        let temp = UIImageView()
//        temp.contentMode = .scaleAspectFit
//        temp.backgroundColor = .clear
//        temp.clipsToBounds = true
//        return temp
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(imageView)
//        addSubview(lblTitle)
//        
//        addConstraintsWith(format: "H:|-50-[v0]-50-|", views: imgView)
//        addConstraintsWith(format: "H:|-20-[v0]-20-|", views: lblTitle)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
