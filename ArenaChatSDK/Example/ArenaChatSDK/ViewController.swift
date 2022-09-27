import UIKit
import ArenaChatSDK

class ViewController: UIViewController {
    private lazy var chatView: ChatView = {
        let view = ChatView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(chatView)
        
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        chatView.startEvent()
    }
}

extension ViewController: ChatDelegate {
    func ssoUserRequired(completion: (ExternalUser) -> Void) {
        completion(
            ExternalUser(id: "123123",
                         name: "Roberto",
                         email: "roberto@gmail.com",
                         image: "https://randomuser.me/api/portraits/women/",
                         familyName: "Silva",
                         givenName: "Lima")
        )
    }
}

