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
        
        self.videoAdButton2.isEnabled = false
        self.bannerAdButton2.isEnabled = false
        self.interstitialAdButton2.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController2.videoAdAvailabilityChanged(_:)), name: NSNotification.Name(rawValue: Constants.kAdAvailabilityChangedNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let sdk = HeadsAppSDK.shared() {
            self.videoAdButton2.isEnabled = sdk.isAdPlayable(forPlacementID: VIDEO_PLACEMENT_ID2)
            self.bannerAdButton2.isEnabled = sdk.isAdPlayable(forPlacementID: BANNER_PLACEMENT_ID2)
            self.interstitialAdButton2.isEnabled = sdk.isAdPlayable(forPlacementID: INTERSTITIAL_PLACEMENT_ID2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func requestBannerAd2(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: BANNER_PLACEMENT_ID2, from: self)
    }
    
    @IBAction func requestVideoAd2(_ sender: UIButton) {
        let options : Dictionary = [HeadsAppPlayAdOptionKeyOrientations: UIInterfaceOrientation.portrait.rawValue];
        HeadsAppSDK.shared()?.playAd(forPlacementID: VIDEO_PLACEMENT_ID2, from: self, withOptions:options)
    }

    @IBAction func requestInterstitialAd2(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: INTERSTITIAL_PLACEMENT_ID2, from: self)
    }
    
    //MARK: - Video Ads buttons
    
    func videoAdAvailabilityChanged(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {
            if let availableNumber = info[Constants.kAdAvailableKey] as? Bool {
                if let placementId = info[Constants.kPlacementIDKey] as? String {
                    if (placementId == VIDEO_PLACEMENT_ID2) {
                        self.videoAdButton2.isEnabled = availableNumber;
                    } else if (placementId == BANNER_PLACEMENT_ID2) {
                        self.bannerAdButton2.isEnabled = availableNumber;
                    } else if (placementId == INTERSTITIAL_PLACEMENT_ID2) {
                        self.interstitialAdButton2.isEnabled = availableNumber;
                    }
                }
            }
        }
    }
}

