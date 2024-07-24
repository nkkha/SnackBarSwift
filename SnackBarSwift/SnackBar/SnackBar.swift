//
//  SnackBar.swift
//  CommonUI
//
//  Created by Ahmad Almasri on 9/7/20.
//

import UIKit
import SnapKit

public protocol SnackBarAction {
    func setAction(with title: String, action: (() -> Void)?) -> SnackBarPresentable
}

public protocol SnackBarPresentable {
    func show()
    func dismiss()
}

public enum IconType {
    case success
    case error
    case undefined
}

open class SnackBar: UIView, SnackBarAction, SnackBarPresentable {
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, messageLabel].compactMap { $0 })
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var iconView: UIImageView? = {
        guard let icon = icon else { return nil }
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFill
        iconView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 24, height: 24)) }
        return iconView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = style.font
        label.textColor = style.textColor
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding = 8
        configuration.titleAlignment = .trailing
        let button = UIButton(configuration: configuration)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setTitleColor(style.actionTextColor.withAlphaComponent(style.actionTextColorAlpha), for: .normal)
        button.titleLabel?.font = style.actionFont
        return button
    }()
    
    open var style: SnackBarStyle {
        return SnackBarStyle()
    }
    
    private let contextView: UIView
    private let message: String
    private let duration: Duration
    private var icon: UIImage?
    
    required public init(contextView: UIView, iconType: IconType, message: String, duration: Duration) {
        self.contextView = contextView
        self.message = message
        self.duration = duration
        super.init(frame: .zero)
        self.backgroundColor = style.background
        self.layer.cornerRadius = style.borderRadius
        setupIcon(iconType: iconType)
        setupView()
        self.messageLabel.text = message
        updateHeight()
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    private func setupIcon(iconType: IconType) {
        switch iconType {
        case .success:
            self.icon = UIImage(named: "ic-check-circle")
        case .error:
            self.icon = UIImage(named: "ic_error")
        case .undefined:
            self.icon = nil
        }
    }

    private func updateHeight() {
        let buttonTitleWidth = actionButton.titleLabel?.text?.widthOfText(usingFont: style.actionFont) ?? 0
        let buttonPadding: CGFloat = 16

        let iconWidth: CGFloat = icon != nil ? 24 : 0
        let buttonWidth: CGFloat = actionButton.isHidden ? 0 : buttonTitleWidth + buttonPadding
        let stackViewSpacing: CGFloat = CGFloat((mainStackView.arrangedSubviews.count - 1) * 10)
        let totalPadding: CGFloat = CGFloat(2 * (style.padding + style.inViewPadding))
        
        let availableWidth = UIScreen.main.bounds.width - iconWidth - buttonWidth - stackViewSpacing - totalPadding
        let textWidth = message.widthOfText(usingFont: messageLabel.font)
        
        let numberOfLines: CGFloat = textWidth > availableWidth ? 2 : 1
        let height: CGFloat = numberOfLines > 1 ? 68 : 48
        
        self.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    private func constraintSuperView(with view: UIView) {
        view.setupSubview(self) {
            $0.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-style.padding)
                $0.leading.equalTo(view.safeAreaLayoutGuide).offset(style.padding)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-style.padding)
            }
        }
    }
    
    private func setupView() {
        self.setupSubview(mainStackView) {
            $0.makeConstraints {
                $0.edges.equalTo(self).inset(style.inViewPadding)
            }
        }
    }
    
    private static func removeOldViews(from view: UIView) {
        view.subviews.filter({ $0 is Self }).forEach({ $0.removeFromSuperview() })
    }
    
    // MARK: - Public Methods
    
    public static func make(in view: UIView, iconType: IconType = .undefined, message: String, duration: Duration) -> Self {
        removeOldViews(from: view)
        return Self(contextView: view, iconType: iconType, message: message, duration: duration)
    }
    
    public func setAction(with title: String, action: (() -> Void)? = nil) -> SnackBarPresentable {
        mainStackView.addArrangedSubview(actionButton)
        actionButton.setTitle(title, for: .normal)
        actionButton.actionHandler(controlEvents: .touchUpInside) { [weak self] in
            self?.dismiss()
            action?()
        }
        updateHeight()
        return self
    }
    
    public func show() {
        constraintSuperView(with: contextView)
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration.value) {
            self.dismiss()
        }
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

extension String {
    func widthOfText(usingFont font: UIFont, kerning: CGFloat = 0.25) -> CGFloat {
        let size = (self as NSString).size(withAttributes: [.font: font, .kern: kerning])
        return size.width
    }
}
