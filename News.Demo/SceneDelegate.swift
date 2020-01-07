//
//  SceneDelegate.swift
//  News.Demo
//
//  Created by Mikhail Kulichkov on 07.01.2020.
//  Copyright © 2020 Kulichkov. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	var coordinator: Coordinator!

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		print("Running on iOS 13")

		guard let windowScene = (scene as? UIWindowScene) else { return }

		let newWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
		self.window = newWindow
		newWindow.windowScene = windowScene
		coordinator = AppCoordinator(window: newWindow)
		coordinator.start()
	}

}
