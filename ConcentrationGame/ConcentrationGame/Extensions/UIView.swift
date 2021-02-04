//
//  UIView.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 04.02.2021.
//

import Foundation
import UIKit

extension UIView {

    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}
