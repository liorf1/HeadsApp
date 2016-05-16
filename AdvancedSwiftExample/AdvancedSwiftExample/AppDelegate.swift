//
//  AppDelegate.swift
//  AdvancedSwiftExample
//
//  Copyright © 2016 HeadsApp. All rights reserved.
//

import UIKit
import HeadsAppSDK

let APP_ID = "APP_ID"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, HeadsAppSDKDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
        HeadsAppSDK.sharedSDK()?.startWithAppId(APP_ID, delegate: self)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - HeadsAppSDKDelegate
    
    //MARK: Video ADs related methods

    /** Video AD availability to play
     *
     * Called when the SDK has changed video ad availability status to available or not available. If an AD is available for a placement the App can immediately display it.
     *
     * @param isVideoAdAvailable video AD is available to play. Boolean.
     * @param placementId placement ID where the AD is available.
     */
    func headsappVideoAdPlayableChanged(isVideoAdAvailable: Bool, forPlacementID placementId: String) {
        print("headsappVideoAdPlayableChanged:\(isVideoAdAvailable) forPlacementID:\(placementId)");
        print("Advertiser name: \(HeadsAppSDK.sharedSDK()?.getAdvertiserNameForPlacementID(placementId))");
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.kAdAvailabilityChangedNotification, object: nil, userInfo: [Constants.kPlacementIDKey: placementId, Constants.kAdAvailableKey: isVideoAdAvailable])
    }
    
    //MARK: Full Screen ADs (interstitial and video ADs)
    
    /** The SDK is about to show a full screen AD
     *
     * Called when the SDK is about to play a full screen ad (video or interstitial).  The override of this method is a good place to pause gameplay, sound effects, animations, etc
     */
    func headsappSDKWillShowFullScreenAd() {
        print("headsappSDKWillShowFullScreenAd")
    }
 
    /** AD is about to close
     * There are three ways a user might leave an ad experience:
     * - completing the video ad (where the presented ad closes automatically)
     * - pressing the close button on an in-progress or completed ad
     * - clicking on the AD which opens a web view or the download button, in which case we will open the in-app app-store that iOS provides.
     *
     * In all of these cases, this callback will get fired, as the main HeadsApp app is dismissed. There is a boolean `willPresentProductSheet` sent to this event to denote whether the web view or AppStore will be shown.
     * If willPresentProductSheet is NO, then this is the time to resume your app’s animations and sound. Otherwise, wait for headsappSDKwillCloseProductSheet event to resume activity.
     * There is also a viewInfo dictionary passed which contains information about the user’s ad experience (including whether or not the ad was completed). This can be used to determining incentivized reward status.
     *
     * @param viewInfo is a dictionary with the following keys:
     * HeadsAppVideoAdFinishedKey – true/false.
     * HeadsAppAdProviderInfoKey – this object will hold any information the specific AD provider will report about view status.
     * @param willPresentProductSheet Boolean parameter denoting whether the web view or AppStore will be shown.
     */
    func headsappSDKWillCloseAdWithViewInfo(viewInfo: [NSObject : AnyObject], willPresentProductSheet: Bool) {
        print("headsappSDKWillCloseAdWithViewInfo:\(viewInfo) willPresentProductSheet:\(willPresentProductSheet)")
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.kAdVideoClosedNotification, object: nil, userInfo: viewInfo)
    }
    
    /** Product sheet is about to close – returning to the App
     *
     * Will fire in the case when a user had opted to download the advertised app, and is now closing out of the in-app app store.
     * This event can be used to resume animations, sound effects, etc. when returning to the app.
     */
    func headsappSDKWillCloseProductSheet() {
        print("headsappSDKWillCloseProductSheet")
    }
    
    //MARK: All types of ADs
    
    /** AD finished loading
     *
     * If the AD type of the placement is video, this callback is called when the SDK has successfully received an Video AD and it's ready to be displayed by the app. If the placement AD type is banner, offer wall or interstitial, this callback is called when the placement is initialized and ready to be requested for ADs. The developer will use this delegate in order to request display of ADs.
     * This is to avoid the display of a blank ad placement.
     *
     * @param placementId placement ID where the AD loaded.
     */
    func headsappSDKAdReadyForViewForPlacementID(placementId: String) {
        print("headsappSDKAdReadyForViewForPlacementID:\(placementId)")
        print("Advertiser name: \(HeadsAppSDK.sharedSDK()?.getAdvertiserNameForPlacementID(placementId))")
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.kAdAvailabilityChangedNotification, object: nil, userInfo: [Constants.kPlacementIDKey: placementId, Constants.kAdAvailableKey: true])
    }
    
    /** AD will be displayed
     *
     * Called when the SDK is about to display the AD
     * @param placementId placement ID where the AD is available for.
     */
    func headsappSDKAdWillDisplayForPlacementID(placementId: String) {
        print("headsappSDKAdWillDisplayForPlacementID:\(placementId)")
        print("Advertiser name: \(HeadsAppSDK.sharedSDK()?.getAdvertiserNameForPlacementID(placementId))")
    }
    
    /** AD failed to be received
     *
     * Called when the SDK has failed to load. This is used to hide the placement for better UX behavior.
     * @param placementId placement ID where the AD failed for.
     */
    func headsappSDKAdFailedToReceiveForPlacementID(placementId: String) {
        print("headsappSDKAdFailedToReceiveForPlacementID:\(placementId)")
        print("Advertiser name: \(HeadsAppSDK.sharedSDK()?.getAdvertiserNameForPlacementID(placementId))")
        
        if let sdk = HeadsAppSDK.sharedSDK() {
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.kAdAvailabilityChangedNotification, object: nil, userInfo: [Constants.kPlacementIDKey: placementId, Constants.kAdAvailableKey :(sdk.isAdPlayableForPlacementID(placementId))])
        }
    }
}

