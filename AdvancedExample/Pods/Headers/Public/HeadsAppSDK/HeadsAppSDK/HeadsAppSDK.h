//
//  HeadsAppSDK.h
//  HeadsAppSDK
//
//  Created by HeadsApp on 8/26/15.
//  Copyright (c) 2015 HeadsApp. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for HeadsAppSDK.
FOUNDATION_EXPORT double HeadsAppSDKVersionNumber;

//! Project version string for HeadsAppSDK.
FOUNDATION_EXPORT const unsigned char HeadsAppSDKVersionString[];

@protocol Ad;

/** Banner ADs position on the screen enum.
 *
 */
typedef NS_ENUM(NSUInteger, BannerAdsPosition) {
    /** The banner view will be displayed at the top part of the screen in the current orientation of the screen */
    kBannerAdsPositionTop = 0,
    /** The banner view will be displayed at the left part of the screen in the current orientation of the screen */
    kBannerAdsPositionLeft,
    /** The banner view will be displayed at the right part of the screen in the current orientation of the screen */
    kBannerAdsPositionRight,
    /** The banner view will be displayed at the bottom part of the screen in the current orientation of the screen */
    kBannerAdsPositionBottom
};

/** Banner AD position key. Value must be NSNumber with the `BannerAdsPosition` enum. */
extern NSString * _Nonnull const HeadsAppPlayAdOptionKeyBannerPostition;

/** Fullscreen AD orientation key. Value must be NSNumber with the UIInterfaceOrientationMask. For Vungle this is the VunglePlayAdOptionKeyOrientations key. */
extern NSString * _Nonnull const HeadsAppPlayAdOptionKeyOrientations;

/** User identifier
 * If the AD was defined as rewarded and a server to server interface was defined this is the value identifying the user. For the Vungle provider this is the VunglePlayAdOptionKeyUser.
 */
extern NSString * _Nonnull const HeadsAppPlayAdOptionKeyUser;

/** Key in the viewInfo object received from the (headsappSDKWillCloseAdWithViewInfo:willPresentProductSheet:) method in the HeadsAppSDKDelegate. 
 * If value is NSNumber YES the AD finished playing video. If NO the AD is closed before the video finished playing.
 */
extern NSString * _Nonnull const HeadsAppVideoAdFinishedKey;

/** Key in the viewInfo object received from the (headsappSDKWillCloseAdWithViewInfo:willPresentProductSheet:) method in the HeadsAppSDKDelegate. 
 * The value is NSDictionary object containing the reward details and other provider info for the closed AD
 */
extern NSString * _Nonnull const HeadsAppAdProviderInfoKey;

/** Key in the viewInfo object received from the (headsappSDKWillCloseAdWithViewInfo:willPresentProductSheet:) method in the HeadsAppSDKDelegate.
 * The value is NSString wiht the placement ID of the AD that is closing.
 */
extern NSString * _Nonnull const HeadsAppPlayAdOptionKeyPlacementID;

/** AdColony AD network specific key returned in the viewInfo of the (headsappSDKWillCloseAdWithViewInfo:willPresentProductSheet:) method in the HeadsAppSDKDelegate. */
extern NSString * _Nonnull const HeadsAppPlayAdOptionAdColonyCurrencyName;

/** AdColony AD network specific key returned in the viewInfo of the (headsappSDKWillCloseAdWithViewInfo:willPresentProductSheet:) method in the HeadsAppSDKDelegate. */
extern NSString * _Nonnull const HeadsAppPlayAdOptionAdColonyCurrencyAmount;


#pragma mark - HeadsAppSDKDelegate protocol

/** HeadsAppSDKDelegate protocol which allows apps to receive asynchronous callbacks for certain SDK events. 
 *  The delegate implementing this protocol is passed to the HeadsAppSDK singleton using `-[HeadsAppSDK startWithAppId:delegate:]`
 */
@protocol HeadsAppSDKDelegate <NSObject>
@optional

#pragma mark Video ADs related methods

/** Video AD availability to play
 * 
 * Called when the SDK has changed video ad availability status to available or not available. If an AD is available for a placement the App can immediately display it.
 *
 * @param isVideoAdAvailable video AD is available to play. Boolean.
 * @param placementId placement ID where the AD is available.
 */
-(void)headsappVideoAdPlayableChanged:(BOOL)isVideoAdAvailable forPlacementID:(NSString * _Nonnull) placementId;


#pragma mark Full Screen ADs (interstitial and video ADs)

/** The SDK is about to show a full screen AD
 *
 * Called when the SDK is about to play a full screen ad (video or interstitial).  The override of this method is a good place to pause gameplay, sound effects, animations, etc
 */
- (void)headsappSDKWillShowFullScreenAd;


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
- (void)headsappSDKWillCloseAdWithViewInfo:(NSDictionary* _Nonnull)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet;

/** Product sheet is about to close – returning to the App
 *
 * Will fire in the case when a user had opted to download the advertised app, and is now closing out of the in-app app store. 
 * This event can be used to resume animations, sound effects, etc. when returning to the app.
 */
- (void)headsappSDKWillCloseProductSheet;

