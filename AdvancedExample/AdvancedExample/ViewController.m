//
//  ViewController.m
//  HeadsAppSampleApp
//
//  Created by HeadsApp on 9/2/15.
//  Copyright (c) 2015 HeadsApp. All rights reserved.
//

#import "ViewController.h"
#import <HeadsAppSDK/HeadsAppSDK.h>
#import "Constants.h"

//Fullscreen Video ADs placement IDs

#define VIDEO_PLACEMENT_ID1 @"VIDEO_PLACEMENT_ID1"

//Fullscreen Vungle Rewarded Video ADs placement IDs
#define VUNGLE_REWARDED_VIDEO_PLACEMENT_ID @"VUNGLE_REWARDED_VIDEO_PLACEMENT_ID"

//Fullscreen AdColony Rewarded Video ADs placement IDs
#define ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID @"ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID"

//Other Fullscreen ADs placement IDs
#define INTERSTITIAL_PLACEMENT_ID1 @"INTERSTITIAL_PLACEMENT_ID1"

//Banner ADs placement IDs
#define BANNER_PLACEMENT_ID1 @"BANNER_PLACEMENT_ID1"

@interface ViewController ()

//banner AD buttons
@property (weak, nonatomic) IBOutlet UIButton *bannerAdButton1;

//video AD buttons
@property (weak, nonatomic) IBOutlet UIButton *videoAdButton1;
@property (weak, nonatomic) IBOutlet UIButton *vungleRewardedVideoAdButton;
@property (weak, nonatomic) IBOutlet UIButton *adColonyRewardedVideoAdButton;

//other fullscreen AD buttons
@property (weak, nonatomic) IBOutlet UIButton *interstitialAdButton1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.videoAdButton1 setEnabled:NO];
    [self.bannerAdButton1 setEnabled:NO];
    [self.interstitialAdButton1 setEnabled:NO];
    [self.vungleRewardedVideoAdButton setEnabled:NO];
    [self.adColonyRewardedVideoAdButton setEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoAdAvailabilityChanged:) name:kAdAvailabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullscreenAdClosedWithProviderInfo:) name:kAdVideoClosedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.videoAdButton1 setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:VIDEO_PLACEMENT_ID1]];
    [self.bannerAdButton1 setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:BANNER_PLACEMENT_ID1]];
    [self.interstitialAdButton1 setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:INTERSTITIAL_PLACEMENT_ID1]];
    [self.vungleRewardedVideoAdButton setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:VUNGLE_REWARDED_VIDEO_PLACEMENT_ID]];
    [self.adColonyRewardedVideoAdButton setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID]];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)requestBannerAd1:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:BANNER_PLACEMENT_ID1 fromViewController:self];
}

- (IBAction)requestVideoAd1:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:VIDEO_PLACEMENT_ID1 fromViewController:self];
}

- (IBAction)requestVungleRewardedVideoAd:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:VUNGLE_REWARDED_VIDEO_PLACEMENT_ID fromViewController:self];
}

- (IBAction)requestAdColonyRewardedVideoAd:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID fromViewController:self];
}

- (IBAction)requestInterstitialAd1:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:INTERSTITIAL_PLACEMENT_ID1 fromViewController:self];
}

#pragma mark - Video Ads buttons

- (void)videoAdAvailabilityChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *placementId = [info objectForKey:kPlacementIDKey];
        BOOL availableNumber = [[info objectForKey:kAdAvailableKey] boolValue];
        
        if ([placementId isEqualToString:VIDEO_PLACEMENT_ID1]) {
            [self.videoAdButton1 setEnabled:availableNumber];
        } else if ([placementId isEqualToString:BANNER_PLACEMENT_ID1]) {
            [self.bannerAdButton1 setEnabled:availableNumber];
        } else if ([placementId isEqualToString:INTERSTITIAL_PLACEMENT_ID1]) {
            [self.interstitialAdButton1 setEnabled:availableNumber];
        } else if ([placementId isEqualToString:VUNGLE_REWARDED_VIDEO_PLACEMENT_ID]) {
            [self.vungleRewardedVideoAdButton setEnabled:availableNumber];
        } else if ([placementId isEqualToString:ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID]) {
            [self.adColonyRewardedVideoAdButton setEnabled:availableNumber];
        }
    }
}

#pragma mark - Ad closed and rewarded video details

- (void)fullscreenAdClosedWithProviderInfo:(NSNotification *)notification {
    NSDictionary *viewInfo = [notification userInfo];
    
    //First check whether the video was fully played
    if (viewInfo != nil && [[viewInfo objectForKey:HeadsAppVideoAdFinishedKey] boolValue] == YES) {
        //If last presented AD is Vungle rewarded video
        if ([[viewInfo objectForKey:HeadsAppPlayAdOptionKeyPlacementID] isEqualToString:VUNGLE_REWARDED_VIDEO_PLACEMENT_ID]) {
            //Display reward to the user
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You've been rewarded" message:@"You've been rewarded for playing the video" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:^{
                }];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        //If last presented AD is AdColony rewarded video check the reward details for the HeadsAppPlayAdOptionAdColonyCurrencyName and HeadsAppPlayAdOptionAdColonyCurrencyAmount keys
        else if ([[viewInfo objectForKey:HeadsAppPlayAdOptionKeyPlacementID] isEqualToString:ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID]) {
            NSDictionary *rewardedInfo = [viewInfo objectForKey:HeadsAppAdProviderInfoKey];
            NSLog(@"Additional reward info: %@", rewardedInfo);

            NSInteger coins = [[viewInfo objectForKey:HeadsAppPlayAdOptionAdColonyCurrencyAmount] integerValue];
            NSString *currency = [viewInfo objectForKey:HeadsAppPlayAdOptionAdColonyCurrencyName];
            
            NSString *message = nil;
            if ([currency isKindOfClass:[NSString class]] && [currency length] > 0) {
                message = [NSString stringWithFormat:@"You've been rewarded with %d %@ for playing the video", (int)coins, currency];
            } else {
                message = [NSString stringWithFormat:@"You've been rewarded with %d for playing the video", (int)coins];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You've been rewarded" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
    }
}

@end
