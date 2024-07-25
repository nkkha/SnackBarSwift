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
        stackView.spacing = style.paddingStackview
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
        label.font = style.textFont
        label.textColor = style.textColor
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding = 4
        configuration.titleAlignment = .trailing
        let button = UIButton(configuration: configuration)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setTitleColor(style.actionTextColor, for: .normal)
        button.titleLabel?.font = style.actionFont
        return button
    }()
    
    open var style: SnackBarStyle {
        return SnackBarStyle()
    }
    
    private let contextView: UIView
    private let message: String
    private var buttonTitle: String
    private let duration: Duration
    private var icon: UIImage?
    
    required public init(contextView: UIView, iconType: IconType, message: String, buttonTitle: String = "", duration: Duration) {
        self.contextView = contextView
        self.message = message
        self.buttonTitle = buttonTitle
        self.duration = duration
        super.init(frame: .zero)

        setupIcon(iconType: iconType)
        setupView()
        updateHeight()
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    private func setupIcon(iconType: IconType) {
        switch iconType {
        case .success:
            self.icon = UIImage(named: "ic-approve")
        case .error:
            self.icon = UIImage(named: "ic-error")
        case .undefined:
            self.icon = nil
        }
    }

    private func updateHeight() {
        let iconWidth: CGFloat = icon != nil ? 24 + style.paddingStackview : 0
        let buttonWidth = buttonTitle.isEmpty ? 0 : buttonTitle.widthOfText(usingFont: style.actionFont) + style.paddingStackview + 32
        let totalPadding: CGFloat = CGFloat(2 * (style.paddingSupperview + style.paddingInnerview)) - 6
        let availableWidth = kScreenWidth - iconWidth - buttonWidth - totalPadding
        let textWidth = message.widthOfText(usingFont: messageLabel.font)
                
        self.snp.updateConstraints {
            $0.height.equalTo(textWidth > availableWidth ? 70 : 48)
        }
    }
    
    private func constraintSuperView(with view: UIView) {
        view.setupSubview(self) {
            $0.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-style.paddingSupperview)
                $0.leading.equalTo(view.safeAreaLayoutGuide).offset(style.paddingSupperview)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-style.paddingSupperview)
            }
        }
    }
    
    private func setupView() {
        self.backgroundColor = style.background
        self.layer.cornerRadius = style.borderRadius
        
        self.messageLabel.text = message
        self.messageLabel.setCharacterSpacing(kernValue: 0.15)
        self.messageLabel.setLineHeight(lineHeight: 4)
        
        self.setupSubview(mainStackView) {
            $0.makeConstraints {
                $0.edges.equalTo(self).inset(style.paddingInnerview)
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
        self.buttonTitle = title
        mainStackView.addArrangedSubview(actionButton)
        actionButton.setTitle(title.uppercased(), for: .normal)
        actionButton.setCharacterSpacing(kernValue: 1.25)
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
