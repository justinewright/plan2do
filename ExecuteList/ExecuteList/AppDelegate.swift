//
//  AppDelegate.swift
//  ExecuteList
//
//  Created by Justine Wright on 2021/06/13.
//

import UIKit
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            let _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }




}

