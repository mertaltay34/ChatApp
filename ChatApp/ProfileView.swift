//
//  ProfileView.swift
//  ChatApp
//
//  Created by Mert Altay on 14.08.2023.
//

import UIKit
import FirebaseAuth
import SnapKit
import SDWebImage

protocol ProfileViewProtocol: AnyObject{
    func signOutProfile()
}
class ProfileView: UIView{
    //MARK: - Properties
     var user: User?{
        didSet{
            configure()
        }
    }
    weak var delegate: ProfileViewProtocol?
    private let gradient = CAGradientLayer()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignOut", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.systemRed
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        return button
    }()
    private lazy var stackView = UIStackView()
    //MARK: - Lifecyle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        addSubviews()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}
    //MARK: - Selectors
extension ProfileView{
    @objc private func handleSignOutButton(_ sender: UIButton){
        delegate?.signOutProfile()
    }
}
    //MARK: - Helpers
extension ProfileView{
    private func style(){
        clipsToBounds = true
        gradient.locations = [0,1]
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        layer.addSublayer(gradient)
        profileImageView.layer.cornerRadius = 120 / 2
        // stackView
        stackView = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, signOutButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
    }
    private func addSubviews(){
        addSubview(profileImageView)
        addSubview(stackView)
    }
    private func layout(){
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
//            make.leading.equalToSuperview().offset(12)
//            make.trailing.equalTo(stackView.snp.trailing).offset(-12)
            make.centerX.equalToSuperview()
        }
    }
    private func attributeTitle(headerTitle: String, title: String) -> NSMutableAttributedString{
        let attributed = NSMutableAttributedString(string: "\(headerTitle): ", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7), .font:UIFont.systemFont(ofSize: 16, weight: .bold)])
        attributed.append(NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]))
        return attributed
    }
    private func configure(){
        guard let user = self.user else { return }
        self.usernameLabel.attributedText = attributeTitle(headerTitle: "Username", title: "\(user.username)")
        self.nameLabel.attributedText = attributeTitle(headerTitle: "Name", title: "\(user.name)")
        self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
    }
}
