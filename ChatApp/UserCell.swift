//
//  UserCell.swift
//  ChatApp
//
//  Created by Mert Altay on 3.08.2023.
//

import UIKit
import SnapKit
import SDWebImage

class UserCell: UITableViewCell {
    //MARK: - Properties
    var user: User? {
        didSet{
            configureUserCell()
        }
    }
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // görselin çerçevesini büktüğümüzde içerisinde ekli olan imagein de bükülmesini sağlıyor.
        imageView.layer.cornerRadius = 55 / 2 // dairesel göstermek için 2 ye bölüyoruz.
        return imageView
    }()
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Title"
        return label
    }()
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Subtitle"
        label.textColor = .lightGray
        return label
    }()
    private var stackView = UIStackView()
    //MARK: - Lifecyle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        setup()
        addSubview()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    //MARK: - Helpers
extension UserCell{
    private func configureUserCell(){
        guard let user = user else { return }
        self.title.text = user.name
        self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        self.subtitle.text = user.username
        
    }
    private func setup(){
        stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.axis = .vertical
//        stackView.spacing = 2
    }
    private func addSubview() {
        addSubview(profileImageView)
        addSubview(stackView)
    }
    private func layout(){
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(55)
            make.leading.equalToSuperview().offset(8)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
