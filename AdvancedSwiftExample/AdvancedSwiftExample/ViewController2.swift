//
//  ViewController2.swift
//  AdvancedSwiftExample
//
//  Copyright © 2016 HeadsApp. All rights reserved.
//

import UIKit
import HeadsAppSDK

//Fullscreen Video ADs placement IDs
let VIDEO_PLACEMENT_ID2 = "VIDEO_PLACEMENT_ID2"

//Other Fullscreen ADs placement IDs
let INTERSTITIAL_PLACEMENT_ID2 = "INTERSTITIAL_PLACEMENT_ID2"

//Banner ADs placement IDs
let BANNER_PLACEMENT_ID2 = "BANNER_PLACEMENT_ID2"

class ViewController2: UIViewController {
    
    //banner AD buttons
    @IBOutlet var bannerAdButton2: UIButton!
    
    //video AD buttons
    @IBOutlet var videoAdButton2: UIButton!
    
    //other fullscreen AD buttons
    @IBOutlet var interstitialAdButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.videoAdButton2.enabled = false
        self.bannerAdButton2.enabled = false
        self.interstitialAdButton2.enabled = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoAdAvailabilityChanged:", name: Constants.kAdAvailabilityChangedNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let sdk = HeadsAppSDK.sharedSDK() {
            self.videoAdButton2.enabled = sdk.isAdPlayableForPlacementID(VIDEO_PLACEMENT_ID2)
            self.bannerAdButton2.enabled = sdk.isAdPlayableForPlacementID(BANNER_PLACEMENT_ID2)
            self.interstitialAdButton2.enabled = sdk.isAdPlayableForPlacementID(INTERSTITIAL_PLACEMENT_ID2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func requestBannerAd2(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(BANNER_PLACEMENT_ID2, fromViewController: self)
    }
    
    @IBAction func requestVideoAd2(sender: UIButton) {
        let options : Dictionary = [HeadsAppPlayAdOptionKeyOrientations: UIInterfaceOrientation.Portrait.rawValue];
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(VIDEO_PLACEMENT_ID2, fromViewController: self, withOptions:options)
    }

    @IBAction func requestInterstitialAd2(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(INTERSTITIAL_PLACEMENT_ID2, fromViewController: self)
    }
    
    //MARK: - Video Ads buttons
    
    func videoAdAvailabilityChanged(notification: NSNotification) {
        if let info = notification.userInfo {
            if let availableNumber = info[Constants.kAdAvailableKey] as? Bool {
                if let placementId = info[Constants.kPlacementIDKey] as? String {
                    if (placementId == VIDEO_PLACEMENT_ID2) {
                        self.videoAdButton2.enabled = availableNumber;
                    } else if (placementId == BANNER_PLACEMENT_ID2) {
                        self.bannerAdButton2.enabled = availableNumber;
                    } else if (placementId == INTERSTITIAL_PLACEMENT_ID2) {
                        self.interstitialAdButton2.enabled = availableNumber;
                    }
                }
            }
        }
    }
}

