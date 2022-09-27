import UIKit
import Kingfisher

public final class ReceivedMessageCell: UITableViewCell {
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
        label.setContentHuggingPriority(.required, for: .horizontal)
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
        imageView.contentMode = .scaleAspectFit
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
        view.backgroundColor = Color.lightGray
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let repliedMessageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
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

    private var repliedMessageContainerHeightConstraint: NSLayoutConstraint?
    private var repliedMessageLabelTopConsttraint: NSLayoutConstraint?
    private var repliedMessageLabelBottomConsttraint: NSLayoutConstraint?
    private var separatorViewTopConsttraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReceivedMessageCell {
    func buildViewHierarchy() {
        roundViewContainerView.addSubview(roundView)
        profileImageContainerView.addSubview(profileImageView)
        messageContainerView.addSubview(repliedMessageContainerView)
        messageContainerView.addSubview(messageLabel)
        repliedMessageContainerView.addSubview(separatorView)
        repliedMessageContainerView.addSubview(repliedMessageLabel)
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

            profileImageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            profileImageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            roundView.heightAnchor.constraint(equalToConstant: 4),
            roundView.widthAnchor.constraint(equalToConstant: 4),
            roundView.leadingAnchor.constraint(equalTo: roundViewContainerView.leadingAnchor),
            roundView.trailingAnchor.constraint(equalTo: roundViewContainerView.trailingAnchor),
            roundView.centerYAnchor.constraint(equalTo: roundViewContainerView.centerYAnchor),

            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            topStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -48),

            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.leadingAnchor.constraint(equalTo: repliedMessageContainerView.leadingAnchor, constant: 8),
            separatorView.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor),

            repliedMessageLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 6),
            repliedMessageLabel.trailingAnchor.constraint(equalTo: repliedMessageContainerView.trailingAnchor, constant: -8),

            repliedMessageContainerView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            repliedMessageContainerView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
            repliedMessageContainerView.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            repliedMessageContainerView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),

            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -8),

            messageContainerView.leadingAnchor.constraint(equalTo: profileImageContainerView.trailingAnchor, constant: 8),
            messageContainerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -72),
            messageContainerView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        repliedMessageContainerHeightConstraint = repliedMessageContainerView.heightAnchor.constraint(equalToConstant: 0.0)
        repliedMessageLabelTopConsttraint = repliedMessageLabel.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor,
                                                                                     constant: 8)
        repliedMessageLabelBottomConsttraint = repliedMessageLabel.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor,
                                                                                           constant: -8)
        separatorViewTopConsttraint = separatorView.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor,
                                                                         constant: 8)
    }

    func updateConstraints(repliedMessageIsHidden: Bool) {
        repliedMessageContainerHeightConstraint?.isActive = repliedMessageIsHidden
        repliedMessageLabelTopConsttraint?.isActive = !repliedMessageIsHidden
        repliedMessageLabelBottomConsttraint?.isActive = !repliedMessageIsHidden
        separatorViewTopConsttraint?.isActive = !repliedMessageIsHidden
    }
}

extension ReceivedMessageCell: CardCellSetuping {
    func setup(with card: Card) {
        let isReceived = card.type == .received
        let sender = card.chatMessage.sender?.displayName ?? ""
        let replied = card.chatMessage.replyMessage?.sender?.displayName ?? ""
        nameLabel.text = isReceived ? sender : "\(sender) replied \(replied))"
        timeLabel.text = card.createdAt?.toString()
        messageLabel.text = card.chatMessage.content?.text
        repliedMessageLabel.text = card.chatMessage.replyMessage?.content?.text
        profileImageView.backgroundColor = .purple

        if let photoString = card.chatMessage.sender?.photoURL,
           let photoURL = URL(string: photoString) {
            profileImageView.kf.setImage(with: photoURL)
        }

        updateConstraints(repliedMessageIsHidden: isReceived)
    }
}
