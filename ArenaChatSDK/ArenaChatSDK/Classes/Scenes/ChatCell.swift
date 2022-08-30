import UIKit

public final class ChatCell: UITableViewCell {
    private let roundViewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let repliedMessageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageContainerView: UIView = {
        let view = UIView()
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, roundViewContainerView, timeLabel])
        stackView.spacing = 4
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repliedMessageContainerView, messageContainerView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var messageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, messageStackContainerView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var messageStackContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.backgroundColor = Color.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        repliedMessageContainerView.addSubview(repliedMessageLabel)
        repliedMessageContainerView.addSubview(separatorView)
        profileImageContainerView.addSubview(profileImageView)
        messageStackContainerView.addSubview(textStackView)
        contentView.addSubview(contentStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            roundView.heightAnchor.constraint(equalToConstant: 8),
            roundView.widthAnchor.constraint(equalToConstant: 8),
            roundView.leadingAnchor.constraint(equalTo: roundViewContainerView.leadingAnchor),
            roundView.trailingAnchor.constraint(equalTo: roundViewContainerView.trailingAnchor),
            roundView.centerYAnchor.constraint(equalTo: roundViewContainerView.centerYAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 8),
            
            repliedMessageLabel.trailingAnchor.constraint(equalTo: repliedMessageContainerView.trailingAnchor, constant: -8),
            repliedMessageLabel.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor, constant: -8),
            repliedMessageLabel.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor, constant: 8),
            
            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.bottomAnchor.constraint(equalTo: repliedMessageContainerView.bottomAnchor, constant: -8),
            separatorView.topAnchor.constraint(equalTo: repliedMessageContainerView.topAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: repliedMessageContainerView.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: repliedMessageLabel.leadingAnchor, constant: -8),

            textStackView.leadingAnchor.constraint(equalTo: messageStackContainerView.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: messageStackContainerView.trailingAnchor),
            textStackView.topAnchor.constraint(equalTo: messageStackContainerView.topAnchor),
            textStackView.bottomAnchor.constraint(equalTo: messageStackContainerView.bottomAnchor),
            
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: profileImageContainerView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: profileImageContainerView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor),
            
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -72),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
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
