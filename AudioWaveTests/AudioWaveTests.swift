//
//  AudioWaveTests.swift
//  AudioWaveTests
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation
import Quick
import Nimble
import AVFoundation
import RxSwift
import NSObject_Rx

@testable import AudioWave

// Testing the vehicle
class AudioWaveTests: QuickSpec {
    
    override func spec() {
        
        describe("Test extract info from audio file with wav file") {
            
            context("After extract and downsample") {
                let url = Bundle.main.url(forResource: "test", withExtension: "wav")

                it("Number of points to draw should be equal") {
                    let render = AudioRender()
                    
                    render.render(url: url!)?
                        .subscribe(onNext: { (pointsToDraw) in
                            expect(pointsToDraw.count).to(equal(31))
                        }).disposed(by: self.rx_disposeBag)
                }
            }
        }
        
        describe("Test extract info from audio file with mp3 file") {
            
            context("After extract and downsample") {
                let url = Bundle.main.url(forResource: "test", withExtension: "mp3")
                
                it("Number of points to draw should be equal") {
                    let render = AudioRender()
                    
                    render.render(url: url!)?
                        .subscribe(onNext: { (pointsToDraw) in
                            expect(pointsToDraw.count).to(equal(3345))
                        }).disposed(by: self.rx_disposeBag)
                }
            }
        }
        
        describe("Test extract info from audio file with m4a file") {
            
            context("After extract and downsample") {
                let url = Bundle.main.url(forResource: "test", withExtension: "m4a")
                
                it("Number of points to draw should be equal") {
                    let render = AudioRender()
                    
                    render.render(url: url!)?
                        .subscribe(onNext: { (pointsToDraw) in
                            expect(pointsToDraw.count).to(equal(37))
                        }).disposed(by: self.rx_disposeBag)
                }
            }
        }
    }
}
