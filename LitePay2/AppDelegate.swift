import UIKit
import coinbase_official

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("App delegate line 16, url.scheme: \(String(describing: url.scheme))")
        print("App delegate line 17, url: \(url)")
        
        if url.scheme == "dmaenhout.litepay2" {
            print("App delegate line 20, url.scheme matches. Started (method) finish authentication")
            CoinbaseOAuth.finishAuthentication(for: url, clientId: LitePayData.clientId, clientSecret: LitePayData.clientSecret,
                completion:
                { (result : Any?, error: Error?) -> Void in
                    if error != nil {
                        // Could not authenticate.
                        print("App delegate line 26, Could not authenticate (error): \(String(describing: error))" )
                    }
                    else {
                        // Tokens successfully obtained!
                        print("App delegate line 30, obtained tokens")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeController = storyboard.instantiateViewController(withIdentifier: "homescreen") as! HomeViewController
                        let tabbarController = storyboard.instantiateViewController(withIdentifier: "tabBarControllerID") as! UITabBarController
                        print("App delegate line 34, go to method authentication complete in home view controller")
                        homeController.authenticationComplete(result as? [AnyHashable : Any])
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = tabbarController
                        self.window?.makeKeyAndVisible()
                        
                        print("App delegate line 40, make home screen visible")
                        
                    }
            } )
            return true
        }
        else {
            print("App delegate line 47, url.scheme doesn't match")
            return false
        }
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


}

