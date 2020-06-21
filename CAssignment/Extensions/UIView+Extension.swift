//
//  UIView+Extension.swift
//  CAssignment
//
//  Created by Optimum  on 20/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

extension UIView {

    /// Round UIView selected corners
    ///
    /// - Parameters:
    ///   - corners: selected corners to round
    ///   - radius: round amount
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
    func dropShadow() {

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.masksToBounds = false

        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        //layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
}
