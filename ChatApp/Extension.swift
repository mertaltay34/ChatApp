//
//  Extension.swift
//  ChatApp
//
//  Created by Mert Altay on 18.07.2023.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    func showProgressHud(showProgress: Bool){
        let progressHud = JGProgressHUD(style: .dark)
        progressHud.textLabel.text = "Please Wait"
        showProgress ? progressHud.show(in: view) : progressHud.dismiss()
    }
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.locations = [0,1]
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    func addChildViewController(_ child: UIViewController){
        addChild(child) // Alt bileşen eklenir
        self.view.addSubview(child.view) // Alt bileşenin görünümünü ana bileşene eklenir
        child.didMove(toParent: self) // Alt bileşenin "didMove" metodunu çağırarak eklenme işlemini tamamla
    }
    func removeChildViewController(){
        willMove(toParent: self)
        self.view.removeFromSuperview() // Alt bileşenin görünümünü ana bileşenden kaldır
        removeFromParent() // Alt bileşeni ana bileşenden çıkar
    }
    // eklerken didMove(toParent:) metodunu çağırmazsanız veya çıkarırken willMove(toParent:) metodunu çağırmazsanız, alt bileşenin yaşam döngüsü ve bellek yönetimi sorunları ortaya çıkabilir
}




