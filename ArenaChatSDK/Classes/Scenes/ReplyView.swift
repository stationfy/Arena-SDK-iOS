import UIKit

final class ReplyView: UIView {
    var closeAction: (() -> Void)?
    
    private let messageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let replyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Assets.close.rawValue)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [replyTitleLabel, closeButton])
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, messageContainerView])
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        buildViewHierarchy()
        setupConstraints()
    }
}

@objc extension ReplyView {
    func close() {
        closeAction?()
    }
}

private extension ReplyView {
    func buildViewHierarchy() {
        messageContainerView.addSubview(messageLabel)
        addSubview(contentStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -10),

            closeButton.widthAnchor.constraint(equalToConstant: 14),

            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
}

extension ReplyView {
    func setup(receiver: String, message: String) {
        backgroundColor = Color.darkGray
        replyTitleLabel.text = "\(ReplyBottomText.replyingTo.localized) \(receiver)"
        messageLabel.text = message
    }
}
