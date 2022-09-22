import UIKit

public protocol ChatDelegate: AnyObject {
    func ssoUserRequired(completion: (ExternalUser) -> Void)
}

public final class ChatView: UIView {
    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loginAction = { [weak self] in
            self?.login()
        }
        view.startChatAction = { [weak self] in
            self?.loginAnonymously()
        }
        return view
    }()

    private let liveLabel: UILabel = {
        let label = UILabel()
        label.text = "Live Chat"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Color.mediumPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconContainerView = UIView()
    private let onlineUsersIcon: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 12)
        imageView.image = UIImage(systemName: Assets.persons.rawValue, withConfiguration: configuration)
        imageView.tintColor = Color.mediumPurple
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
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
        button.setImage(Assets.threeDotsMenu.image, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [liveLabel, iconContainerView, onlineUsersLabel, menuButton])
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = Color.gray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 1
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SenderMessageCell.self,
                           forCellReuseIdentifier: "SenderMessageCell")
        tableView.register(ReceivedMessageCell.self,
                           forCellReuseIdentifier: "ReceivedMessageCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var textView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Message"
        textField.textColor = Color.darkGray
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var emojiButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Assets.smilingFace.rawValue)?.withTintColor(Color.darkGray, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Assets.arrowUp.rawValue)?.withTintColor(Color.blue, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textView, emojiButton, sendButton])
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = Color.gray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowRadius = 1
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private weak var delegate: ChatDelegate?
    private lazy var presenter: ChatPresenter = ChatPresenter(delegate: self)

    public init(delegate: ChatDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        buildLayout()
    }

    private func login() {
        delegate?.ssoUserRequired { [weak self] externalUser in
            self?.presenter.registerUser(externalUser: externalUser)
            hideLoginModal()
        }
    }

    private func loginAnonymously() {
        presenter.registerAnonymousUser()
        hideLoginModal()
    }

    private func hideLoginModal() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.loginView.alpha = 0.0
        }) {  [weak self]  _ in
            self?.loginView.isHidden = true
        }
    }
}

public extension ChatView {

    func setUser(_ externalUser: ExternalUser) {
        presenter.setUser(externalUser)
    }

    func startEvent() {
        presenter.startEvent()
    }

}

private extension ChatView {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
    }

    func buildViewHierarchy() {
        iconContainerView.addSubview(onlineUsersIcon)
        topContainerView.addSubview(topStackView)
        bottomContainerView.addSubview(bottomStackView)
        addSubview(topContainerView)
        addSubview(tableView)
        addSubview(bottomContainerView)
        addSubview(loginView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: self.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            onlineUsersIcon.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor),
            onlineUsersIcon.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor),
            onlineUsersIcon.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),

            topContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: 48),

            topStackView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -24),
            topStackView.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            topStackView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),

            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 2),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),

            bottomStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            bottomStackView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -16),

            bottomContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension ChatView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter.cellModel(for: indexPath)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: model.type.identifier,
            for: indexPath
        )

        guard let cardCell = cell as? CardCellSetuping else {
            return cell
        }

        cardCell.setup(with: model)

        return cell
    }
}

extension ChatView: UITableViewDelegate { }

extension ChatView: ChatPresenting {
    func performUpdate(with batchUpdate: BatchUpdates) {
        tableView.performUpdate(with: batchUpdate)
    }

    func startLoading() { }

    func stopLoading() { }

    func nextPageDidLoad() { }
    
    func showLoadMore() { }

    func hideLoadMore() { }

    func openLoginModal() {
        loginView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.loginView.alpha = 1
        }
    }
}
