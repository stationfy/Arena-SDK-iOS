import UIKit

public final class FeedbackView: UIView {
    var mainButtonAction: (() -> Void)?
    var textButtonAction: (() -> Void)?

    private let backgroundImage: UIImage
    private let mainImage: UIImage
    private let title: String
    private let subtitle: String
    private let mainButtonTitle: String
    private let textButtonTitle: String?

    private let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backgroundImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
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
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Color.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.mediumPurple
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapMainButton), for: .touchUpInside)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var textButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(Color.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapTextButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainButton, textButton])
        stackView.axis = .vertical
        stackView.spacing = 4
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

    public init(backgroundImage: UIImage,
                mainImage: UIImage,
                title: String,
                subtitle: String,
                mainButtonTitle: String,
                textButtonTitle: String?) {
        self.backgroundImage = backgroundImage
        self.mainImage = mainImage
        self.title = title
        self.subtitle = subtitle
        self.mainButtonTitle = mainButtonTitle
        self.textButtonTitle = textButtonTitle
        super.init(frame: .zero)
        buildViewHierarchy()
        setupConstraints()
        backgroundColor = Color.lightGray
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
            headerContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            headerContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            headerContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),

            backgroundImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),

            mainImageView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -40),
            mainImageView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),

            textStackView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 24),
            textStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
            textStackView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),

            mainButton.heightAnchor.constraint(equalToConstant: 48),

            textButton.heightAnchor.constraint(equalToConstant: 40),

            bottomStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
        ])
    }
}

public extension FeedbackView {
    func setup() {
        backgroundImageView.image = backgroundImage
        mainImageView.image = mainImage
        titleLabel.text = title
        descriptionLabel.text = subtitle
        mainButton.setTitle(mainButtonTitle, for: .normal)
        textButton.setTitle(textButtonTitle, for: .normal)
        textButton.isHidden = textButtonTitle == nil
    }
}
