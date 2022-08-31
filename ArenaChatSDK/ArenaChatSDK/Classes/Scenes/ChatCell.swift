import UIKit

public final class ChatCell: UITableViewCell {
    // MARK: - TopView
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roundViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let roundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = Color.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, roundViewContainerView, timeLabel])
        stackView.spacing = 4
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

// MARK: - ProfileView
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let profileImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - MessageView
    private let messageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = Color.lightGray
        label.textColor = Color.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - RepliedMessageView
    private let repliedMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = Color.lightGray
        label.textColor = Color.purple
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let repliedMessageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.purple
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCell {
    func buildViewHierarchy() {
        roundViewContainerView.addSubview(roundView)
        profileImageContainerView.addSubview(profileImageView)
        messageContainerView.addSubview(messageLabel)
        contentView.addSubview(topStackView)
        contentView.addSubview(profileImageContainerView)
        contentView.addSubview(messageContainerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: profileImageContainerView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: profileImageContainerView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor),

            profileImageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileImageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            roundView.heightAnchor.constraint(equalToConstant: 8),
            roundView.widthAnchor.constraint(equalToConstant: 8),
            roundView.leadingAnchor.constraint(equalTo: roundViewContainerView.leadingAnchor),
            roundView.trailingAnchor.constraint(equalTo: roundViewContainerView.trailingAnchor),
            roundView.centerYAnchor.constraint(equalTo: roundViewContainerView.centerYAnchor),

            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor),

            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 8),

            messageContainerView.leadingAnchor.constraint(equalTo: profileImageContainerView.trailingAnchor, constant: 8),
            messageContainerView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8)

        ])
    }
}

public extension ChatCell {
    func setup() {
        nameLabel.text = "Clau Maria"
        timeLabel.text = "09:13"
        repliedMessageLabel.text = "Olá bebes voces vao no samba na sexta?"
        messageLabel.text = "BORAAAA"
        profileImageView.backgroundColor = .purple
        repliedMessageContainerView.isHidden = true
    }
}
