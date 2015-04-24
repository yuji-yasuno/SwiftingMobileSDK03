//
//  AppDelegate.swift
//  SwiftingMobileSDK03
//
//  Created by 楊野 勇智 on 2015/04/24.
//  Copyright (c) 2015年 salesforce.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let remoteAccessConsumerKey = "3MVG9I1kFE5Iul2DxbuCBdtLomA.A533g5oph7WAxmCyBRLyhtekcRv902I7avM_F4OCnShi0qaGMGmj_YtWe"
    let oauthRedirectURI = "sfdc:///success"
    var initialLoginSuccessBlock : SFOAuthFlowSuccessCallbackBlock?
    var initialLoginFailureBlock : SFOAuthFlowFailureCallbackBlock?
    var userManagementCompletionBlock : SFUserManagementCompletionBlock?
    
    override init() {
        super.init()
        
        SFLogger.setLogLevel(SFLogLevelDebug)
        SalesforceSDKManager.sharedManager().connectedAppId = self.remoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = self.oauthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = ["web", "api"]
        
        weak var weakSelf : AppDelegate! = self
        SalesforceSDKManager.sharedManager().postLaunchAction = {(launchActionList : SFSDKLaunchAction) in
            self.setupRootViewController()
        }
        SalesforceSDKManager.sharedManager().launchErrorAction = {(error : NSError!, lauchActionList : SFSDKLaunchAction) in
            println("error while SalesforceSDK Manager launched: \(error.description)")
            self.initializeAppViweState()
            SalesforceSDKManager.sharedManager().launch()
        }
        SalesforceSDKManager.sharedManager().postLogoutAction = {
            weakSelf.handleSdkManagerLogout()
        }
        SalesforceSDKManager.sharedManager().switchUserAction = {(fromUser : SFUserAccount!, toUser : SFUserAccount!) in
            
        }
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.initializeAppViweState()
        SalesforceSDKManager.sharedManager().launch()
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
    
    // MARK: Setting view controllers
    private func initializeAppViweState() {
        let board = UIStoryboard(name: "Main", bundle: nil)
        self.window?.rootViewController = board.instantiateViewControllerWithIdentifier("splush") as? UIViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func setupRootViewController() {
        let board = UIStoryboard(name: "Main", bundle: nil)
        self.window?.rootViewController = board.instantiateInitialViewController() as? UIViewController
    }
    
    private func resetViewState(postResetBlock : () -> Void) {
        if self.window?.rootViewController?.presentedViewController != nil {
            self.window?.rootViewController?.dismissViewControllerAnimated(false, completion: postResetBlock)
        } else {
            postResetBlock()
        }
    }
    
    // MARK: Handling login operation
    private func handleSdkManagerLogout() {
        self.log(SFLogLevelDebug, msg: "SFAuthenticationManager logged out. Reseting app.")
        self.resetViewState({
            self.initializeAppViweState()
            
            let allAcounts = SFUserAccountManager.sharedInstance().allUserAccounts as? [SFUserAccount]
            if allAcounts?.count > 1 {
                
            } else {
                if allAcounts?.count == 1 {
                    SFUserAccountManager.sharedInstance().currentUser = SFUserAccountManager.sharedInstance().allUserAccounts[0] as! SFUserAccount
                }
                SalesforceSDKManager.sharedManager().launch()
            }
        })
    }
    
    private func handleUserSwitch(fromUser : SFUserAccount, toUser : SFUserAccount) {
        self.log(SFLogLevelDebug, msg: "SFUserAccountManager changed from user \(fromUser.userName) to \(toUser.userName). Resetting app.")
        self.resetViewState({
            self.initializeAppViweState()
            SalesforceSDKManager.sharedManager().launch()
        })
    }
    
}
