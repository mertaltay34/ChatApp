//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by Mert Altay on 14.08.2023.
//

import Foundation

struct MessageViewModel{
    private let lastUser: LastUser
    init(lastUser: LastUser) {
        self.lastUser = lastUser
    }
    var profileImage: URL? {
        return URL(string: lastUser.user.profileImageUrl)
    }
    var timestampString: String{
        let date = lastUser.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm" // Örnek çıktı: "03:30 PM" olacak
        return dateFormatter.string(from: date)
    }
}
