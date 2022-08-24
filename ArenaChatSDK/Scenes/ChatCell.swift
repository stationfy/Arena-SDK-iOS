import UIKit

public final class ChatCell: UITableViewCell {
    private let roundViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.backgroundColor = Color.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, roundViewContainerView, timeLabel])
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var messageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, messageContainerView])
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageContainerView, messageStackView])
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        messageContainerView.addSubview(messageLabel)
        profileImageContainerView.addSubview(profileImageView)
        contentView.addSubview(contentStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            roundView.heightAnchor.constraint(equalToConstant: 8),
            roundView.widthAnchor.constraint(equalToConstant: 8),
            roundView.leadingAnchor.constraint(equalTo: roundViewContainerView.leadingAnchor),
            roundView.trailingAnchor.constraint(equalTo: roundViewContainerView.trailingAnchor),
            roundView.centerYAnchor.constraint(equalTo: roundViewContainerView.centerYAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor),
            
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}

public extension ChatCell {
    func setup() {
        nameLabel.text = "Clau"
        timeLabel.text = "09:13"
        messageLabel.text = "The teens wondered what was kept in the red shed on the far edge of the school grounds."
        profileImageView.backgroundColor = .purple
    }
}
