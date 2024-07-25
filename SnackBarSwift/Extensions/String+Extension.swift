//
//  String+Extension.swift
//  SnackBarSwift
//
//  Created by Kha Nguyen on 25/7/24.
//

import UIKit

extension String {
    func widthOfText(usingFont font: UIFont, kerning: CGFloat = 0.25) -> CGFloat {
        let size = (self as NSString).size(withAttributes: [.font: font, .kern: kerning])
        return size.width
    }
}
