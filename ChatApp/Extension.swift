//
//  Extension.swift
//  ChatApp
//
//  Created by Mert Altay on 18.07.2023.
//

import UIKit

extension UIViewController {
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.locations = [0,1]
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
}
