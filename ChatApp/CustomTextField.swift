//
//  CustomTextField.swift
//  ChatApp
//
//  Created by Mert Altay on 18.07.2023.
//

import UIKit

class CustomTextField: UITextField {
     init(placeholder: String) {
        super.init(frame: .zero)
         attributedPlaceholder = NSMutableAttributedString(string: placeholder , attributes: [.foregroundColor:UIColor.white])
         borderStyle = .none // etrafında oluşturulan çerçeve
         textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
