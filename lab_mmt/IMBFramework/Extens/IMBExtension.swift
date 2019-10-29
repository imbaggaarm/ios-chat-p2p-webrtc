//
//  FunctionalProgrammingSwift.swift
//  appLayoutMP3ZING
//
//  Created by Tai Duong on 12/9/16.
//  Copyright © 2016 Tai Duong. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


//let widthOfScreen = UIScreen.main.bounds.size.width


var widthOfScreen: CGFloat = UIScreen.main.bounds.size.width
var heightOfScreen: CGFloat = UIScreen.main.bounds.size.height

extension UIImageView
{
    public func loadImageFromURL(urlString: String)
    {
        let url: URL = URL(string: urlString)!
        do
        {
            let data: Data = try Data(contentsOf: url)
            self.image = UIImage(data: data)
        }
        catch
        {
            print("LOAD IMAGE ERROR!");
        }        
        
    }
    public func loadImageFromURLWithMultiThreading(urlString: String)
    {
        
        let indicator: UIActivityIndicatorView = {
            let temp = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
            temp.color = UIColor.init(white: 0.9, alpha: 1)
            temp.translatesAutoresizingMaskIntoConstraints = false
            return temp
        }()
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.startAnimating()
        
        let queue = DispatchQueue(label: "queue")
        queue.async {
            if let url: URL = URL(string: urlString)
            {
                do
                {
                    let data: Data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                        indicator.stopAnimating()
                        indicator.hidesWhenStopped = true
                    }
                }
                catch
                {
                    
                }
            }

        }
    }
}
//extension UIView
//{
//    func addConstraintsWithFormat(format: String, views: UIView...)
//    {
//        var dic = Dictionary<String, UIView>()
//        for view in views
//        {
//            let key = "v\(views.index(of: view))"
//            view.translatesAutoresizingMaskIntoConstraints = false
//            dic[key] = view
//        }
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dic))
//    }
//}


extension UIImage {
    
