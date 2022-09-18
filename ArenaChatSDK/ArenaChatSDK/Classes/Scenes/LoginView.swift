import UIKit

public final class LoginView: UIView {
    var loginAction: (() -> Void)?
    var startChatAction: (() -> Void)?

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mediumPurple
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = Color.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.arena.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Color.darkGray
        label.text = "Login With"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Single Sign On Service", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = Color.darkGray
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let startChatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Or start chatting without login", for: .normal)
        button.setTitleColor(Color.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(startChat), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginLabel, loginButton, startChatButton])
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override public init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        buildViewHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension LoginView {
    func login() {
        loginAction?()
    }

    func startChat() {
        startChatAction?()
    }
}

private extension LoginView {
    func buildViewHierarchy() {
        backgroundView.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(buttonStackView)
        addSubview(backgroundView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),

            logoImageView.heightAnchor.constraint(equalToConstant: 32),
            logoImageView.widthAnchor.constraint(equalToConstant: 148),
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            loginButton.heightAnchor.constraint(equalToConstant: 48),

            buttonStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40),

            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
