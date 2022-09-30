import UIKit
import SwiftUI

final class LogoutView: UIView {
    var logoutAction: (() -> Void)?

    private let loggedUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(ProfileText.logout.localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.medimGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        buildViewHierarchy()
        setupConstraints()
        layer.shadowColor = Color.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension LogoutView {
    func logout() {
        logoutAction?()
    }
}

private extension LogoutView {
    func buildViewHierarchy() {
        addSubview(loggedUserLabel)
        addSubview(separatorView)
        addSubview(logoutButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            loggedUserLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            loggedUserLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            loggedUserLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            loggedUserLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),

            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -8),

            logoutButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            logoutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
}

extension LogoutView {
    func setup(with userName: String) {
        loggedUserLabel.text = "\(ProfileText.logged.localized) \(userName)"
    }
}
