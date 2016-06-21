//
//  AppDelegate.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/19/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "parse-tagram"
                configuration.clientKey = "eorubnpeoriagjwefijap"  // set to nil assuming you have not set clientKey
                configuration.server = "https://parse-tagram.herokuapp.com/parse"
            })
        )
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        
        let homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
        homeViewController.tabBarItem.title = "Feed"
        //homeViewController.tabBarItem.image = UIImage(named: "movies")

        let postViewController = storyboard.instantiateViewControllerWithIdentifier("PostViewController")
        postViewController.tabBarItem.title = "Post"
        //postViewController.tabBarItem.image = UIImage(named: "dvd")
        
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeViewController, postViewController]

        if PFUser.currentUser() != nil {
            // if there is a logged in user then load the home view controller
            
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
            
        }
        else {
            window?.rootViewController = loginViewController
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

