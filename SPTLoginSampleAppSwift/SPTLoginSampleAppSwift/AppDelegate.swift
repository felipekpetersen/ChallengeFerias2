
import UIKit
import CloudKit
//import UserNotifications


@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var rootViewController = SignInViewController()

    func enterApp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        nav1.navigationBar.barTintColor = UIColor(red: 41.0 / 255.0, green: 41.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        nav1.navigationBar.tintColor = .white
        nav1.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                  NSAttributedString.Key.font: UIFont(name: "Mattilda", size: 28)!]
        let mainView = HomeViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }
    
    
    func subscribeToPushNotifications() {
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let _ = SpotifySingleton.shared().getRefreshToken() {
            enterApp()
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
        }
        
        UNUserNotificationCenter.current().delegate = self

        // Pede permissão para mandar notificações
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
          if authorized {
            DispatchQueue.main.async(execute: {
              application.registerForRemoteNotifications()
            })
          }
        })
//        let container = CKContainer.default()
//        let publicDatabase = container.publicCloudDatabase
//        let privateDatabase = container.privateCloudDatabase
//        
//        let record = CKRecord(recordType: "UserType")
//        record.setValue("teste", forKey: "id")
//        publicDatabase.save(record) { (record, err) in
//            print(record)
//            print(err)
//        }
        
        return true
    }
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SpotifySingleton.shared().sessionManager.application(app, open: url, options: options)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if (SpotifySingleton.shared().appRemote.isConnected) {
            SpotifySingleton.shared().appRemote.disconnect()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = SpotifySingleton.shared().appRemote.connectionParameters.accessToken {
            SpotifySingleton.shared().appRemote.connect()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .sound, .badge])
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // tell the app that we have finished processing the user’s action (eg: tap on notification banner) / response
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let subscription = CKQuerySubscription(recordType: "UserType", predicate: NSPredicate(format: "TRUEPREDICATE"), options: .firesOnRecordCreation)
        let info = CKSubscription.NotificationInfo()
//        info.titleLocalizationKey = "%1$@"
//        info.titleLocalizationArgs = ["title"]
        
        // if you want to use multiple field combined for the title of push notification
        // info.titleLocalizationKey = "%1$@ %2$@" // if want to add more, the format will be "%3$@", "%4$@" and so on
        // info.titleLocalizationArgs = ["title", "subtitle"]
        
        // this will use the 'content' field in the Record type 'notifications' as the content of the push notification
//        info.alertLocalizationKey = "%1$@"
//        info.alertLocalizationArgs = ["content"]
        info.alertBody = "isso é um aviso"
        info.title = "isso é um titulo"
        // increment the red number count on the top right corner of app icon
        info.shouldBadge = true
        
        // use system default notification sound
        info.soundName = "default"
        
        subscription.notificationInfo = info
        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { subscription, error in
            if error == nil {
                print("Subscription saved successfully")
                // Subscription saved successfully
            } else {
                print("subscription Error: \(error)")
                // Error occurred
            }
        })
    }
    
}
