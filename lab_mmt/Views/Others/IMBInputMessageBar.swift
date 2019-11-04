//
//  IMBInputMessageBar.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 7/14/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit

@objc protocol InputMessageBarDelegate {
    @objc func inputMessageBarDidTapButtonEmoji()
    @objc func inputMessageBarDidTapButtonSendMessage()
    @objc func inputMessageBarDidTapButtonFastEmoji()
    @objc func inputMessageBarDidTapButtonPickImage()
    @objc func inputMessageBarDidTapButtonCamera()
    @objc optional func inputMessageBarTxtVDidBecomeFirstResponder()
    @objc optional func inputMessageBarTxtVDidResignFirstResponder()
}

class IMBInputMessageBar: UIView {
    
    weak var delegate: InputMessageBarDelegate?
    
    lazy var inputContentView: IMBInputContentView = {
        let temp = IMBInputContentView()
        temp.inputMessageBar = self
        temp.contentMode = .top
        return temp
    }()
    
    let pickerContentView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .clear
        return temp
    }()
    
    let bottomView: UIView = {
        let temp = UIView()
        temp.backgroundColor = .clear
        return temp
    }()
    
    let whiteBackgroundView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.init(white: 0, alpha: 1)
        return temp
    }()

    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .top
        backgroundColor = UIColor.clear
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var heightOfMessageBar: CGFloat = 60
    
    var heightConstraintOfPickerContentView: NSLayoutConstraint?
    
    func setUpLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = .flexibleHeight
        
        addSubviews(subviews: whiteBackgroundView, inputContentView)
        whiteBackgroundView.makeFullWithSuperView()

        inputContentView.makeFullWidthWithSuperView()
        
        let bottom = bottomAnchor.constraint(equalTo: inputContentView.bottomAnchor, constant: 0)
        bottom.priority = UILayoutPriority.init(750)
        bottom.isActive = true
        
        let top = topAnchor.constraint(equalTo: inputContentView.topAnchor, constant: 0)
        top.priority = UILayoutPriority.init(rawValue: 750)
        top.isActive = true
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window = window else { return }
        
        inputContentView.bottom?.isActive = false
        inputContentView.bottom = inputContentView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
        inputContentView.bottom?.isActive = true
    }
    
    func sendTextMessage() {
        inputContentView.txtVInputMessage.text = ""
        //inputContentView.showButFastEmoji()
        inputContentView.textViewDidChange(inputContentView.txtVInputMessage)
    }
}

class IMBInputContentView: UIView, UITextViewDelegate {
    
    weak var inputMessageBar: IMBInputMessageBar?
    
    //view contains txtVInputMessage and butEmoji
    let inputMessageContentView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.init(hexString: "#101213")
        temp.layer.cornerRadius = 20
        temp.clipsToBounds = true
        return temp
    }()
    
    lazy var txtVInputMessage: IMBTextView = {
        let temp = IMBTextView()
        temp.placeHolderFont = UIFont.systemFont(ofSize: 18)
        temp.placeHolderColor = .gray
        temp.normalFont = UIFont.systemFont(ofSize: 18)
        temp.normalTextColor = UIColor.white
        temp.backgroundColor = .clear
        temp.placeHolder = "Aa"
        temp.setPlaceHolder()
        temp.delegate = self
        temp.isScrollEnabled = false
        temp.showsVerticalScrollIndicator = false
        return temp
    }()
    
    let butEmoji: UIButton = {
        let temp = UIButton()
        temp.clipsToBounds = true
        temp.isSelected = false
        temp.setImage(nil, for: .normal)
        return temp
    }()
    
    let butFastEmoji: UIButton = {
        let temp = UIButton()
        temp.clipsToBounds = true
        return temp
    }()
    
    let butSendMessage: UIButton = {
        let temp = UIButton()
        temp.clipsToBounds = true
        temp.isHidden = true
        return temp
    }()
    
    let butScaleDownTextView: UIButton = {
        let temp = UIButton()
        temp.clipsToBounds = true
        temp.backgroundColor = .blue
        temp.layer.cornerRadius = 12.5
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isHidden = true
        temp.setBackgroundImage(AppIcon.scaleDownTxtVInputMessage, for: .normal)
        return temp
    }()
    
    let butCamera: UIButton = {
        let temp = UIButton()
        temp.clipsToBounds = true
        return temp
    }()
    
//    let butPickImage: UIButton = {
//        let temp = UIButton()
//        temp.clipsToBounds = true
//        return temp
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        
//        let bounds = CGRect.init(x: 0, y: 0, width: widthOfScreen, height: 60)
//        addBlurEffect(with: .light, bounds: bounds)
        
        
        
