//
//  UIView.swift
//

import UIKit

//extension UIView {
//
//    @IBInspectable
//    var cornerRadius: CGFloat {
//      get {
//        return layer.cornerRadius
//      }
//      set {
//        layer.cornerRadius = newValue
//      }
//    }
//
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//
//    @IBInspectable var borderWidth: Double {
//          get {
//            return Double(self.layer.borderWidth)
//          }
//          set {
//           self.layer.borderWidth = CGFloat(newValue)
//          }
//    }
//    @IBInspectable var borderColor: UIColor? {
//         get {
//            return UIColor(cgColor: self.layer.borderColor!)
//         }
//         set {
//            self.layer.borderColor = newValue?.cgColor
//         }
//    }
//    @IBInspectable var shadowColor: UIColor? {
//        get {
//           return UIColor(cgColor: self.layer.shadowColor!)
//        }
//        set {
//           self.layer.shadowColor = newValue?.cgColor
//        }
//    }
//    @IBInspectable var shadowOpacity: Float {
//        get {
//           return self.layer.shadowOpacity
//        }
//        set {
//           self.layer.shadowOpacity = newValue
//       }
//    }
//    @IBInspectable var shadowRadius: CGFloat {
//        get {
//           return self.layer.shadowRadius
//        }
//        set {
//           self.layer.shadowRadius = newValue
//       }
//    }
//    @IBInspectable var shadowOffset: CGSize {
//        get {
//           return self.layer.shadowOffset
//        }
//        set {
//           self.layer.shadowOffset = newValue
//       }
//    }
//}

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func addCornerRadius(cornerRadius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
