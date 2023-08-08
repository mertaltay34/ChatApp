//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Mert Altay on 2.08.2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    //MARK: - Properties
    private var messageButton: UIBarButtonItem!
    private var newMessageButton: UIBarButtonItem!
    private var container = Container()
    private let messageViewController = NewMessageViewController()
    private lazy var viewControllers: [UIViewController] = [MessageViewController(), messageViewController]
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationStatus()
//        signOut()
        style()
        addSubview()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        handleMessageButton()
    }
}
    //MARK: - Selectors
extension HomeViewController{
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
    private func style(){
        view.backgroundColor = .white
        messageButton = UIBarButtonItem(customView: configureBarItem(text: "Message", selector: #selector(handleMessageButton)))
        newMessageButton = UIBarButtonItem(customView: configureBarItem(text: "New Message", selector: #selector(handleNewMessageButton)))
        self.messageViewController.delegate = self
        // container
        configureContainer()
        handleMessageButton()
    }
    private func addSubview(){
        self.navigationItem.leftBarButtonItems = [messageButton, newMessageButton]
    }
    private func layout(){
        
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
}
extension HomeViewController: NewMessageViewControllerProtocol{
    func goToChatView(user: User) {
        let controller = ChatViewController(user: user)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
