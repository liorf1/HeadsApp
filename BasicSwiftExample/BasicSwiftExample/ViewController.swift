//
//  ViewController.swift
//  BasicSwiftExample
//
//  Created by HeadsApp on 5/11/16.
//  Copyright © 2016 HeadsApp. All rights reserved.
//

import UIKit
import HeadsAppSDK

//Fullscreen Video ADs placement IDs 
let VIDEO_PLACEMENT_ID = "VIDEO_PLACEMENT_ID"

//Other Fullscreen ADs placement IDs
let INTERSTITIAL_PLACEMENT_ID = "INTERSTITIAL_PLACEMENT_ID"

//Banner ADs placement IDs 
let BANNER_PLACEMENT_ID = "BANNER_PLACEMENT_ID"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestBannerAd(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(BANNER_PLACEMENT_ID, fromViewController: self)
    }
    
    @IBAction func requestInterstitialAd(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(INTERSTITIAL_PLACEMENT_ID, fromViewController: self)
    }

    @IBAction func requestVideoAd(sender: UIButton) {
        HeadsAppSDK.sharedSDK()?.playAdForPlacementID(VIDEO_PLACEMENT_ID, fromViewController: self)
    }


}

