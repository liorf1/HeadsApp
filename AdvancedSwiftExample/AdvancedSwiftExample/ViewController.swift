//
//  ViewController.swift
//  AdvancedSwiftExample
//
//  Copyright © 2016 HeadsApp. All rights reserved.
//

import UIKit
import HeadsAppSDK

//Fullscreen Video ADs placement IDs 
let VIDEO_PLACEMENT_ID1 = "VIDEO_PLACEMENT_ID1"

//Fullscreen Vungle Rewarded Video ADs placement IDs
let VUNGLE_REWARDED_VIDEO_PLACEMENT_ID = "VUNGLE_REWARDED_VIDEO_PLACEMENT_ID"

//Fullscreen AdColony Rewarded Video ADs placement IDs
let ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID = "ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID"

//Other Fullscreen ADs placement IDs
let INTERSTITIAL_PLACEMENT_ID1 = "INTERSTITIAL_PLACEMENT_ID1"

//Banner ADs placement IDs
let BANNER_PLACEMENT_ID1 = "BANNER_PLACEMENT_ID1"


class ViewController: UIViewController {
    
    //banner AD buttons
    @IBOutlet var bannerAdButton1 : UIButton!
    
    //video AD buttons
    @IBOutlet var videoAdButton1 : UIButton!
    @IBOutlet var vungleRewardedVideoAdButton : UIButton!
    @IBOutlet var adColonyRewardedVideoAdButton : UIButton!
    
    //other fullscreen AD buttons
    @IBOutlet var interstitialAdButton1 : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        videoAdButton1.enabled = false;
        bannerAdButton1.enabled = false;
        interstitialAdButton1.enabled = false;
        vungleRewardedVideoAdButton.enabled = false;
        adColonyRewardedVideoAdButton.enabled = false;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoAdAvailabilityChanged:", name: Constants.kAdAvailabilityChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fullscreenAdClosedWithProviderInfo:"    , name: Constants.kAdVideoClosedNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    @IBAction func requestBannerAd1(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(BANNER_PLACEMENT_ID1, fromViewController: self)
    }
    
    @IBAction func requestVideoAd1(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(VIDEO_PLACEMENT_ID1, fromViewController: self)
    }
    
    @IBAction func requestVungleRewardedVideoAd(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(VUNGLE_REWARDED_VIDEO_PLACEMENT_ID, fromViewController: self)
    }
    
    @IBAction func requestAdColonyRewardedVideoAd(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID, fromViewController: self)
    }
    
    @IBAction func requestInterstitialAd1(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(INTERSTITIAL_PLACEMENT_ID1, fromViewController: self)
    }

    //MARK: - Video Ads buttons
    
    func videoAdAvailabilityChanged(notification : NSNotification) {
        if let info = notification.userInfo {
            if let placementId = info[Constants.kPlacementIDKey] as? String {
                if let availableNumber = info[Constants.kAdAvailableKey] as? Bool {
                    if (placementId == VIDEO_PLACEMENT_ID1) {
                        self.videoAdButton1.enabled = availableNumber;
                    } else if (placementId == BANNER_PLACEMENT_ID1) {
                        self.bannerAdButton1.enabled = availableNumber;
                    } else if (placementId == INTERSTITIAL_PLACEMENT_ID1) {
                        self.interstitialAdButton1.enabled = availableNumber;
                    } else if (placementId == VUNGLE_REWARDED_VIDEO_PLACEMENT_ID) {
                        self.vungleRewardedVideoAdButton.enabled = availableNumber;
                    } else if (placementId == ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID) {
                        self.adColonyRewardedVideoAdButton.enabled = availableNumber;
                    }
                }
            }
        }
    }
    
   //MARK: - Ad closed and rewarded video details

    func fullscreenAdClosedWithProviderInfo(notification: NSNotification) {
        if let info = notification.userInfo {
            let rewardedInfo = info[HeadsAppAdProviderInfoKey]
        
            //First check whether the video was fully played
            if let finished = info[HeadsAppVideoAdFinishedKey] as? Bool {
                if finished == true {
                    if let placementId = info[HeadsAppPlayAdOptionKeyPlacementID] as? String {
                        //If last presented AD is Vungle rewarded video
                        if placementId == VUNGLE_REWARDED_VIDEO_PLACEMENT_ID {
                            //Display reward to the user
                            let alert = UIAlertController(title: "You've been rewarded", message: "You've been rewarded for playing the video", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                                alert.dismissViewControllerAnimated(true, completion: {
                                });
                            })
                            alert.addAction(okAction);
                            self.presentViewController(alert, animated: true, completion: {
                            });
                        }
                        //If last presented AD is AdColony rewarded video check the reward details for the HeadsAppPlayAdOptionAdColonyCurrencyName and HeadsAppPlayAdOptionAdColonyCurrencyAmount keys
                        else if placementId == ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID {
                            if rewardedInfo != nil {
                                print("Additional reward info: \(rewardedInfo)");
                                
                                let coins = info[HeadsAppPlayAdOptionAdColonyCurrencyAmount]
                                let currency = info[HeadsAppPlayAdOptionAdColonyCurrencyName]
                                
                                var message = "";
                                if (coins != nil) {
                                    if currency != nil && currency!.length > 0 {
                                        message = "You've been rewarded with \(coins!) \(currency!) for playing the video"
                                    } else {
                                        message = "You've been rewarded with \(coins!) for playing the video"
                                    }
                                }
                                let alert = UIAlertController(title: "You've been rewarded", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                                    alert.dismissViewControllerAnimated(true, completion: {
                                    });
                                })
                                alert.addAction(okAction);
                                self.presentViewController(alert, animated: true, completion: {
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}
