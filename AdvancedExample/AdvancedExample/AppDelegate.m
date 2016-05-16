//
//  AppDelegate.m
//  HeadsAppSampleApp
//
//  Created by HeadsApp on 9/2/15.
//  Copyright (c) 2015 HeadsApp. All rights reserved.
//

#import "AppDelegate.h"
#import <HeadsAppSDK/HeadsAppSDK.h>
#import "Constants.h"

#define APP_ID @"APP_ID"

@interface AppDelegate () <HeadsAppSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[HeadsAppSDK sharedSDK] startWithAppId:@"55ff1c9c458cfb132a614d2c" delegate:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - HeadsAppSDKDelegate

#pragma mark Video ADs related methods

/** Video AD availability to play
 *
 * Called when the SDK has changed video ad availability status to available or not available. If an AD is available for a placement the App can immediately display it.
 *
 * @param isVideoAdAvailable video AD is available to play. Boolean.
 * @param placementId placement ID where the AD is available.
 */
-(void)headsappVideoAdPlayableChanged:(BOOL)isVideoAdAvailable forPlacementID:(NSString * _Nonnull) placementId {
    NSLog(@"-(void)headsappVideoAdPlayableChanged:%d forPlacementID:%@", isVideoAdAvailable, placementId);
    NSLog(@"Advertiser name: %@", [[HeadsAppSDK sharedSDK] getAdvertiserNameForPlacementID:placementId]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAdAvailabilityChangedNotification object:nil
                                                      userInfo:@{kPlacementIDKey: placementId, kAdAvailableKey : @(isVideoAdAvailable)}];
}

#pragma mark Full Screen ADs (interstitial and video ADs)

/** The SDK is about to show a full screen AD
 *
 * Called when the SDK is about to play a full screen ad (video or interstitial).  The override of this method is a good place to pause gameplay, sound effects, animations, etc
 */
- (void)headsappSDKWillShowFullScreenAd {
    NSLog(@"- (void)headsappSDKWillShowFullScreenAd");
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
- (void)headsappSDKWillCloseAdWithViewInfo:(NSDictionary* _Nonnull)viewInfo willPresentProductSheet:(BOOL)present {
    NSLog(@"- (void)headsappSDKWillCloseAdWithViewInfo:%@ willPresentProductSheet:%d", viewInfo, present);
    [[NSNotificationCenter defaultCenter] postNotificationName:kAdVideoClosedNotification object:nil userInfo:viewInfo];
}

/** Product sheet is about to close – returning to the App
 *
 * Will fire in the case when a user had opted to download the advertised app, and is now closing out of the in-app app store.
 * This event can be used to resume animations, sound effects, etc. when returning to the app.
 */
- (void)headsappSDKWillCloseProductSheet {
    NSLog(@"- (void)headsappSDKWillCloseProductSheet");
}

/** Full screen AD (Interstitial or Video) failed to load with error
 *
 * Called when the SDK has failed to load an AD. This is used to hide the placement for better UX behavior.
 * @param placementId placement ID where the AD failed to load.
 * @param error The error object with more information about why the fullscreen AD failed to load
 */
-(void)headsappSDKFullscreenAdLoadFailForPlacementID:(NSString * _Nonnull)placementId withError:(NSError * _Nullable)error {
    NSLog(@"- (void)headsappSDKFullscreenAdLoadFailForPlacementID:%@ withError:%@", placementId, error);
    NSLog(@"Advertiser name: %@", [[HeadsAppSDK sharedSDK] getAdvertiserNameForPlacementID:placementId]);
}

#pragma mark All types of ADs

/** AD finished loading
 *
 * If the AD type of the placement is video, this callback is called when the SDK has successfully received an Video AD and it's ready to be displayed by the app. If the placement AD type is banner, offer wall or interstitial, this callback is called when the placement is initialized and ready to be requested for ADs. The developer will use this delegate in order to request display of ADs.
 * This is to avoid the display of a blank ad placement.
 *
 * @param placementId placement ID where the AD loaded.
 */
- (void)headsappSDKAdReadyForViewForPlacementID:(NSString * _Nonnull)placementId {
    NSLog(@"- (void)headsappSDKAdReadyForViewForPlacementID:%@", placementId);
    NSLog(@"Advertiser name: %@", [[HeadsAppSDK sharedSDK] getAdvertiserNameForPlacementID:placementId]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kAdAvailabilityChangedNotification object:nil
                                                      userInfo:@{kPlacementIDKey: placementId, kAdAvailableKey : @(YES)}];
}

/** AD will be displayed
 *
 * Called when the SDK is about to display the AD
 * @param placementId placement ID where the AD is available for.
 */
- (void)headsappSDKAdWillDisplayForPlacementID:(NSString * _Nonnull)placementId{
    NSLog(@"- (void)headsappSDKAdWillDisplayForPlacementID:%@", placementId);
    NSLog(@"Advertiser name: %@", [[HeadsAppSDK sharedSDK] getAdvertiserNameForPlacementID:placementId]);
}

/** AD failed to be received
 *
 * Called when the SDK has failed to load. This is used to hide the placement for better UX behavior.
 * @param placementId placement ID where the AD failed for.
 */
-(void)headsappSDKAdFailedToReceiveForPlacementID:(NSString * _Nonnull)placementId {
    NSLog(@"-(void)headsappSDKAdFailedToReceiveForPlacementID:%@", placementId);
    NSLog(@"Advertiser name: %@", [[HeadsAppSDK sharedSDK] getAdvertiserNameForPlacementID:placementId]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAdAvailabilityChangedNotification object:nil
                                                      userInfo:@{kPlacementIDKey: placementId, kAdAvailableKey : @([[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:placementId])}];
}

@end
