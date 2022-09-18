import UIKit
import ArenaChatSDK

class ViewController: UIViewController {
    private lazy var chatView: ChatView = {
        let view = ChatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var feedbackView: FeedbackView = {
        let view = FeedbackView(title: "No internet Connection",
                                description: "Please check your internet connection and try again",
                                mainButtonTitle: "Back to last screen",
                                textButtonTitle: "Or try to reconnect")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loginView: LoginView = {
        let view = LoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . white

       // view.addSubview(chatView)
        //view.addSubview(feedbackView)
        view.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}

