//
//  AuthenticationService.swift
//  ChatApp
//
//  Created by Mert Altay on 2.08.2023.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct AuthenticationServiceUser {
    var emailText: String
    var nameText: String
    var usernameText: String
    var passwordText: String
}

struct AuthenticationService {
    static func login(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    static func register(withUser user: AuthenticationServiceUser ,image: UIImage, completion: @escaping(Error?) -> Void) {
        let photoName = UUID().uuidString
        guard let profileData = image.jpegData(compressionQuality: 0.5) else { return }
        let referance = Storage.storage().reference(withPath: "media/profile_image/\(photoName).png")
        referance.putData(profileData) { storageMeta, error in
            if let error = error {
                completion(error)
                return
            }
            referance.downloadURL { url, error in
                if let error = error {
                    completion(error)
                    return
                }
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: user.emailText, password: user.passwordText) { result, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    guard let userUid = result?.user.uid else { return  }
                    let data = [
                        "email"         : user.emailText,
                        "name"          : user.nameText,
                        "username"       : user.usernameText,
                        "profileImageUrl" : profileImageUrl,
                        "uid"           : userUid
                    ] as [String : Any]
                    Firestore.firestore().collection("users").document(userUid).setData(data, completion: completion )
                }
            }
        }
    }
}
