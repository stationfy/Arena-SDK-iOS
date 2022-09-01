import UIKit

public final class OwnMessageCell: UITableViewCell {
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

extension OwnMessageCell {
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
    }

    func updateConstraints(repliedMessageIsHidden isHidden: Bool) {
        repliedMessageContainerView.heightAnchor.constraint(equalToConstant: 0.0).isActive = isHidden
        repliedMessageLabel.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor, constant: 8).isActive = !isHidden
        repliedMessageLabel.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor, constant: -8).isActive = !isHidden
        separatorView.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor, constant: 8).isActive = !isHidden
    }
}

extension OwnMessageCell {
    func setup() {
        let isHidden = true
        nameLabel.text = "You replied Arelene McCoy"
        timeLabel.text = "10:54"
        nameLabel.isHidden = isHidden
        ownMessageLabel.textAlignment = isHidden ? .right : .left
        ownMessageLabel.text = "olá bb como estas"
        repliedMessageLabel.text = "mte ala te amo cherosa te cmo mete ala te amo te amo te amo"

        updateConstraints(repliedMessageIsHidden: isHidden)
    }
}
