//
//  AppDelegate.swift
//  List
//
//  Created by Rémi Caroff on 21/01/2019.
//  Copyright © 2019 Rémi Caroff. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var listInteractor: ListInteractorInput?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    IQKeyboardManager.shared.enable = true
    
    guard let nc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UINavigationController else { return true }
    guard let vc = nc.viewControllers.first as? ListViewController else { return true }
    
    let storage = UserDefaultsStorage()
    let repo = ListRepository(with: storage)
    let interactor = ListInteractor(repository: repo)
    let presenter = ListPresenter(interactor: interactor)
    interactor.output = presenter
    presenter.output = vc
    vc.presenter = presenter
    
    self.window?.rootViewController = nc
    
    listInteractor = interactor
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    listInteractor?.saveState()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    listInteractor?.saveState()
  }
}
