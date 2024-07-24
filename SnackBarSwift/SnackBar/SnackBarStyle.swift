//
//  SnackBarStyle.swift
//  CommonUI
//
//  Created by Ahmad Almasri on 9/11/20.
//

import UIKit

public struct SnackBarStyle {
	public init() { }
	// Container
	public var background: UIColor = .lightGray
    var borderRadius: CGFloat = 9
	var padding = 6
	var inViewPadding = 16
	// Label
	public var textColor: UIColor = .black
    public var font: UIFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: 14))
	var maxNumberOfLines: Int = 2
	// Action
	public var actionTextColorAlpha: CGFloat = 0.5
	public var actionFont: UIFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: 17))
	public var actionTextColor: UIColor = .red
}
