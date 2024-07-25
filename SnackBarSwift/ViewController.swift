//
//  ViewController.swift
//  SnackBarSwift
//
//  Created by Kha Nguyen on 24/7/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.addSubview(button)
        
        button.snp.makeConstraints  {
            $0.center.equalTo(self.view)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        SnackBar.make(in: self.view, iconType: .success, message: "Two lines with one action. One to two lines is preferable on mobile.", duration: .lengthShort).show()
//        SnackBar.make(in: self.view, iconType: .success, message: "Two lines with one action. One to two lines is preferable on mobile.", duration: .lengthShort).setAction(with: "BUTTON").show()
    }
}

class AppSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .red
        style.textColor = .green
        return style
    }
}
