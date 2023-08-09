//
//  MessageViewController.swift
//  ChatApp
//
//  Created by Mert Altay on 3.08.2023.
//

import UIKit
import SnapKit

private let reuseIdentifier = "MessageCell"
class MessageViewController: UIViewController {
    //MARK: - Properties
    private var lastUsers = [LastUser]()
    private let tableView = UITableView()
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLastUsers()
        style()
        addSubview()
        layout()
    }
    //MARK: - Service
    private func fetchLastUsers(){
    Service.fetchLastUsers { lastUsers in
        self.lastUsers = lastUsers
        self.tableView.reloadData()
    }
}

}
    //MARK: Helpers
extension MessageViewController{
    private func style(){
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    private func addSubview(){
        view.addSubview(tableView)
    }
    private func layout(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
    //MARK: - TableviewDataSource and Delegate
extension MessageViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lastUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
