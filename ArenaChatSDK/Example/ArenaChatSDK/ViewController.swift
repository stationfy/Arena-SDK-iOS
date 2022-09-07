import UIKit
import ArenaChatSDK

class ViewController: UIViewController {
    private lazy var chatView: ChatView = {
        let view = ChatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . white

        view.addSubview(chatView)
        
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}

