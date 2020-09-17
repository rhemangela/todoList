//
//  AppDelegate.swift
//  todoList
//
//  Created by Angela on 26/7/2020.
//  Copyright © 2020 AT Production. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        print("the folder of Realm,\(Realm.Configuration.defaultConfiguration.fileURL)");

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    //variable that store coreData
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
           let container = NSPersistentCloudKitContainer(name: "listData")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
}

