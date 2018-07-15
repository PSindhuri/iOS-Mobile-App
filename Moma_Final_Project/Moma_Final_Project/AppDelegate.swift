//
//  AppDelegate.swift
//  Moma_Final_Project
//
//  Created by Sindhuri Punyamurthula on 11/19/16.
//  Copyright © 2018 Sindhuri. All rights reserved.
//

import UIKit
import UserNotifications
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var count = 1
    var window: UIWindow?
    var eventStore: EKEventStore?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //Asks user for granting permission for local reminders
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        {(accepted, error) in
            if !accepted
            {
                print("appDeldebug(ADS): Notification access not permitted.")
            }
         }
        /**********************/
        checkFirstTime()
        /************************/
        return true
    }
    
    //Function for Scheduling Daily Reminders
    func scheduleNotification(at date:Date,title:String="")
    {
        print("appDeldebug(ADS): Entered notification notitle func")
        let cal = Calendar(identifier: .gregorian)
        let comp = cal.dateComponents(in: .current, from: date)
        if(title=="")
        {
           print("appDeldebug(ADS): in notitle")
        let newComp = DateComponents(hour: comp.hour, minute: comp.minute)
        print(newComp)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComp, repeats: true)
           
        
        let content = UNMutableNotificationContent()
        content.title = "MoMa Reminder"
        content.body = "Reminding to update today's expenditure."
        
        let request = UNNotificationRequest(identifier: "settingsNotification",content:content, trigger:trigger)
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
       
        UNUserNotificationCenter.current().add(request){(error) in if let error = error
            {
                print("appDeldebug(ADS): Something is wrong! with error \(error)")
            }
        }
        }//end of if
    }
    
    //Function for scheduling EditTableViewController montly reminders. Reminds everymonth
    func scheduleNotification2(at date:Date,title:String="",identifier:String="")
    {
        print("appDeldebug(ADS): Entered notification func2. Count is:\(count)")
        let cal = Calendar(identifier: .gregorian)
        let comp = cal.dateComponents(in: .current, from: date)
        print(comp.day as Any)
        let newComp = DateComponents(day: comp.day, hour: comp.hour, minute: comp.minute)
        print("appDeldebug(ADS):In notification2,set components are:: \(newComp)")
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: newComp, repeats: true)
            
        let content2 = UNMutableNotificationContent()
        content2.title = "MoMa Reminder"
        let str:String="Reminding to update "+title
        content2.body = str
        
        let request2 = UNNotificationRequest(identifier: identifier,content:content2, trigger:trigger2)
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
        UNUserNotificationCenter.current().add(request2){(error) in if let error = error
        {
            print("appDeldebug(ADS): Something is wrong! with error \(error)")
            }
        }
     count=count+1
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //Checks if the App is opening for first time and directs user to either Login page or
    // dashboard of the app.
    func checkFirstTime()
    {
        print("appDeldebug(ADS): Checking first")
        let LoginCheck=LoginDatabaseAccess()
        let ret=LoginCheck.getAllUsers()
        if ret==nil
        {
            print("appDeldebug(ADS): nil-check")
             notransition()
        }
        else
        {
            print("appDeldebug(ADS): not nil-check")
           
            transitionToDashboard()
        }
        
        
    }
    func transitionToDashboard()
    {
        print("appDeldebug(ADS): transition")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "Nav") as! UINavigationController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()    }
    
    
    func notransition()
    {
        print("appDeldebug(ADS): no transition")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
    }

}//end of app

