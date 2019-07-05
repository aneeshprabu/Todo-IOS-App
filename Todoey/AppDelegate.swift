//
//  AppDelegate.swift
//  Todoey
//
//  Created by Aneesh Prabu on 09/06/19.
//  Copyright © 2019 Aneesh Prabu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("This is the path to database")
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        
        
        //MARK: - Step1: Initialize Realm
        do{
            _ = try Realm()
        }
        catch {
            print("Error initializing new Realm \(error)")
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
}

