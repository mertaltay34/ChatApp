//
//  ChatInputView.swift
//  ChatApp
//
//  Created by Mert Altay on 7.08.2023.
//

import UIKit
import SnapKit

protocol ChatInputViewProtocol: AnyObject {
    func sendMessage(_ chatInputView: ChatInputView, message: String)
}

class ChatInputView: UIView{
    //MARK: - Properties
    weak var delegate: ChatInputViewProtocol?
    private let textInputView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.layer.cornerRadius = 10
        return textView
    }()
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        return button
    }()
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Message"
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    //MARK: - Lifecyle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        addSubview()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    //MARK: - Helpers
extension ChatInputView{
    func clear(){
        textInputView.text = nil
        placeHolderLabel.isHidden = false
    }
    private func style(){
        autoresizingMask = .flexibleHeight
        configureGradientLayer()
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // sadece sol üst ve sağ süttü büküyor
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputView), name:  UITextView.textDidChangeNotification, object: nil)
    }
    private func addSubview(){
        addSubview(textInputView)
        addSubview(sendButton)
        addSubview(placeHolderLabel)
    }
    private func layout(){
        textInputView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-4)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(55)
        }
        
        placeHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(textInputView.snp.top)
            make.leading.equalTo(textInputView.snp.leading).offset(8)
            make.trailing.equalTo(textInputView.snp.trailing)
            make.bottom.equalTo(textInputView.snp.bottom).offset(-8)
        }
    }
}
    //MARK: - Selectors

extension ChatInputView{
    @objc private func handleTextInputView(){
        placeHolderLabel.isHidden = !textInputView.text.isEmpty
    }
    @objc private func handleSendButton(_ sender: UIButton){
        guard let message = textInputView.text else { return }
        self.delegate?.sendMessage(self, message: message)
    }
}
