import UIKit

final class OnlineUsersView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = Color.purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let onlineUsersIcon: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 12)
        imageView.image = UIImage(systemName: Assets.persons.rawValue, withConfiguration: configuration)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let onlineUsersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [onlineUsersIcon, onlineUsersLabel])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override public init(frame: CGRect) {
        super.init(frame: .zero)
        buildViewHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OnlineUsersView {
    func buildViewHierarchy() {
        containerView.addSubview(contentStackView)
        addSubview(containerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 28),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -28),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),

            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
    }
}

extension OnlineUsersView {
    func setup(with onlineUsers: String) {
        onlineUsersLabel.text = "\(onlineUsers) users online"
    }
}
