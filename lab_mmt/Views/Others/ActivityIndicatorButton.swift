//
//  IndicatorButton.swift
//  MysteryChat
//
//  Created by Imbaggaarm on 8/1/18.
//  Copyright © 2018 Tai Duong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

/**
 This class create object has an activity view. Should be used in network requests.
 */
open class ActivityIndicatorButton: UIControl {
    
    /// Determine if is showing animation or not.
    private var isAnimating = false {
        didSet {
            if isAnimating { isUserInteractionEnabled = false }
            else { isUserInteractionEnabled = true }
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            button.isEnabled = isEnabled
        }
    }
    
    /// The button that tricks the user interaction events, and appearance of this view, like titleLabel, isHighlighted,...
    private let button: UIButton = {
        let temp = UIButton()
        return temp
    }()
    
    /// Represent for titleLabel of button.
    var titleLabel: UILabel? {
        return button.titleLabel
    }
    
    /// View cover button default content, when but is animation, this view is showed, otherwise, this view is hidden.
    private var indicatorBackgroundView: UIView = {
        let temp = UIView()
        temp.isHidden = true
        return temp
    }()
    
    /// An instance of NVActivityIndicatorView, show animation when button should show animation.
    private let indicatorView: NVActivityIndicatorView = {
        let temp = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: .black, padding: nil)
        return temp
    }()
    
    
    /// Set indicatorBackgroundView background color and indicatorView color when set backgroundColor.
    override open var backgroundColor: UIColor? {
        didSet {
            if let color = backgroundColor {
                indicatorBackgroundView.backgroundColor = backgroundColor
                indicatorView.color = color == AppColor.themeColor ? .black : AppColor.themeColor
            }
        }
    }
    
    /// Default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        addSubviews(subviews: button, indicatorBackgroundView, indicatorView)
        button.makeFullWithSuperView()
        indicatorBackgroundView.makeFullWithSuperView()
        
    }
    
    /// Start animation, show indicatorBackgroundView and start indicatorView animation.
    func startAnimating() {
        indicatorBackgroundView.isHidden = false
        indicatorView.startAnimating()
        isAnimating = true
    }
    
    /// Stop animation, hide indicatorBackgroundView and stop indicatorView animation.
    func stopAnimating() {
        indicatorBackgroundView.isHidden = true
        indicatorView.stopAnimating()
        isAnimating = false
    }
    
    /// Set title for button.
    open func setTitle(_ title: String?, for state: UIControl.State) {
        button.setTitle(title, for: state)
    }
    
    /// Set titleColor for button.
    open func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        button.setTitleColor(color, for: state)
    }
    
    /// Set indicatorView frame, make center with superview and size of each edge = 1/2 height of super view.
    func setIndicatorViewFrame(width: CGFloat, height: CGFloat) {
        let indicatorViewEdgeSize: CGFloat = height/2
        let frame = CGRect.init(x: width/2 - indicatorViewEdgeSize/2, y: height/2 - indicatorViewEdgeSize/2, width: indicatorViewEdgeSize, height: indicatorViewEdgeSize)
        indicatorView.frame = frame
    }
    
    /// Trick add target for button.
    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        super.addTarget(target, action: action, for: controlEvents)
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    /// Default required init(coder:).
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
