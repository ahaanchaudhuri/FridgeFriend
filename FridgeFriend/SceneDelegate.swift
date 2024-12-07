//
//  SceneDelegate.swift
//  FridgeFriend
//
//  Created by Ahaan Chaudhuri on 12/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create the main window
        let window = UIWindow(windowScene: windowScene)

        // Set the initial view controller
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // This method is called when the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // This method is called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // This method is called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // This method is called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // This method is called as the scene transitions from the foreground to the background.
    }
}





