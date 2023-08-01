//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Mert Altay on 22.07.2023.
//

import Foundation

struct RegisterViewModel {
    var email: String?
    var name: String?
    var userName: String?
    var password: String?
    
    var status: Bool {
        return email?.isEmpty == false && name?.isEmpty == false && userName?.isEmpty == false && password?.isEmpty == false 
    }
}
