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
    public var background: UIColor = AppColorV4.Gray.gray900
    public var borderRadius: CGFloat = 9
	public var paddingSupperview = 6
    public var paddingInnerview = 16
    public var paddingStackview: CGFloat = 10
    
	// Label
    public var textColor: UIColor = AppColorV4.white
    public var textFont: UIFont = AppFont.robotoRegular(ofSize: 14)
	var maxNumberOfLines: Int = 2
    
	// Action
    public var actionFont: UIFont = AppFont.robotoMedium(ofSize: 14)
    public var actionTextColor: UIColor = AppColorV4.Indigo.indigo400
}
