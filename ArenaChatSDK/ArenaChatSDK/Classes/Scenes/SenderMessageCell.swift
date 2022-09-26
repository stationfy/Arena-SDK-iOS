import UIKit

public final class SenderMessageCell: UITableViewCell {
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
        let stackView = UIStackView(arrangedSubviews: [nameLabel, timeLabel])
        stackView.spacing = 4
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - OwnMessageView
    private let messageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mediumPurple
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let ownMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = Color.mediumPurple
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - RepliedMessageView
    private let repliedMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = Color.mediumPurple
        label.textColor = Color.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let repliedMessageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mediumPurple
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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

extension SenderMessageCell {
    func buildViewHierarchy() {
        messageContainerView.addSubview(ownMessageLabel)
        repliedMessageContainerView.addSubview(separatorView)
        repliedMessageContainerView.addSubview(repliedMessageLabel)
        messageContainerView.addSubview(repliedMessageContainerView)
        contentView.addSubview(topStackView)
        contentView.addSubview(messageContainerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.leadingAnchor.constraint(equalTo: repliedMessageContainerView.leadingAnchor, constant: 8),
            separatorView.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor),

            repliedMessageLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 6),
            repliedMessageLabel.trailingAnchor.constraint(equalTo: repliedMessageContainerView.trailingAnchor, constant: -8),

            repliedMessageContainerView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            repliedMessageContainerView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
            repliedMessageContainerView.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            repliedMessageContainerView.bottomAnchor.constraint(equalTo: ownMessageLabel.topAnchor, constant: -8),

            ownMessageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 8),
            ownMessageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -8),
            ownMessageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -8),

            messageContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 72),
            messageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageContainerView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            messageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])

        repliedMessageContainerHeightConstraint = repliedMessageContainerView.heightAnchor.constraint(equalToConstant: 0.0)
        repliedMessageLabelTopConsttraint = repliedMessageLabel.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor,
                                                                                     constant: 8)
        repliedMessageLabelBottomConsttraint = repliedMessageLabel.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor,
                                                                                           constant: -8)
        separatorViewTopConsttraint = separatorView.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor,
                                                                         constant: 8)
    }

    func updateConstraints(repliedMessageIsHidden isHidden: Bool) {
        repliedMessageContainerHeightConstraint?.isActive = isHidden
        repliedMessageLabelTopConsttraint?.isActive = !isHidden
        repliedMessageLabelBottomConsttraint?.isActive = !isHidden
        separatorViewTopConsttraint?.isActive = !isHidden
    }

    func getFormattedTime(from date: Date?) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm"
        if let date = date {
            let dateString = dayTimePeriodFormatter.string(from: date)
            return dateString
        } else {
            return ""
        }
    }
}

extension SenderMessageCell: CardCellSetuping {
    func setup(with card: Card) {
        let isSender = card.type == .sender
        nameLabel.isHidden = isSender
        let replied = card.chatMessage.replyMessage?.sender?.displayName ?? ""
        nameLabel.text = "You replied \(replied)"
        timeLabel.text = card.createdAt?.toString()
        ownMessageLabel.textAlignment = isSender ? .right : .left
        ownMessageLabel.text = card.chatMessage.content?.text
        repliedMessageLabel.text = card.chatMessage.replyMessage?.content?.text

        updateConstraints(repliedMessageIsHidden: isSender)
    }
}
