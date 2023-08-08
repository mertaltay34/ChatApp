//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by Mert Altay on 18.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowsScene)
        window?.rootViewController = configureNavigationController(rootViewController: HomeViewController())
        window?.makeKeyAndVisible()
    }
    
    private func configureNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor] // 2 kere mavi yazmamız üst tarafın daha yoğun mavi ile başlamasını sağlıyor
        gradient.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.height * 2, height: 64)
        let controller = UINavigationController(rootViewController: rootViewController)
        let apperance = UINavigationBarAppearance()
        apperance.configureWithDefaultBackground()
        apperance.backgroundImage = self.image(fromLayer: gradient)
        apperance.titleTextAttributes = [.foregroundColor: UIColor.white, .font :  UIFont.preferredFont(forTextStyle: .title2)]
        controller.navigationBar.standardAppearance = apperance
        controller.navigationBar.compactAppearance = apperance
        controller.navigationBar.scrollEdgeAppearance = apperance
        controller.navigationBar.compactScrollEdgeAppearance = apperance
        return controller
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {  // navbar backgroung image hazırlamak için hazır bir fonksiyon
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

