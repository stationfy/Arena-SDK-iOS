import UIKit
import ArenaChatSDK

class ViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OwnMessageCell.self, forCellReuseIdentifier: "OwnMessageCell")
        tableView.showsVerticalScrollIndicator = false
        //tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var chatView: ChatView = {
        let view = ChatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        view.backgroundColor = . white
        
       // view.addSubview(tableView)
        view.addSubview(chatView)
        
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //chatView.heightAnchor.constraint(equalToConstant: 48)

            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
       // tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnMessageCell", for: indexPath) as! OwnMessageCell
        return cell
    }
}

extension ViewController: UITableViewDelegate { }