//        butScaleDownTextView.addTarget(self, action: #selector(handleScaleDownTxtV), for: .touchUpInside)
        butEmoji.addTarget(self, action: #selector(handleTapButEmoji), for: .touchUpInside)
        butFastEmoji.addTarget(self, action: #selector(handleTapButFastEmoji), for: .touchUpInside)
        butCamera.addTarget(self, action: #selector(handleTapButCamera), for: .touchUpInside)
//        butPickImage.addTarget(self, action: #selector(handleTapButPickImage), for: .touchUpInside)
        butSendMessage.addTarget(self, action: #selector(handleTapButSendMessage), for: .touchUpInside)
        
//        butPickImage.isHidden = false
        butCamera.isHidden = false
        butScaleDownTextView.isHidden = true
    }

    
    let butWidth: CGFloat = 25
    let spacing: CGFloat = {
        if AppConstant.myScreenType == .iPhone5 {
            return 10
        }
        return 20
    }()
    var widthConstraintOfButScaleDownTextView: NSLayoutConstraint?
    var leftConstraintOfInputMessageContentView: NSLayoutConstraint?
    var heightConstraintOfTxtVInputMessage: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var textViewIsScaleUp: Bool = false
    
    func setUpLayout() {
        
        translatesAutoresizingMaskIntoConstraints = false
        //autoresizingMask = .flexibleHeight
        if #available(iOS 11.0, *) {
            bottom = bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            bottom?.isActive = true
        } else {
            bottom = bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            bottom?.isActive = true
        }
        addSubviews(subviews: butCamera, butScaleDownTextView, inputMessageContentView, butFastEmoji, butSendMessage)
        
        addConstraintsWith(format: "H:|-\(spacing)-[v0]", views: butCamera)
        
        addConstraintsWith(format: "H:[v0]-\(spacing)-[v1]-\(spacing)-|", views: inputMessageContentView, butFastEmoji)
        
        leftConstraintOfInputMessageContentView = inputMessageContentView.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing*2 + butWidth)
        leftConstraintOfInputMessageContentView?.isActive = true
        
        butCamera.makeSquare(size: butWidth)
        butFastEmoji.makeEqual(with: butCamera)
        butSendMessage.makeEqual(with: butCamera)
        butSendMessage.makeCenter(with: butFastEmoji)
        
        butScaleDownTextView.makeSquare(size: 25)
        butScaleDownTextView.makeCenter(with: butCamera)
        
        
        let butCamereBottom = butCamera.bottomAnchor.constraint(equalTo: inputMessageContentView.bottomAnchor, constant: -7.5)
        butCamereBottom.priority = UILayoutPriority.init(rawValue: 750)
        butCamereBottom.isActive = true
        
        butFastEmoji.bottomAnchor(equalTo: butCamera.bottomAnchor)
        
        
        addConstraintsWith(format: "V:|-10-[v0]", views: inputMessageContentView)
        let inputVBottom = inputMessageContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        inputVBottom.priority = UILayoutPriority.init(rawValue: 750)
        inputVBottom.isActive = true
        //inputMessageContentView.bottomAnchor(equalTo: layoutMarginsGuide.bottomAnchor, constant: -5)
        setUpInputMessageContentViewLayout()
        
    }
    
    func setUpInputMessageContentViewLayout() {
        inputMessageContentView.addSubviews(subviews: txtVInputMessage, butEmoji)
        inputMessageContentView.addConstraintsWith(format: "H:|-10-[v0]-5-[v1]-5-|", views: txtVInputMessage, butEmoji)
        inputMessageContentView.addConstraintsWith(format: "V:|[v0]|", views: txtVInputMessage)
        
        
        butEmoji.bottomAnchor(equalTo: inputMessageContentView.bottomAnchor, constant: -7.5)
        butEmoji.makeSquare(size: 25)
        
        heightConstraintOfTxtVInputMessage = txtVInputMessage.heightAnchor.constraint(equalToConstant: 0)
        heightConstraintOfTxtVInputMessage?.constant = 40
        heightConstraintOfTxtVInputMessage?.isActive = true
        
        
        setImageForButtons()

    }
    
    func setImageForButtons() {
        butCamera.setImage(AppIcon.attachmentIcon, for: .normal)
        
        butFastEmoji.setImage(AppIcon.fastEmojiTest, for: .normal)
        
        butSendMessage.setImage(AppIcon.sendMessage, for: .normal)
        
//        butPickImage.setImage(AppIcon.unSelectedImageIcon, for: .normal)
//        butPickImage.setImage(AppIcon.selectedImageIcon, for: .selected)
        
        butEmoji.setImage(AppIcon.emojiTest, for: .normal)
        butEmoji.setImage(AppIcon.fillEmoji, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVInputMessage.isShowPlaceHolder {
            txtVInputMessage.text = ""
        }
        if !textViewIsScaleUp {
//            handleScaleUpTxtV()
        }
        
        inputMessageBar?.delegate?.inputMessageBarTxtVDidBecomeFirstResponder?()
        
        if butEmoji.isSelected {
            butEmoji.isSelected = false
        }
        
//        if butPickImage.isSelected {
//            butPickImage.isSelected = false
//        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let height = newSize.height
        //print(height)
        //let heightConstrantOfInputView = self.superview!.superview!.constraints[0]
        
        if height > 100 {
            if !textView.isScrollEnabled {
                heightConstraintOfTxtVInputMessage?.constant = 100
                textView.isScrollEnabled = true
            }
        } else {
            if textView.isScrollEnabled {
                if height < 40 {
                    heightConstraintOfTxtVInputMessage?.constant = 40
                } else {
                    heightConstraintOfTxtVInputMessage?.constant = height
                }
                textView.isScrollEnabled = false
            } else {
                if Int(height) <= 40 {
                    heightConstraintOfTxtVInputMessage?.constant = 40
                } else {
                    heightConstraintOfTxtVInputMessage?.constant = height
                }
            }
        }
        
        //set height of message bar
        inputMessageBar?.heightOfMessageBar = heightConstraintOfTxtVInputMessage!.constant + 20
        //print(heightConstraintOfTxtVInputMessage!.constant + 20)
        UIView.performWithoutAnimation {
            self.layoutIfNeeded()
        }
//        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCurlUp, animations: {
//
//        }, completion: nil)
        
        if butScaleDownTextView.isHidden {
//            handleScaleUpTxtV()
        }
        
        if textView.text != "" {
            if !butFastEmoji.isHidden {
                showButSendMessage()
            }
        } else {
            if butFastEmoji.isHidden {
                showButFastEmoji()
            }
        }
    }
    
    func showButFastEmoji() {
        handleChangeRightButton(isShowButSendMessage: false)
        animateButton(button: butFastEmoji)
    }
    
    func showButSendMessage() {
        handleChangeRightButton(isShowButSendMessage: true)
        animateButton(button: butSendMessage)
    }
    
    func handleChangeRightButton(isShowButSendMessage: Bool) {
        butFastEmoji.isHidden = isShowButSendMessage
        butSendMessage.isHidden = !isShowButSendMessage
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            txtVInputMessage.setPlaceHolder()
        }
        
//        handleScaleDownTxtV()
        
        inputMessageBar?.delegate?.inputMessageBarTxtVDidResignFirstResponder?()
    }
    
    func animateButton(button: UIButton) {
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.4),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        button.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  })
    }
    
    func popButton(sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            //
            sender.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8, options: .curveEaseOut, animations: {
                sender.layer.transform = CATransform3DIdentity
            }, completion: nil)
        })
        
    }

    
