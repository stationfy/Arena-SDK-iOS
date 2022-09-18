import UIKit

public final class FeedbackView: UIView {
    var mainButtonAction: (() -> Void)?
    var textButtonAction: (() -> Void)?

    private let backgroundImage: UIImage
    private let mainImage: UIImage
    private let title: String
    private let feedackDescription: String
    private let mainButtonTitle: String
    private let textButtonTitle: String?

    private let headerContainerView = UIView()

    private let backgroundImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()

    private let mainImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Color.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Color.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.mediumPurple
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(didTapMainButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var textButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textColor = Color.blue
        button.addTarget(self, action: #selector(didTapTextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainButton, textButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public init(backgroundImage: UIImage = Assets.clouds.image,
                mainImage: UIImage = Assets.noConnection.image,
                title: String,
                description: String,
                mainButtonTitle: String,
                textButtonTitle: String?) {
        self.backgroundImage = backgroundImage
        self.mainImage = mainImage
        self.title = title
        self.feedackDescription = description
        self.mainButtonTitle = mainButtonTitle
        self.textButtonTitle = textButtonTitle
        super.init(frame: .zero)
        buildViewHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension FeedbackView {
    func didTapMainButton() {
        mainButtonAction?()
    }

    func didTapTextButton() {
        textButtonAction?()
    }
}

private extension FeedbackView {
    func buildViewHierarchy() {
        headerContainerView.addSubview(backgroundImageView)
        headerContainerView.addSubview(mainImageView)
        addSubview(headerContainerView)
        addSubview(textStackView)
        addSubview(bottomStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 110),

            mainImageView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20),
            mainImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 110),

            textStackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -24),
            textStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
            textStackView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),

            bottomStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setup() {
        backgroundImageView.image = backgroundImage
        mainImageView.image = mainImage
        titleLabel.text = title
        descriptionLabel.text = description
        mainButton.setTitle(mainButtonTitle, for: .normal)
        textButton.setTitle(textButtonTitle, for: .normal)
        textButton.isHidden = textButtonTitle == nil
    }
}
