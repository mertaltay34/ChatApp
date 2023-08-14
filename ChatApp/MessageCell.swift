//
//  MessageCell.swift
//  ChatApp
//
//  Created by Mert Altay on 14.08.2023.
//

import UIKit
import SnapKit
import SDWebImage

class MessageCell: UITableViewCell{
    //MARK: - Properties
    var lastUser: LastUser?{
        didSet{
            configureMessageCell()
        }
    }
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // görselin çerçevesini büktüğümüzde içerisinde ekli olan imagein de bükülmesini sağlıyor.
        imageView.layer.cornerRadius = 34 / 2 // dairesel göstermek için 2 ye bölüyoruz.
        return imageView
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private var stackView = UIStackView()
    private let timesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "5:5"
        return label
    }()
    //MARK: - Lifecyle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    //MARK: - Helpers
extension MessageCell{
    private func setup(){
        profileImageView.layer.cornerRadius = 55 / 2
        stackView = UIStackView(arrangedSubviews: [usernameLabel, lastMessageLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
    }
    private func addSubviews(){
        addSubview(profileImageView)
        addSubview(stackView)
        addSubview(timesLabel)
    }
    private func layout(){
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(55)
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-12)
          //  trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 12) üstteki ile aynı işlemi yapar
        }
        timesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    private func configureMessageCell(){
        guard let lastUser = self.lastUser else { return }
        let viewModel = MessageViewModel(lastUser: lastUser)
        self.usernameLabel.text = lastUser.user.username
        self.lastMessageLabel.text = lastUser.message.text
        self.profileImageView.sd_setImage(with: viewModel.profileImage)
        self.timesLabel.text = viewModel.timestampString
    }
}