//    @objc func handleScaleDownTxtV() {
//        leftConstraintOfInputMessageContentView?.constant = spacing*3 + butWidth*2
//        butCamera.isHidden = false
////        butPickImage.isHidden = false
//        butScaleDownTextView.isHidden = true
//        animateButton(button: butScaleDownTextView)
//        defer { textViewIsScaleUp = false }
//        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
//            self.butCamera.alpha = 1
////            self.butPickImage.alpha = 1
//            self.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//    @objc func handleScaleUpTxtV() {
//        leftConstraintOfInputMessageContentView?.constant = spacing*2 + butWidth
//        butScaleDownTextView.isHidden = false
//        defer { textViewIsScaleUp = true }
//        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
//            self.butCamera.alpha = 0
//            self.butPickImage.alpha = 0
//            self.layoutIfNeeded()
//        }, completion: { _ in
//            self.butCamera.isHidden = true
//            self.butPickImage.isHidden = true
//        })
//
//        animateButton(button: butScaleDownTextView)
//    }
    
    @objc func handleTapButEmoji() {
        butEmoji.isSelected = !butEmoji.isSelected
        if butEmoji.isSelected {
            inputMessageBar?.delegate?.inputMessageBarDidTapButtonEmoji()
        } else {
            txtVInputMessage.becomeFirstResponder()
        }
    }
    
    @objc func handleTapButFastEmoji() {
        popButton(sender: butFastEmoji)
        inputMessageBar?.delegate?.inputMessageBarDidTapButtonFastEmoji()
    }
    
    @objc func handleTapButSendMessage() {
        popButton(sender: butSendMessage)
        inputMessageBar?.delegate?.inputMessageBarDidTapButtonSendMessage()
    }
    
    @objc func handleTapButCamera() {
        inputMessageBar?.delegate?.inputMessageBarDidTapButtonCamera()
    }
    
//    @objc func handleTapButPickImage() {
//        butPickImage.isSelected = !butPickImage.isSelected
//
//        if butPickImage.isSelected {
//            inputMessageBar?.delegate?.inputMessageBarDidTapButtonPickImage()
//        } else {
//            txtVInputMessage.becomeFirstResponder()
//        }
//    }
    
    
}