    func getSizeOfImageAfterAspectFit(estimatedWidth: CGFloat?, estimatedHeight: CGFloat?) -> CGSize {
        let imageSize = self.size
        if estimatedWidth != nil {
            let height = imageSize.height/imageSize.width * estimatedWidth!
            return CGSize(width: estimatedWidth!, height: height)
            
        } else if estimatedHeight != nil {
            let width = imageSize.width/imageSize.height * estimatedHeight!
            return CGSize(width: width, height: estimatedHeight!)
        }
        return CGSize(width: 0, height: 0)
    }
    
}
extension UIView
{
    func addConstraintsWith(format: String, views: UIView...)
    {
        var dic = Dictionary<String, UIView>()
        for (index, view) in views.enumerated()
        {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            dic[key] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dic))
    }
    
    func addConstraintsWith(format: String, views: [UIView])
    {
        var dic = Dictionary<String, UIView>()
        for (index, view) in views.enumerated()
        {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            dic[key] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dic))
    }
    
    func addSameContraintsWith(format: String, forColOfViewGroup viewCol: [UIView]...)
    {
        for i in viewCol
        {
            addConstraintsWith(format: format, views: i)
        }
    }
    
    func addBlurEffect(with effect: UIBlurEffect.Style, bounds: CGRect = .zero)
    {
        let blurEffect = UIBlurEffect.init(style: effect)
        let effectV = UIVisualEffectView.init(effect: blurEffect)
        self.addSubview(effectV)
        self.sendSubviewToBack(effectV)
        self.backgroundColor = .clear
        if bounds == .zero {
            effectV.frame = self.bounds
        } else {
            effectV.frame = bounds
        }
        effectV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func addSubviews(subviews: UIView...)
    {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    func addSameConstraintsWith(format: String, for views: UIView...)
    {
        for view in views
        {
            addConstraintsWith(format: format, views: view)
        }
    }
    
    func addShadow(color: UIColor, radius: CGFloat, shadowOffSet: CGSize = .zero)
    {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = shadowOffSet
        layer.shadowRadius = radius
        layer.shouldRasterize = false
    }
    
    func addRightLayer(color: UIColor = .black, width: CGFloat = 1)
    {
        let rightLine = UIView()
        self.addSubview(rightLine)
        rightLine.backgroundColor = color
        self.addConstraintsWith(format: "V:|[v0]|", views: rightLine)
        self.addConstraintsWith(format: "H:[v0(\(width))]|", views: rightLine)
    }
    
    //MARK: addConstraints
    func makeSquare(size: CGFloat = 0)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        if size != 0
        {
            self.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
    }
    func makeRectangle(heightPerWidth: CGFloat, size: CGFloat = 0)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: heightPerWidth).isActive = true

        if size != 0
        {
            self.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
    }
    
    func makeRectangle(width: CGFloat, height: CGFloat)
    {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func makeCircle(corner: CGFloat)
    {
        if corner != 0
        {
            makeSquare(size: corner*2)
        }
        else
        {
            makeSquare()
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner
    }
    
    func makeCenter(with view: UIView)
    {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func makeFull(with view: UIView)
    {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWith(format: "V:|[v0]|", views: self)
        view.addConstraintsWith(format: "H:|[v0]|", views: self)
    }
    
    func makeRatio(ratio: CGFloat, with view: UIView, isSquare: Bool = false)
    {
        translatesAutoresizingMaskIntoConstraints = false
        if isSquare
        {
            makeSquare()
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ratio).isActive = true
            return
        }
        
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ratio).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ratio).isActive = true
    }
    
    
    func makeEqual(with view: UIView)
    {
        makeRatio(ratio: 1, with: view)
    }
    
    func makeFullWidth(with view: UIView)
    {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWith(format: "H:|[v0]|", views: self)
    }

    func makeFullHeight(with view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWith(format: "V:|[v0]|", views: self)
    }
    
    func makeFullWithSuperView() {
        makeFull(with: self.superview!)
    }
    
    func makeFullWidthWithSuperView() {
        makeFullWidth(with: self.superview!)
    }
    func makeFullHeightWithSuperView(){
        makeFullHeight(with: self.superview!)
    }
    
    func height(constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func width(constant: CGFloat) {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func centerXAnchor(with view: UIView, constant: CGFloat = 0) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    
    func centerYAnchor(with view: UIView, constant: CGFloat = 0) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    func bottomAnchor(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func topAnchor(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0) {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func leftAnchor(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0) {
        leftAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func rightAnchor(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0) {
        rightAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func widthAnchor(equalTo dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: constant).isActive = true
    }
    
    func heightAnchor(equalTo dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: constant).isActive = true
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, bounds: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UILabel
{
    class func setLbl(backgroundColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, isClips: Bool, title: String, font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) -> UILabel
    {
        let temp = UILabel()
        temp.backgroundColor = backgroundColor
        temp.layer.cornerRadius = cornerRadius
        temp.clipsToBounds = isClips
        temp.layer.borderColor = borderColor.cgColor
        temp.layer.borderWidth = borderWidth
        temp.text = title
        temp.font = font
        temp.textColor = textColor
        temp.textAlignment = textAlignment
        return temp
    }
    
    convenience init(backgroundColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, isClips: Bool, title: String, font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = isClips
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.text = title
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}
extension UIColor
{
    class func rgb(red:CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1);
    }
    class func rgba(red:CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor
    {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha);
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func colorFromHexstring (hex:String, alpha: CGFloat = 1) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(hexString: String, withAlpha alpha: CGFloat) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }

    static func getRandomColor() -> UIColor{
        
        let randomRed  = CGFloat(drand48())
        
        let randomGreen = CGFloat(drand48())
        
        let randomBlue = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}

extension UITextField
{
    
    convenience init(placeHolder: String = "", cornerRadius: CGFloat = 5, backGroundColor: UIColor = UIColor.white, txtColor: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 20), borderWidth: CGFloat = 0, borderColor: UIColor = .white, leftPaddingWidth: CGFloat = 4, keyboardType: UIKeyboardType = UIKeyboardType.alphabet) {
        self.init()
        self.backgroundColor = backGroundColor
        self.placeholder = placeHolder
        self.setLeftPadding(width: leftPaddingWidth)
        self.textColor = txtColor
        self.layer.cornerRadius = cornerRadius
        self.font = font
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.keyboardType = keyboardType
        self.clipsToBounds = true
    }
    
    func setLeftPadding(width: CGFloat)
    {
        let leftView = UIView()
        self.addSubview(leftView)
        self.leftView = leftView
        self.leftViewMode = .always
        leftView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
    }
    class func initWith(placeHolder: String = "", cornerRadius: CGFloat = 5, backGroundColor: UIColor = UIColor.white, txtColor: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 20), borderWidth: CGFloat = 0, borderColor: UIColor = .white, leftPaddingWidth: CGFloat = 4, keyboardType: UIKeyboardType = UIKeyboardType.alphabet) -> UITextField
    {
        let temp = UITextField()
        temp.backgroundColor = backGroundColor
        temp.placeholder = placeHolder
        temp.setLeftPadding(width: leftPaddingWidth)
        temp.textColor = txtColor
        temp.layer.cornerRadius = cornerRadius
        temp.font = font
        temp.layer.borderColor = borderColor.cgColor
        temp.layer.borderWidth = borderWidth
        temp.keyboardType = keyboardType
        temp.clipsToBounds = true
        
        return temp
    }
    
    func alertError(error: String, borderColor: UIColor = UIColor.init(hexString: "#D0021B"), txtColor: UIColor = UIColor.init(hexString: "#D0021B"), font: UIFont = UIFont.appFont(size: 15, weight: .regular))
    {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 0.5
//        placeholder = error
        attributedPlaceholder = NSAttributedString.init(string: error, attributes: [NSAttributedString.Key.foregroundColor: txtColor, NSAttributedString.Key.font: font])
    }
    
//    func setReturnAccessoryView(title: String = "Xong", tintColor: UIColor = AppColors.themeColor) {
//        let accessoryBar = UIToolbar()
//        //accessoryBar.shadowImage(forToolbarPosition: .any)
//        accessoryBar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
//        accessoryBar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
//        accessoryBar.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
//        accessoryBar.frame = CGRect(x: 0, y: 0, width: widthOfScreen, height: 44)
//        accessoryBar.tintColor = tintColor
//        let doneButton = UIBarButtonItem.init(title: title, style: .done, target: self, action: #selector(handleEndEditting))
//        //doneButton.tintColor =
//        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        accessoryBar.setItems([flexSpace, doneButton], animated: false)
//        self.inputAccessoryView = accessoryBar
//    }
    
    @objc func handleEndEditting() {
        self.endEditing(true)
    }
}

@objc extension UIViewController
{
    
    func letsAlertError(withError error: String, title: String = "Thông báo", completion: ((UIAlertAction) -> Void)? = nil ) {
        let alertVC = UIAlertController.init(title: title, message: error, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: completion)
        alertVC.addAction(ok)
        present(alertVC, animated: true, completion: nil)
    }
    
    func letsAlertFirebaseError() {
        letsAlertError(withError: "Đã xảy ra lỗi. Hãy thử thực hiện lại tác vụ bạn nhé.")
    }
    
    func letsAlertNeedSupportError() {
        letsAlertError(withError: "Đã xảy ra lỗi. Vui lòng liên hệ với chúng tôi qua email để được trợ giúp. Xin lỗi vì sự bất tiện này.")
    }
    
    func letsAlertWithCancelOption(title: String = "Thông báo", message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "Huỷ", style: .cancel, handler: nil)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: completion)
        alertVC.addAction(ok)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
    }

    func letsAlertConnectionError() {
        letsAlertError(withError: "Kết nối mạng tạm thời không hoạt động. Xin vui lòng thực hiện lại tác vụ khi kết nối đã sẵn sàng.")
    }
    
    func letsAlert(withMessage message: String) {
        letsAlertError(withError: message)
    }
    
    func letsAlert(withMessage message: String, title: String = "Thông báo", completion: ((UIAlertAction) -> Void)? = nil ) {
        letsAlertError(withError: message, title: title, completion: completion)
    }
    
    func dismissMySelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissWithEndEditing() {
        self.view.endEditing(true)
        dismissMySelf()
    }
    
    func animateBeforeDismiss() {
    }

    func showData() {
        
    }
    
    func setStatusBarHidden(isHidden: Bool) {
        let app = UIApplication.shared
        app.isStatusBarHidden = isHidden
    }
    
    func setStatusBarStyle(style: UIStatusBarStyle) {
        let app = UIApplication.shared
        app.statusBarStyle = style
    }
}

extension Dictionary
{
    func convertDicToParamType() -> String
    {
        var resultString = ""
        for (index, i) in self.enumerated()
        {
            if index == 0
            {
                resultString += "\(i.key)=\(i.value)"
            }
            else
            {
                resultString += "&\(i.key)=\(i.value)"
            }
        }
        return resultString
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}


extension UIButton
{
    class func initWithGhostButton(title: String, titleColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat = 0, titleFont: UIFont = .systemFont(ofSize: 20)) -> UIButton
    {
        let temp = UIButton(type: .custom)
        temp.setTitle(title, for: .normal)
        temp.setTitleColor(titleColor, for: .normal)
        temp.layer.borderColor = titleColor.cgColor
        temp.layer.cornerRadius = cornerRadius
        temp.layer.borderWidth = borderWidth
        temp.titleLabel?.font = titleFont
        temp.clipsToBounds = true
        temp.backgroundColor = .clear
        return temp
    }
}

extension UIViewController
{
    
}

extension Array
{
    static func mapBoxFormatArrayCLLocation(arrDouble: Array<Array<Double>>) -> [CLLocationCoordinate2D]
    {
        var resultArray = [CLLocationCoordinate2D]()
        for i in arrDouble
        {
            let coor = CLLocationCoordinate2D(latitude: i[1], longitude: i[0])
            resultArray.append(coor)
        }
        return resultArray
    }
    
    static func formatFromArrDoubleToCLLocationCoordinate2D(arrDouble: Array<Array<Double>>) -> [CLLocationCoordinate2D]
    {
        var resultArray = [CLLocationCoordinate2D]()
        for i in arrDouble
        {
            let coor = CLLocationCoordinate2D(latitude: i[0], longitude: i[1])
            resultArray.append(coor)
        }
        return resultArray
    }
    
    static func formatFromCLLocationCoordinate2DToDouble(arrCoor: Array<CLLocationCoordinate2D>) -> [[Double]]
    {
        var result: Array<Array<Double>> = []
        for i in arrCoor
        {
            let smallArray = [i.latitude, i.longitude]
            result.append(smallArray)
        }
        return result
    }
    
    mutating func append(elements: Element...)
    {
        append(contentsOf: elements)
    }
    
    func takeElements( elementCount: Int) -> Array {
        var elementCount = elementCount
        if (elementCount > count) {
            elementCount = count
        }
        return Array(self[0..<elementCount])
    }

}

extension Int64 {
    func toString() -> String {
        return "\(self)"
    }
    func toInt() -> Int {
        return Int(self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
}

extension Int16 {
    
    func toInt() -> Int {
        return Int(self)
    }
}

extension SignedInteger {
    func toString() -> String {
        return "\(self)"
    }
}


extension UICollectionView {
    func selectAllItems(in section: Int, scrollPosition: UICollectionView.ScrollPosition = .centeredVertically) {
        for i in 0..<numberOfItems(inSection: section) {
            selectItem(at: IndexPath.init(item: i, section: section), animated: true, scrollPosition: scrollPosition)
        }
    }
    
    
}

extension Double {
    func roundToPlaces(places: Int) -> Double {
        return (self * pow(10, Double(places))).rounded() / pow(10, Double(places))
    }
    
    static func getPercent(value: Int64, total: Int64) -> Double {
        let result = Double(value) / Double(total) * 100
        return result.roundToPlaces(places: 2)
    }
    
    func toString() -> String {
        return "\(self)"
    }
    
}


public extension UIDevice {
    
    var modelName: DeviceModel {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return .iPod5
        case "iPod7,1":                                 return .iPod6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone4
        case "iPhone4,1":                               return .iPhone4s
        case "iPhone5,1", "iPhone5,2":                  return .iPhone5
        case "iPhone5,3", "iPhone5,4":                  return .iPhone5c
        case "iPhone6,1", "iPhone6,2":                  return .iPhone5s
        case "iPhone7,2":                               return .iPhone6
        case "iPhone7,1":                               return .iPhone6Plus
        case "iPhone8,1":                               return .iPhone6s
        case "iPhone8,2":                               return .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3":                  return .iPhone7
        case "iPhone9,2", "iPhone9,4":                  return .iPhone7Plus
        case "iPhone8,4":                               return .iPhone5SE
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return .iPadAir
        case "iPad5,3", "iPad5,4":                      return .iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":           return .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return .iPadMini3
        case "iPad5,1", "iPad5,2":                      return .iPadMini4
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return .iPadPro
        case "AppleTV5,3":                              return .appleTV
        case "i386", "x86_64":                          return .simulator
        default:                                        return .unIdentified
        }
    }
    
    enum DeviceModel: String {
        
        case iPod5 = "iPod Touch 5"
        case iPod6 = "iPod Touch 6"
        case iPhone4 = "iPhone 4"
        case iPhone4s = "iPhone 4s"
        case iPhone5 = "iPhone 5"
        case iPhone5c = "iPhone 5c"
        case iPhone5s = "iPhone 5s"
        case iPhone5SE = "iPhone SE"
        case iPhone6 = "iPhone 6"
        case iPhone6Plus = "iPhone 6 Plus"
        case iPhone6s = "iPhone 6s"
        case iPhone6sPlus = "iPhone 6s Plus"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
        case iPad2 = "iPad 2"
        case iPad3 = "iPad 3"
        case iPad4 = "iPad 4"
        case iPadAir = "iPad Air"
        case iPadAir2 = "iPad Air 2"
        case iPadMini = "iPad Mini"
        case iPadMini2 = "iPad Mini 2"
        case iPadMini3 = "iPad Mini 3"
        case iPadMini4 = "iPad Mini 4"
        case iPadPro = "iPad Pro"
        case appleTV = "Apple TV"
        case simulator = "Simulator"
        case unIdentified = "unIdentified"
        
    }
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: Int {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case unknown
    }
    
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        print(UIScreen.main.nativeBounds.height)
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1920, 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}



extension UIFont {
    
    static func appFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    static func helveticaNeue(size: CGFloat, type: HelveType) -> UIFont {
        return UIFont.init(name: type.rawValue, size: size)!
    }

    
    enum HelveType: String {
        case bold = "HelveticaNeue-Bold"
        case light = "HelveticaNeue-Light"
        case italic = "HelveticaNeue-Italic"
        case medium = "HelveticaNeue-Medium"
        case ultraLight = "HelveticaNeue-UltraLight"
        case condensedBlack = "HelveticaNeue-CondensedBlack"
        case boldItalic = "HelveticaNeue-BoldItalic"
        case thin = "HelveticaNeue-Thin"
        case thinItalic = "HelveticaNeue-ThinItalic"
        case lightItalic = "HelveticaNeue-LightItalic"
        case ultraLightItalic = "HelveticaNeue-UltraLightItalic"
        case mediumItalic = "HelveticaNeue-MediumItalic"
        case normal = "HelveticaNeue"
    }
    
    class func avenirNext(size: CGFloat, type: AvenirNextType) -> UIFont {
        return UIFont.init(name: type.rawValue, size: size)!
    }

    enum AvenirNextType: String {
        case mediumItalic = "AvenirNext-MediumItalic"
        case bold = "AvenirNext-Bold"
        case ultraLight = "AvenirNext-UltraLight"
        case demiBold = "AvenirNext-DemiBold"
        case heavyItalic = "AvenirNext-HeavyItalic"
        case heavy = "AvenirNext-Heavy"
        case medium = "AvenirNext-Medium"
        case italic = "AvenirNext-Italic"
        case ultraLightItalic = "AvenirNext-UltraLightItalic"
        case boldItalic = "AvenirNext-BoldItalic"
        case regular = "AvenirNext-Regular"
        case demiBoldItalic = "AvenirNext-DemiBoldItalic"
    }
    
    static func avenir(size: CGFloat, type: AvenirType) -> UIFont {
        return UIFont.init(name: type.rawValue, size: size)!
    }
    
    enum AvenirType: String {
        case heavy = "Avenir-Heavy"
        case oblique = "Avenir-Oblique"
        case black = "Avenir-Black"
        case book = "Avenir-Book"
        case blackOblique = "Avenir-BlackOblique"
        case heavyOblique = "Avenir-HeavyOblique"
        case light = "Avenir-Light"
        case mediumOblique = "Avenir-MediumOblique"
        case medium = "Avenir-Medium"
        case lightOblique = "Avenir-LightOblique"
        case roman = "Avenir-Roman"
        case bookOblique = "Avenir-BookOblique"
    }
}

extension NSNumber {
    func toString() -> String {
        return "\(self)"
    }
}



/// http
/*
 <key>NSAppTransportSecurity</key>
 <dict>
 <key>NSAllowsArbitraryLoads</key><true/>
 </dict>
 */

class IMBValidate {
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


extension String {
    
    func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func handleSpamString() -> String {
        var new = self
        while new.contains(" \n") {
            new = new.replacingOccurrences(of: " \n", with: "\n")
        }
        
        while new.contains("\n\n\n") {
            new = new.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        
        while new.hasSuffix("\n") {
//            new = new.substring(to: new.index(before: new.endIndex))
            new = String(new[..<new.endIndex])
            
        }
        
        while new.hasSuffix(" ") {
//            new = new.substring(to: new.index(before: new.endIndex))
            new = String(new[..<new.endIndex])
        }
        return new
    }
    
    //MARK: GET CHARACTERS STRING
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        let range: Range<Index> = start..<end
    
        return String(self[range])
    }

    func appendingWithSlashCharacter(string: String) -> String {
        return self + "/" + string
    }
    //sorting localized strings
    var forSorting: String {
        let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
        return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
    }
    
    func removeSpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func removeInvalidSpace() -> String {
        let array = self.components(separatedBy: " ")
        var result = ""
        for i in array {
            if i != "" {
                if result != "" {
                    result += " " + i
                } else {
                    result = i
                }
            }
        }
        return result
    }

    func toInt() -> Int? {
        return Int(self)
    }
    func toInt64() -> Int64? {
        return Int64(self)
    }
    func toInt32() -> Int32? {
        return Int32(self)
    }
    func toInt16() -> Int16? {
        return Int16(self)
    }
    func toInt8() -> Int8? {
        return Int8(self)
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        //let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        //let string = NSString.init(string: self)
        //let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        //print(boundingBox)
        return rect.height
    }
    
    func textViewHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.height
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}


extension Int {
    func formattedWithDot() -> String {
        return Formatter.withSeparator.string(from: NSNumber.init(value: self)) ?? ""
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIScrollView {
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}

extension UISearchBar {
    override open var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}

class IMBAlertController {
    class func alertInstance(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) -> UIAlertController{
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        return alert
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
