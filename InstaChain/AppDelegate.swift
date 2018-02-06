//
//  AppDelegate.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SideMenuController
import SVProgressHUD
import TOPasscodeViewController
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        ReachabilityManager.setup()
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: AssetName.menu.rawValue)?.withRenderingMode(.alwaysOriginal)
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = SIDE_MENU_WIDTH
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let sideMenuViewController = SideMenuController()
        let homeController = HomeController()
        let navController = UINavigationController(rootViewController: homeController)
        let sideController = SideController()
        
        sideMenuViewController.embed(sideViewController: sideController)
        sideMenuViewController.embed(centerViewController: navController)
        
        window?.rootViewController = sideMenuViewController
        
        setNavBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNavBar), name: .resetNavBarTintColor, object: nil)
        
        //get rid of balck bar underneath navbar
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(),  for: .default)
        
        application.statusBarStyle = .lightContent
        
//        let statusBarBackgroundView = UIView()
//        statusBarBackgroundView.backgroundColor = StyleGuideManager.realyfeDefaultGreenColor
//        window?.addSubview(statusBarBackgroundView)
//        window?.addConnstraintsWith(Format: "H:|[v0]|", views: statusBarBackgroundView)
//        window?.addConnstraintsWith(Format: "V:|[v0(20)]", views: statusBarBackgroundView)
        
        
        return true
    }

    @objc fileprivate func setNavBar() {
        UINavigationBar.appearance().barTintColor = DarkModeManager.getNavBarTintColor()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24)]
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
        
        guard let currentController = currentViewController() else { return }
        
        if isSecurity() {
            var passcodeController: TOPasscodeViewController
            if isDarkMode() {
                passcodeController = TOPasscodeViewController(style: .translucentDark, passcodeType: .fourDigits, titleName: "Enter Security Pin")
            } else {
                passcodeController = TOPasscodeViewController(style: .translucentLight, passcodeType: .fourDigits, titleName: "Enter Security Pin")
            }
            
            passcodeController.delegate = self
            passcodeController.cancelButton.isHidden = true
            currentController.present(passcodeController, animated: false, completion: nil)
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//MARK: handle security pin controller
extension AppDelegate: TOPasscodeViewControllerDelegate {
    
    fileprivate func isSecurity() -> Bool {
        
        return UserDefaults.standard.isSecuirty()
    }
    
    func passcodeViewController(_ passcodeViewController: TOPasscodeViewController, isCorrectCode code: String) -> Bool {
        
        print("code: ", code)
        
        guard let passCode = UserDefaults.standard.getSecurityCode() else { return false }
        
        if code == passCode {
            return true
        } else {
            return false
        }
        
    }
    
    func didTapCancel(in passcodeViewController: TOPasscodeViewController) {
        
    }
    
}


