//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Mert Altay on 22.07.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    //MARK: Properties
    private var profileImageToUpload: UIImage?
    private var viewModel = RegisterViewModel()
    private lazy var addCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.contentVerticalAlignment = .fill // görseli dikeyde tamamen gösterir
        button.contentHorizontalAlignment = .fill // görseli yatayda tamamen gösterir
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
    }()
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let nameTextField = CustomTextField(placeholder: "Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    private let passwordTextField: CustomTextField = {
       let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var emailContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        return containerView
    }()
    private lazy var nameContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "person")!, textField: nameTextField)
        return containerView
    }()
    private lazy var usernameContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "person")!, textField: usernameTextField)
        return containerView
    }()
    private lazy var passwordContainerView: AuthenticationInputView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        return containerView
    }()
    private var stackView = UIStackView()
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    private lazy var switchToLoginPage: UIButton = {
        let button = UIButton(type: .system)
        var attributedTitle = NSMutableAttributedString(string: "If you are a member, return to the login page", attributes: [.foregroundColor:UIColor.white, .font : UIFont.boldSystemFont(ofSize: 14)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleGoToLoginView), for: .touchUpInside)
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        addSubview()
        layout()
    }
}
    //MARK: Selectors
extension RegisterViewController {
    @objc private func handleRegisterButton(_ sender: UIButton) {
        guard let emailText = emailTextField.text else { return }
        guard let nameText = nameTextField.text else { return }
        guard let usernameText = usernameTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let profileImage = profileImageToUpload else { return }

        let photoName = UUID().uuidString
        guard let profileData = profileImage.jpegData(compressionQuality: 0.5) else { return }
        let referance = Storage.storage().reference(withPath: "media/profile_image/\(photoName).png")
        referance.putData(profileData) { storageMeta, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            referance.downloadURL { url, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: emailText, password: passwordText) { result, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    guard let userUid = result?.user.uid else { return  }
                    let data = [
                        "email"         : emailText,
                        "name"          : nameText,
                        "username"       : usernameText,
                        "profileImageUrl" : profileImageUrl,
                        "uid"           : userUid
                    ] as [String : Any]
                    Firestore.firestore().collection("users").document(userUid).setData(data) { error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                        print("Successfully")
                    }
                    
                }
            }
        }
        
    }
    @objc private func handlePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true)
    }
    @objc private func handleGoToLoginView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func handleTextFieldChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == nameTextField {
            viewModel.name = sender.text
        } else if sender == usernameTextField {
            viewModel.userName = sender.text
        } else {
            viewModel.password = sender.text
        }
        registerButtonStatus()
    }
}
    //MARK: Helpers
extension RegisterViewController {
    private func registerButtonStatus() {
        if viewModel.status{
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemBlue
        }else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    private func style() {
        configureGradientLayer()
        self.navigationController?.navigationBar.isHidden = true
        //stackview
        stackView = UIStackView(arrangedSubviews: [emailContainerView, nameContainerView, usernameContainerView, passwordContainerView, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        
        // TextDidChange
        emailTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
    }
    private func addSubview() {
        view.addSubview(addCameraButton)
        view.addSubview(stackView)
        view.addSubview(switchToLoginPage)
    }
    private func layout(){
        addCameraButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(addCameraButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        switchToLoginPage.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(stackView.snp.leading)
            make.trailing.equalTo(stackView.snp.trailing)
        }
    }
}
    //MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.profileImageToUpload = image
        addCameraButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        addCameraButton.layer.cornerRadius = 150 / 2
        addCameraButton.clipsToBounds = true
        addCameraButton.layer.borderColor = UIColor.white.cgColor
        addCameraButton.layer.borderWidth = 2
        addCameraButton.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}
