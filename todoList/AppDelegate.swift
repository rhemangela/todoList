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
//        UINavigationBar.appearance().backgroundColor = UIColor(red: 245, green: 0, blue: 87, alpha: 100) ;
        UINavigationBar.appearance().backgroundColor = UIColor.blue;
        IQKeyboardManager.shared.enable = true
        print(Realm.Configuration.defaultConfiguration.fileURL);
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext();
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

       // MARK: - Core Data Saving support

       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }


}

