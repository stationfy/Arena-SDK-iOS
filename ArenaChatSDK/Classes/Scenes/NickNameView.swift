import UIKit
import SwiftUI

final class NickNameView: UIView {
    var closeAction: (() -> Void)?
    var confirmNickNameAction: ((String) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Choose a Nickname"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Assets.close.rawValue)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.medimGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.gray.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Choose a nickname"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(Color.darkGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = Color.medimGray
        button.addTarget(self, action: #selector(confirmNickName), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isEnabled = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldContainer, buttonContainerView])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildViewHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NickNameView {
    func buildViewHierarchy() {
        buttonContainerView.addSubview(confirmButton)
        contentContainerView.addSubview(topStackView)
        contentContainerView.addSubview(separatorView)
        textFieldContainer.addSubview(nickNameTextField)
        contentContainerView.addSubview(bottomStackView)
        addSubview(backgroundView)
        addSubview(contentContainerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            confirmButton.widthAnchor.constraint(equalToConstant: 136),
            confirmButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            confirmButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),

            topStackView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 14),
            topStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 14),
            topStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -14),
            topStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -14),

            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -24),

            nickNameTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 16),
            nickNameTextField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: 10),
            nickNameTextField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: -10),

            bottomStackView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 14),
            bottomStackView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -14),
            bottomStackView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -14),

            contentContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
            contentContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
            contentContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func clearTextField() {
        nickNameTextField.text = nil
        textFieldContainer.layer.borderColor = Color.gray.cgColor
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = Color.medimGray
        nickNameTextField.resignFirstResponder()
    }
}

@objc extension NickNameView {
    func close() {
        closeAction?()
        clearTextField()
    }

    func confirmNickName() {
        guard let name = nickNameTextField.text else { return }
        confirmNickNameAction?(name)
        clearTextField()
    }

    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count >= 3 {
            textFieldContainer.layer.borderColor = Color.mediumPurple.cgColor
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = Color.mediumPurple
        } else {
            textFieldContainer.layer.borderColor = Color.gray.cgColor
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = Color.medimGray
        }
    }
}
