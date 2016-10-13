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
        
        videoAdButton1.isEnabled = false;
        bannerAdButton1.isEnabled = false;
        interstitialAdButton1.isEnabled = false;
        vungleRewardedVideoAdButton.isEnabled = false;
        adColonyRewardedVideoAdButton.isEnabled = false;
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.videoAdAvailabilityChanged(_:)), name: NSNotification.Name(rawValue: Constants.kAdAvailabilityChangedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.fullscreenAdClosedWithProviderInfo(_:))    , name: NSNotification.Name(rawValue: Constants.kAdVideoClosedNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func requestBannerAd1(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: BANNER_PLACEMENT_ID1, from: self)
    }
    
    @IBAction func requestVideoAd1(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: VIDEO_PLACEMENT_ID1, from: self)
    }
    
    @IBAction func requestVungleRewardedVideoAd(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: VUNGLE_REWARDED_VIDEO_PLACEMENT_ID, from: self)
    }
    
    @IBAction func requestAdColonyRewardedVideoAd(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID, from: self)
    }
    
    @IBAction func requestInterstitialAd1(_ sender: UIButton) {
        HeadsAppSDK.shared()?.playAd(forPlacementID: INTERSTITIAL_PLACEMENT_ID1, from: self)
    }

    //MARK: - Video Ads buttons
    
    func videoAdAvailabilityChanged(_ notification : Notification) {
        if let info = (notification as NSNotification).userInfo {
            if let placementId = info[Constants.kPlacementIDKey] as? String {
                if let availableNumber = info[Constants.kAdAvailableKey] as? Bool {
                    if (placementId == VIDEO_PLACEMENT_ID1) {
                        self.videoAdButton1.isEnabled = availableNumber;
                    } else if (placementId == BANNER_PLACEMENT_ID1) {
                        self.bannerAdButton1.isEnabled = availableNumber;
                    } else if (placementId == INTERSTITIAL_PLACEMENT_ID1) {
                        self.interstitialAdButton1.isEnabled = availableNumber;
                    } else if (placementId == VUNGLE_REWARDED_VIDEO_PLACEMENT_ID) {
                        self.vungleRewardedVideoAdButton.isEnabled = availableNumber;
                    } else if (placementId == ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID) {
                        self.adColonyRewardedVideoAdButton.isEnabled = availableNumber;
                    }
                }
            }
        }
    }
    
   //MARK: - Ad closed and rewarded video details

    func fullscreenAdClosedWithProviderInfo(_ notification: Notification) {
        if let info = (notification as NSNotification).userInfo {
            let rewardedInfo = info[HeadsAppAdProviderInfoKey]
        
            //First check whether the video was fully played
            if let finished = info[HeadsAppVideoAdFinishedKey] as? Bool {
                if finished == true {
                    if let placementId = info[HeadsAppPlayAdOptionKeyPlacementID] as? String {
                        //If last presented AD is Vungle rewarded video
                        if placementId == VUNGLE_REWARDED_VIDEO_PLACEMENT_ID {
                            //Display reward to the user
                            let alert = UIAlertController(title: "You've been rewarded", message: "You've been rewarded for playing the video", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                                alert.dismiss(animated: true, completion: {
                                });
                            })
                            alert.addAction(okAction);
                            self.present(alert, animated: true, completion: {
                            });
                        }
                        //If last presented AD is AdColony rewarded video check the reward details for the HeadsAppPlayAdOptionAdColonyCurrencyName and HeadsAppPlayAdOptionAdColonyCurrencyAmount keys
                        else if placementId == ADCOLONY_REWARDED_VIDEO_PLACEMENT_ID {
                            if rewardedInfo != nil {
                                print("Additional reward info: \(rewardedInfo)");
                                
                                let coins = info[HeadsAppPlayAdOptionAdColonyCurrencyAmount]
                                if let currency : String = info[HeadsAppPlayAdOptionAdColonyCurrencyName] as? String {
                                    var message = "";
                                    if (coins != nil) {
                                        if currency.characters.count > 0 {
                                            message = "You've been rewarded with \(coins!) \(currency) for playing the video"
                                        } else {
                                            message = "You've been rewarded with \(coins!) for playing the video"
                                        }
                                    }
                                    let alert = UIAlertController(title: "You've been rewarded", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                                        alert.dismiss(animated: true, completion: {
                                        });
                                    })
                                    alert.addAction(okAction);
                                    self.present(alert, animated: true, completion: {
                                    })
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
