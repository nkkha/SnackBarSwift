//
//  UIButton+Extension.swift
//  SnackBarSwift
//
//  Created by Kha Nguyen on 25/7/24.
//

import UIKit

extension UIButton {
    func setCharacterSpacing(kernValue: CGFloat) {
        if let text = self.titleLabel?.text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: text.count - 1))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }

    func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color ?? .white, for: .normal)
    }
}
