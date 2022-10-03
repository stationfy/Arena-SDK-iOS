import UIKit
import Apollo
import Kingfisher

public protocol ChatDelegate: AnyObject {
    func ssoUserRequired(completion: (ExternalUser) -> Void)
}

public final class ChatView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nickNameView: NickNameView = {
        let view = NickNameView()
        view.isHidden = true
        view.alpha = 0.0
        view.closeAction = { [weak self] in
            self?.loginAnonymously()
        }

        view.confirmNickNameAction = { [weak self] name in
            self?.register(with: name)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loginView: LoginView = {
        let view = LoginView()
        view.isHidden = true
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.loginAction = { [weak self] in
            self?.login()
        }
        view.startChatAction = { [weak self] in
            self?.showNickNameView()
        }
        return view
    }()

    private lazy var replyView: ReplyView = {
        let view = ReplyView()
        view.isHidden = true
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.closeAction = { [weak self] in
            self?.presenter.closeReplyMessage()
        }
        return view
    }()

    private let onlineUserView: OnlineUsersView = {
        let view = OnlineUsersView()
        view.isHidden = true
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var logoutView: LogoutView = {
        let view = LogoutView()
        view.isHidden = true
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.logoutAction = { [weak self] in
            self?.presenter.logout()
        }
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SenderMessageCell.self,
                           forCellReuseIdentifier: "SenderMessageCell")
        tableView.register(ReceivedMessageCell.self,
                           forCellReuseIdentifier: "ReceivedMessageCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = BottomViewText.message.localized
        textView.textColor = Color.gray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)

        let imageEnabled = UIImage(systemName: Assets.arrowUp.rawValue,
                                   withConfiguration: largeConfig)?.withTintColor(Color.blue, renderingMode: .alwaysOriginal)
        let imageDisabled = UIImage(systemName: Assets.arrowUp.rawValue,
                                   withConfiguration: largeConfig)?.withTintColor(Color.gray, renderingMode: .alwaysOriginal)

        button.setImage(imageEnabled, for: .normal)
        button.setImage(imageDisabled, for: .disabled)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = Color.medimGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(setupProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sendButton])
        stackView.spacing = 12
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

    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        return tap
    }()

    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleCellLongPress(_:)))
        longPress.cancelsTouchesInView = false
        longPress.delegate = self
        return longPress
    }()

    private var containerViewBottomConstraint: NSLayoutConstraint?

    public init(delegate: ChatDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        buildLayout()
        setupKeyboard()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
        setupKeyboard()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func login() {
        delegate?.ssoUserRequired { [weak self] externalUser in
            self?.presenter.registerUser(externalUser: externalUser)
            hideLoginModal()
        }
    }

    private func loginAnonymously() {
        presenter.registerAnonymousUser()
        hideAnimation(view: nickNameView)
    }

    private func register(with name: String) {
        startLoading()
        presenter.registerUser(name: name)
        hideAnimation(view: nickNameView)
    }

    private func showNickNameView() {
        hideLoginModal()
        showAnimation(view: nickNameView)
    }

    private func hideLoginModal() {
        hideAnimation(view: loginView)
    }

    private func setOnlineUserVisibility(isHidden: Bool) {
        if isHidden {
            hideAnimation(view: onlineUserView)
        } else {
            showAnimation(view: onlineUserView)
        }
    }

    private func showAnimation(view: UIView) {
        view.isHidden = false
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1.0
        }
    }

    private func hideAnimation(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
        }) { _ in
            view.isHidden = true
        }
    }
}

@objc private extension ChatView {
    func sendMessage() {
        presenter.sendMessage(text: textView.text, mediaUrl: nil, isGif: false)
        textView.text = ""
        sendButton.isEnabled = false
    }

    func setupProfile() {
        presenter.setupProfile()
    }

    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerViewBottomConstraint?.constant = -keyboardSize.height
            layoutIfNeeded()
        }
    }
    
    func keyboardWillHide() {
        if containerViewBottomConstraint?.constant != 0 {
            containerViewBottomConstraint?.constant = 0
            layoutIfNeeded()
        }
    }

    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }

    func handleCellLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                presenter.openReplyMessage(index: indexPath.row)
            }
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
        addGestureRecognizer(tapGesture)
        tableView.addGestureRecognizer(longPressGesture)

        bottomContainerView.addSubview(profileImageView)
        bottomContainerView.addSubview(profileButton)
        bottomContainerView.addSubview(textView)
        bottomContainerView.addSubview(bottomStackView)

        containerView.addSubview(tableView)
        containerView.addSubview(bottomContainerView)
        containerView.addSubview(onlineUserView)
        containerView.addSubview(replyView)
        containerView.addSubview(logoutView)
        containerView.addSubview(nickNameView)
        containerView.addSubview(loginView)
        containerView.addSubview(loadingView)

        addSubview(containerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            loadingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            nickNameView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nickNameView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nickNameView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nickNameView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            loginView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            onlineUserView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            onlineUserView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            replyView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -12),
            replyView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            replyView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),

            logoutView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            logoutView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),

            profileButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            profileButton.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            profileButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),

            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 8),
            profileImageView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),

            textView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: bottomStackView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor),

            bottomStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            bottomStackView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -16),

            bottomContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        containerViewBottomConstraint?.isActive = true
    }

    func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
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

extension ChatView: UITableViewDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        setOnlineUserVisibility(isHidden: true)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setOnlineUserVisibility(isHidden: false)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) {
            presenter.requestNextPage()
        }
    }
}

extension ChatView: ChatPresenting {

    func updateUsersOnline(count: String) {
        onlineUserView.setup(with: count)
        setOnlineUserVisibility(isHidden: false)
    }
    
    func performUpdate(with batchUpdate: BatchUpdates) {
        tableView.performUpdate(with: batchUpdate)
    }

    func reloadTable() {
        tableView.reloadData()
    }

    func updateProfileImage(with stringUrl: String?) {
        if let photoString = stringUrl,
           let photoURL = URL(string: photoString) {
            profileImageView.kf.setImage(with: photoURL)
        } else {
            profileImageView.image = nil
        }
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
        showAnimation(view: loginView)
    }

    func showReplyModal(receiver: String, message: String) {
        replyView.setup(receiver: receiver, message: message)
        showAnimation(view: replyView)
    }

    func hideReplyModal() {
        hideAnimation(view: replyView)
    }

    func openProfile(userName: String) {
        logoutView.setup(with: userName)
        showAnimation(view: logoutView)
    }

    func closeProfile() {
        hideAnimation(view: logoutView)
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
            textView.text = BottomViewText.message.localized
            textView.textColor = Color.gray
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !textView.text.isEmpty
    }
}

extension ChatView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view as? UIButton) != nil) {
            return false
        }
        return true
    }
}
