//
//  Extensions+.swift
//  TodoList
//
//  Created by Jakkula Rakesh on 16/06/24.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        self.init(cgImage: image.cgImage!)
    }
}
extension UIView {
    func addRightBorderCurve(cornerRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
