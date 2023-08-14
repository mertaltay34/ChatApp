//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Mert Altay on 2.08.2023.
//

import UIKit
import FirebaseAuth
import SnapKit

class HomeViewController: UIViewController {
    //MARK: - Properties
    private var messageButton: UIBarButtonItem!
    private var newMessageButton: UIBarButtonItem!
    private var container = Container()
    private let newMessageViewController = NewMessageViewController()
    private let messageViewController = MessageViewController()
    private lazy var viewControllers: [UIViewController] = [messageViewController, newMessageViewController]
    private let profileView = ProfileView()
    private var isProfileViewActive: Bool = false
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationStatus()
//        signOut()
        style()
        addSubview()
        layout()
        fetchUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        handleMessageButton()
    }
}
    //MARK: - Selectors
extension HomeViewController{
    @objc private func handleProfileButton(_ sender: UIBarButtonItem){
        UIView.animate(withDuration: 0.5) {
            if self.isProfileViewActive{
                self.profileView.frame.origin.x = self.view.frame.width
            } else {
                self.profileView.frame.origin.x = self.view.frame.width * 0.4
            }
        }
        self.isProfileViewActive.toggle()
    }
    @objc private func handleMessageButton(){
        if self.container.children.first == MessageViewController() { return }
        self.container.addChildViewController(viewControllers[0])
        self.viewControllers[0].view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.messageButton.customView?.alpha = 1
            self.newMessageButton.customView?.alpha = 0.5
            self.viewControllers[0].view.alpha = 1
            self.viewControllers[1].view.frame.origin.x = -1000 // kenara kayıp gitmiş olacak
        } completion: { _ in
            self.viewControllers[1].removeChildViewController()
            self.viewControllers[1].view.frame.origin.x = 0 // bittikten sonra eski haline getirelim
        }
    }
    @objc private func handleNewMessageButton(){
        if self.container.children.first == NewMessageViewController() { return }
        self.container.addChildViewController(viewControllers[1])
        self.viewControllers[1].view.alpha = 0
        UIView.animate(withDuration: 1) {
            self.messageButton.customView?.alpha = 0.5
            self.newMessageButton.customView?.alpha = 1
            self.viewControllers[1].view.alpha = 1
            self.viewControllers[0].view.frame.origin.x = +1000 // kenara kayıp gitmiş olacak
        } completion: { _ in
            self.viewControllers[0].removeChildViewController()
            self.viewControllers[0].view.frame.origin.x = 0 // bittikten sonra eski haline getirelim
        }
    }
}
    //MARK: - Helpers
extension HomeViewController{
    private func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(uid: uid) { user in
            self.profileView.user = user
        }
    }
    private func style(){
        view.backgroundColor = .white
        messageButton = UIBarButtonItem(customView: configureBarItem(text: "Message", selector: #selector(handleMessageButton)))
        newMessageButton = UIBarButtonItem(customView: configureBarItem(text: "New Message", selector: #selector(handleNewMessageButton)))
        self.newMessageViewController.delegate = self
        self.messageViewController.delegate = self
        self.navigationController?.navigationBar.tintColor = .white
        // container
        configureContainer()
        handleMessageButton()
        profileView.delegate = self
        profileView.layer.cornerRadius = 20
        profileView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    private func addSubview(){
        self.navigationItem.leftBarButtonItems = [messageButton, newMessageButton]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self , action: #selector(handleProfileButton))
        view.addSubview(profileView)
    }
    private func layout(){
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.snp.trailing)  // = profileView.leadingAnchor.constraint(equalTo: view.trailingAnchor)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(view.frame.width * 0.6)
        }
    }
    private func configureBarItem(text: String, selector: Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    private func authenticationStatus(){
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated:  true)
            }
        }
    }
    private func signOut(){
        do{
            try Auth.auth().signOut()
            authenticationStatus()
        }catch {
            
        }
    }
    private func configureContainer(){
        guard let containerView = container.view else { return }
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    private func showChat(user: User){
        let controller = ChatViewController(user: user)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
    //MARK: - NewMessageViewControllerProtocol
extension HomeViewController: NewMessageViewControllerProtocol{
    func goToChatView(user: User) {
        self.showChat(user: user)
    }
}
    //MARK: - MessageViewControllerProtocol
extension HomeViewController: MessageViewControllerProtocol{
    func showChatViewController(_ messageViewController: MessageViewController, user: User) {
        self.showChat(user: user)
    }
}
    //MARK: -  ProfileViewProtocol
extension HomeViewController:  ProfileViewProtocol{
    func signOutProfile() {
        self.signOut()
    }
}
