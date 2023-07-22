//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Mert Altay on 20.07.2023.
//

import Foundation

struct LoginViewModel {
    var emailTextField: String?
    var passwordTextField: String?
    var status: Bool {
        return emailTextField?.isEmpty == false && passwordTextField?.isEmpty == false
    }
}
