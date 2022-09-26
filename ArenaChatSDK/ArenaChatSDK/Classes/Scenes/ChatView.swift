import UIKit

public protocol ChatDelegate: AnyObject {
    func ssoUserRequired(completion: (ExternalUser) -> Void)
}

public final class ChatView: UIView {
    private let replyView: ReplyView = {
        let view = ReplyView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Message"
        textView.textColor = Color.gray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var emojiButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Assets.smilingFace.rawValue)?.withTintColor(Color.darkGray, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(changeToEmojiKeyboard), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Assets.arrowUp.rawValue)?.withTintColor(Color.blue, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emojiButton, sendButton])
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
        setupKeyboard()
    }

    private lazy var tapGesture: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
    }()

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

    private func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
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

@objc private extension ChatView {
    func changeToEmojiKeyboard() {

    }

    func sendMessage() {
        presenter.sendMessage(text: textView.text, mediaUrl: nil, isGif: false)
        textView.text = ""
    }

    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if frame.origin.y == 0 {
                frame.origin.y -= keyboardSize.height
            }
        }
    }

    func keyboardWillHide() {
        if frame.origin.y != 0 {
               frame.origin.y = 0
           }
    }

    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
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
        addGestureRecognizer(tapGesture)
        bottomContainerView.addSubview(bottomStackView)
        bottomContainerView.addSubview(textView)
        addSubview(tableView)
        addSubview(bottomContainerView)
        addSubview(loginView)
        addSubview(loadingView)
        addSubview(replyView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            loginView.topAnchor.constraint(equalTo: self.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            replyView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -12),
            replyView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            replyView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),

          //  bottomStackView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            bottomStackView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -16),

            textView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: -8),
            textView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),

            bottomContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }

    func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
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

        cell.selectionStyle = .none
        guard let cardCell = cell as? CardCellSetuping else {
            return cell
        }

        cardCell.setup(with: model)
        cardCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        return cardCell
    }
}

extension ChatView: UITableViewDelegate { }

extension ChatView: ChatPresenting {
    func performUpdate(with batchUpdate: BatchUpdates, lastIndex: Int) {
        tableView.performUpdate(with: batchUpdate)


        //tableView.scrollToRow(at: IndexPath(row: lastIndex, section: 0), at: .bottom, animated: true)
    }

    func startLoading() {
        loadingView.isHidden = false
        loadingView.startLoading()
    }

    func stopLoading() {
        loadingView.isHidden = true
    }

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

extension ChatView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Color.gray {
            textView.text = nil
            textView.textColor = Color.darkGray
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = Color.gray
        }
    }
}
