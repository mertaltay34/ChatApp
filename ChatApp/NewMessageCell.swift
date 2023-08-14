//
//  MessageCell.swift
//  ChatApp
//
//  Created by Mert Altay on 8.08.2023.
//

import UIKit
import SnapKit
import SDWebImage

class NewMessageCell: UICollectionViewCell {
    //MARK: - Properties
    var messageContainerViewLeft: NSLayoutConstraint!
    var messageContainerViewRight: NSLayoutConstraint!
    var message: Message? {
        didSet{
            configure()
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
    private let messageContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemBlue
        return containerView
    }()
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.text = "Message"
        textView.textColor = .white
        return textView
    }()
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
}
    //MARK: - Helpers
extension NewMessageCell{
    private func style(){
        messageContainerView.layer.cornerRadius = 10
        messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    }
    private func addSubviews(){
        addSubview(profileImageView)
        addSubview(messageContainerView)
        addSubview(messageTextView)
    }
    private func layout(){
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(34)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
        }
        messageContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(300)
        }
        self.messageContainerViewLeft = messageContainerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        self.messageContainerViewLeft.isActive = false
        self.messageContainerViewRight = messageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        self.messageContainerViewRight.isActive = false
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(messageContainerView.snp.top)
            make.leading.equalTo(messageContainerView.snp.leading)
            make.trailing.equalTo(messageContainerView.snp.trailing)
            make.bottom.equalTo(messageContainerView.snp.bottom)
        }
    }
    private func configure(){
        guard let message = self.message else { return }
        let viewModel = NewMessageViewModel(message: message)
        messageTextView.text = message.text
        messageContainerView.backgroundColor = viewModel.messageBackgroundColor
        messageContainerViewRight.isActive = viewModel.currentUserActive
        messageContainerViewLeft.isActive = !viewModel.currentUserActive
        profileImageView.isHidden = viewModel.currentUserActive
        profileImageView.sd_setImage(with: viewModel.profileImageView)
        if viewModel.currentUserActive{
            messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        } else{
            messageContainerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        }
    }
}
