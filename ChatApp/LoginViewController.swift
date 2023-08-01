//
//  ViewController.swift
//  ChatApp
//
//  Created by Mert Altay on 18.07.2023.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    private let logoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.image = UIImage(systemName: "ellipsis.message")
        imageview.tintColor = .white
        return imageview
    }()
    private lazy var emailContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        return containerView
    }()
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var passwordContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        return containerView
    }()
    private let passwordTextField: CustomTextField = {
       let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private var stackView = UIStackView()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 7
        return button
    }()
    private lazy var switchToRegistrationPage: UIButton = {
        let button = UIButton(type: .system)
        var attributedTitle = NSMutableAttributedString(string: "Click to Become A Member", attributes: [.foregroundColor:UIColor.white, .font : UIFont.boldSystemFont(ofSize: 14)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleGoToRegisterView), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        style()
        addSubview()
        layout()
    }
}
    //MARK: - Selector
extension LoginViewController {
    @objc private func handleGoToRegisterView(_ sender: UIButton) {
        let controller = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @objc private func handleTextFieldChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.emailTextField = sender.text
        } else {
            viewModel.passwordTextField = sender.text
        }
        loginButtonStatus()
    }
}
    //MARK: - Helpers
extension LoginViewController {
    private func loginButtonStatus() {
        if viewModel.status{
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemBlue
        }else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    private func style() {
        navigationController?.navigationBar.isHidden = true
        // stackview
        stackView = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        // TextDidChange
        emailTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
    }
    private func addSubview() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(switchToRegistrationPage)
    }
    private func layout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview() // X ekseninde merkez
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        switchToRegistrationPage.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(stackView.snp.leading)
            make.trailing.equalTo(stackView.snp.trailing)
        }
    }
}
