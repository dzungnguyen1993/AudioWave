//
//  Constants.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class Constants: NSObject {
    struct ViewControllers {
        static let homeVC = "HomeVC"
    }
    
    struct WaveForm {
        static let lineWidth: CGFloat = 1.0
        static let spacing: CGFloat = 1.0
        static let multiplier: CGFloat = 20.0
        static let waveColor: Int = 0x7E8999
        static let samplePerPixel: CGFloat = 200.0
    }
    
    static let btnPlayTagPause = 0
    static let btnPlayTagPlaying = 1
}
