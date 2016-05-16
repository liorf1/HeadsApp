//
//  ViewController.m
//  HeadsAppSampleApp
//
//  Created by HeadsApp on 9/2/15.
//  Copyright (c) 2015 HeadsApp. All rights reserved.
//

#import "ViewController.h"
#import <HeadsAppSDK/HeadsAppSDK.h>

//Fullscreen Video ADs placement IDs
#define VIDEO_PLACEMENT_ID @"VIDEO_PLACEMENT_ID"

//Other Fullscreen ADs placement IDs
#define INTERSTITIAL_PLACEMENT_ID @"INTERSTITIAL_PLACEMENT_ID"

//Banner ADs placement IDs
#define BANNER_PLACEMENT_ID @"BANNER_PLACEMENT_ID"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)requestBannerAd:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:BANNER_PLACEMENT_ID fromViewController:self];
}

- (IBAction)requestInterstitialAd:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:INTERSTITIAL_PLACEMENT_ID fromViewController:self];
}

- (IBAction)requestVideoAd:(id)sender {
    [[HeadsAppSDK sharedSDK] playAdForPlacementID:VIDEO_PLACEMENT_ID fromViewController:self];
}

@end