/** Full screen AD (Interstitial or Video) failed to load with error
 *
 * Called when the SDK has failed to load an AD. This is used to hide the placement for better UX behavior.
 * @param placementId placement ID where the AD failed to load.
 * @param error The error object with more information about why the fullscreen AD failed to load
 */
-(void)headsappSDKFullscreenAdLoadFailForPlacementID:(NSString * _Nonnull)placementId withError:(NSError * _Nullable)error;

#pragma mark All types of ADs

/** AD finished loading
 *
 * If the AD type of the placement is video, this callback is called when the SDK has successfully received an Video AD and it's ready to be displayed by the app. If the placement AD type is banner, offer wall or interstitial, this callback is called when the placement is initialized and ready to be requested for ADs. The developer will use this delegate in order to request display of ADs.
 * This is to avoid the display of a blank ad placement.
 *
 * @param placementId placement ID where the AD loaded.
 */
- (void)headsappSDKAdReadyForViewForPlacementID:(NSString * _Nonnull)placementId;

/** AD will be displayed
 *
 * Called when the SDK is about to display the AD
 * @param placementId placement ID where the AD is available for.
 */
- (void)headsappSDKAdWillDisplayForPlacementID:(NSString * _Nonnull)placementId;

/** AD failed to be received
 *
 * Called when the SDK has failed to load. This is used to hide the placement for better UX behavior.
 * @param placementId placement ID where the AD failed for.
 */
-(void)headsappSDKAdFailedToReceiveForPlacementID:(NSString * _Nonnull)placementId;

@end

#pragma mark - HeadsAppSDK interface

/** HeadsAppSDK singelton
 */
@interface HeadsAppSDK : NSObject

#pragma mark Initializing the SDK

/** Assignable property following the HeadsAppSDKDelegate protocol which allows apps to receive asynchronous callbacks for certain SDK events */
@property (atomic, weak, nullable) NSObject <HeadsAppSDKDelegate> *delegate;

/** Convinience singleton instance. Note that to complete initialization you should start preparing ADs with `startWithAppId:delegate:` */
+ (nullable instancetype)sharedSDK;

/** Configures HeadsAppSDK instance for your app ID `appId` and starts preparing ADs.
 *
 * @param appId Your HeadsApp app ID
 * @param delegate `HeadsAppSDKDelegate` delegate instance which will receive asynchronous callbacks for various SDK events.
 */
- (void)startWithAppId:(NSString * _Nonnull)appId delegate:(id<HeadsAppSDKDelegate> _Nullable)delegate;

#pragma mark Video AD playable

/** Is AD playable for placement ID `placementID`.
 *
 * Use this method to check whether AD is ready to be requested for placement with ID `placementID`.
 * @param placementID Non null ID of the placement which will be checked whether ADs are ready to be played.
 * @returns Returns YES if the AD type is not video for the placement with ID 'placementID' and if the provider is initialized. Returns YES if the AD type is video and there's a cached video AD ready to be displayed for the placement with ID 'placementID'. Returns NO if the video AD is not ready to be displayed for the placement. Returns NO if the Provider have failed to initialize.
 */
- (BOOL)isAdPlayableForPlacementID:(NSString * _Nonnull)placementID;

#pragma mark Play ADs

/** The playAdForPlacementID method on the HeadsAppSDK singleton can accept a dictionary parameter allowing an app to customize an individual ad experience.
 *
 * @param placementID The ID of the placement which will be used to determine the AD provider when displaying the fullscreen AD
 * @param vc The `UIViewController` instance which will be used as parent when displaying the full screen AD
 * @param options Any valid key-value pairs included in the dictionary parameter will override the default value for the setting. All keys are optional to add to the dictionary.
 * The settings included in the dictionary parameter will only affect a single playAd call.
 * Supported keys are HeadsAppPlayAdOptionKeyOrientations and HeadsAppPlayAdOptionKeyUser
 */
- (void)playAdForPlacementID:(NSString * _Nonnull)placementID fromViewController:(UIViewController * _Nonnull)vc withOptions:(NSDictionary * _Nullable)options;

/** Same as `playAdForPlacementID:fromViewController:withOptions:` if the options argument is set to nil
 *
 * @param placementID The ID of the placement which will be used to determine the AD provider when displaying the fullscreen AD
 * @param vc The `UIViewController` instance which will be used as parent when displaying the full screen AD
 */
- (void)playAdForPlacementID:(NSString * _Nonnull)placementID fromViewController:(UIViewController * _Nonnull)vc;

#pragma mark Audio muted state

/** Boolean value. Controls whether presented ads will start in a muted state or not. If muted video ADs will play the video without sound
 */
@property (nonatomic, assign) BOOL muted;

#pragma mark Advertiser name

/** Advertiser name for a specific placement
 *
 * @param placementID The placement ID of the placement
 * @returns Returns the name of the advertiser for the placemnt with placement ID 'placementID' or nil if no provider can be initialized for the placement.
 */
-(NSString * _Nullable)getAdvertiserNameForPlacementID:(NSString * _Nonnull)placementID;

@end

