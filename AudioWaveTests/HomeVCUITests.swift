//
//  HomeVCUITests.swift
//  AudioWaveTests
//
//  Created by Thanh-Dung Nguyen on 12/3/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import Quick
import Nimble

@testable import AudioWave

class HomeVCUITests: QuickSpec {
    override func spec() {
        var homeVC: HomeVC!
        
        describe("Test HomeVC") {
            beforeEach {
                let window = UIWindow(frame: UIScreen.main.bounds)
                homeVC = HomeVC(nibName: Constants.ViewControllers.homeVC, bundle: nil)
                window.rootViewController = homeVC
                window.makeKeyAndVisible()
            }
            
            context("When view is loaded") {
                it("Content size of scrollView should be zero") {
                    print("")
                    expect(homeVC.waveScrollView.scrollView.contentSize.width).to(equal(0))
                }
            }
            
            context("When view is loaded") {
                it("Marker should be at the beginning point") {
                    print("")
                    expect(homeVC.constraintSmallMarkerLeading.constant).to(equal(0))
                }
            }
            
            context("When view is loaded") {
                it("Play button should be of size (40,40)") {
                    print("")
                    expect(homeVC.playBtn.frame.size.width).to(equal(40))
                    expect(homeVC.playBtn.frame.size.height).to(equal(40))
                }
            }
        }
    }
}
