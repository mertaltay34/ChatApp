//
//  NewMessageViewController.swift
//  ChatApp
//
//  Created by Mert Altay on 3.08.2023.
//

import UIKit
import SnapKit

private let reuseIdentifier = "UserCell"
protocol NewMessageViewControllerProtocol: AnyObject {
    func goToChatView(user: User)
}
class NewMessageViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: NewMessageViewControllerProtocol?
    private let tableView = UITableView()
    private var users = [User]()
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        addSubview()
        layout()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
}
//MARK: Helpers
extension NewMessageViewController{
    private func style(){
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
    }
    private func addSubview(){
        view.addSubview(tableView)
    }
    private func layout(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.goToChatView(user: users[indexPath.row])
    }
}
