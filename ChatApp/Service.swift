//
//  Service.swift
//  ChatApp
//
//  Created by Mert Altay on 7.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Service{
    static func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            users = snapshot?.documents.map({User(data: $0.data())}) ?? []
            completion(users)
        }
    }
    static func sendMessage(message: String, toUser: User, completion: @escaping(Error?) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = [
            "text" : message,
            "fromId" : currentUid,
            "toId" : toUser.uid,
            "timestamp" : Timestamp(date: Date())
        ] as [String : Any]
        // mesajı gönderirken: messagesları ekleyeceğimizi belirtiyoruz. curentUid adı altında bir döküman oluşturuyoruz. bunun içerisine de bir collection açıyoruz.  hangi dökümanı ekleyeceğimizi belirtiyoruz. birde completion açıyoruz. bu açtığımız completion yapısı içerisine aynı işlemi tersten yapıyoruz çünkü ben birisiyle mesajlaşırken hem benim ekranımda hemde onun ekranında o mesajların görüntülenmesi gerekmekte.
        Firestore.firestore().collection("messages").document(currentUid).collection(toUser.uid).addDocument(data: data) { error in
            Firestore.firestore().collection("messages").document(toUser.uid).collection(currentUid).addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchMessages(user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("messages").document(currentUid).collection(user.uid).order(by: "timestamp").addSnapshotListener { snapshot, error in // addSnapshotListener, Firebase platformunda Firestore veritabanındaki belirli bir koleksiyonun veya belirli bir sorgunun değişikliklerini izlemek ve dinlemek için kullanılan bir fonksiyondur.
            snapshot?.documentChanges.forEach({ value in
                if value.type == .added {
                    let data = value.document.data()
                    messages.append(Message(data: data))
                    completion(messages)
                }
            })
        }
    }
}
