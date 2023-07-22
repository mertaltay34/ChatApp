//
//  AuthenticationInputView.swift
//  ChatApp
//
//  Created by Mert Altay on 18.07.2023.
//

import UIKit
import SnapKit

class AuthenticationInputView: UIView {
    init(image: UIImage, textField: UITextField) {
        super.init(frame: .zero)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.tintColor = .white
       /*
        // kenarlık ekledik email ve password kısmına şimdilik kaldırıyorum ancak güzel oluyor
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.77
        layer.cornerRadius = 10 */
        addSubview(imageView)
        addSubview(textField)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.centerY)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(0.70)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
