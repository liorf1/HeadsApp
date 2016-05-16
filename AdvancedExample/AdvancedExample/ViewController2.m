//
//  ViewController.m
//  HeadsAppSampleApp
//
//  Copyright (c) 2015 HeadsApp. All rights reserved.
//

#import "ViewController2.h"
#import <HeadsAppSDK/HeadsAppSDK.h>
#import "Constants.h"

//Fullscreen Video ADs placement IDs
#define VIDEO_PLACEMENT_ID2 @"VIDEO_PLACEMENT_ID2"

//Other Fullscreen ADs placement IDs
#define INTERSTITIAL_PLACEMENT_ID2 @"INTERSTITIAL_PLACEMENT_ID2"

//Banner ADs placement IDs
#define BANNER_PLACEMENT_ID2 @"BANNER_PLACEMENT_ID2"

@interface ViewController2 ()

//banner AD buttons
@property (weak, nonatomic) IBOutlet UIButton *bannerAdButton2;

//video AD buttons
@property (weak, nonatomic) IBOutlet UIButton *videoAdButton2;

//other fullscreen AD buttons
@property (weak, nonatomic) IBOutlet UIButton *interstitialAdButton2;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.videoAdButton2 setEnabled:NO];
    [self.bannerAdButton2 setEnabled:NO];
    [self.interstitialAdButton2 setEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoAdAvailabilityChanged:) name:kAdAvailabilityChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.videoAdButton2 setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:VIDEO_PLACEMENT_ID2]];
    [self.bannerAdButton2 setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:BANNER_PLACEMENT_ID2]];
    [self.interstitialAdButton2 setEnabled:[[HeadsAppSDK sharedSDK] isAdPlayableForPlacementID:INTERSTITIAL_PLACEMENT_ID2]];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)requestBannerAd2:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:BANNER_PLACEMENT_ID2 fromViewController:self];
}

- (IBAction)requestVideoAd2:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:VIDEO_PLACEMENT_ID2 fromViewController:self withOptions:@{HeadsAppPlayAdOptionKeyOrientations: @(UIInterfaceOrientationPortrait)}];
}

- (IBAction)requestInterstitialAd2:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:INTERSTITIAL_PLACEMENT_ID2 fromViewController:self];
}

#pragma mark - Video Ads buttons

- (void)videoAdAvailabilityChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *placementId = [info objectForKey:kPlacementIDKey];
        BOOL availableNumber = [[info objectForKey:kAdAvailableKey] boolValue];
        
        if ([placementId isEqualToString:VIDEO_PLACEMENT_ID2]) {
            [self.videoAdButton2 setEnabled:availableNumber];
        } else if ([placementId isEqualToString:BANNER_PLACEMENT_ID2]) {
            [self.bannerAdButton2 setEnabled:availableNumber];
        } else if ([placementId isEqualToString:INTERSTITIAL_PLACEMENT_ID2]) {
            [self.interstitialAdButton2 setEnabled:availableNumber];
        }
    }
}

@end
