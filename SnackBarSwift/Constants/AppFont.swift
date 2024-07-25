//
//  AppFont.swift
//  SnackBarSwift
//
//  Created by Kha Nguyen on 25/7/24.
//

import UIKit

struct AppFont {
    static func robotoRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    static func robotoMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    static func robotoBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
