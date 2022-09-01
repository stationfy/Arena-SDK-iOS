import UIKit

public final class ChatView: UIView {
    // MARK: - TopView
    private let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "Live Chat"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Color.mediumPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let onlineUsersIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.3.fill")
        imageView.tintColor = Color.mediumPurple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let onlineUsersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Color.mediumPurple
        label.text = "12.5K"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "three-dots-menu"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [liveLabel, onlineUsersIcon, onlineUsersLabel, menuButton])
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatView {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
    }

    func buildViewHierarchy() {
        addSubview(topStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topStackView.topAnchor.constraint(equalTo: self.topAnchor),
            topStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
