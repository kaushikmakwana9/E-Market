//
//  UIView_Extension.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var cornerVRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderVWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderVColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowVRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowVOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowVOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowVColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    func addInnerShadow(to edges: [UIRectEdge], radius: CGFloat = 3.0, opacity: Float = 0.6, color: CGColor = UIColor.black.cgColor, frame:CGRect) {
        
        let fromColor = color
        let toColor = UIColor.clear.cgColor
        let viewFrame = frame
        for edge in edges {
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = "ShadowLayer"
            gradientLayer.colors = [fromColor, toColor]
            gradientLayer.opacity = opacity
            switch edge {
            case .top:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
            case .bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
            case .left:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
            case .right:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
            default:
                break
            }
            self.layer.addSublayer(gradientLayer)
        }
    }
    
    func removeAllShadows() {
        if let sublayers = self.layer.sublayers, !sublayers.isEmpty {
            layer.sublayers?.first { $0.name == "ShadowLayer" }?.removeFromSuperlayer()
        }
    }
    
    func addAllSideShadow(shadowRadius: CGFloat = 10, shadowOffSet: CGSize = .zero, shodowOpacity: Float = 0.2, shadowColor: UIColor = .darkGray) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffSet
        layer.shadowOpacity = shodowOpacity
        layer.shadowRadius = shadowRadius
    }
}

@IBDesignable
public class RoundedView: UIView {

    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
    
    func updateCorners() {
        var corners = CACornerMask()

        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }

        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}
