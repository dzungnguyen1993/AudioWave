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
    
    struct Messages {
        static let libraryAuthorizeFailedTitle = "No access to media library"
        static let libraryAuthorizeFailedMsg = "You can grant access to AudioWave from settings"
        static let importAudioFailedTitle = "Error"
        static let importAudioFailedMsg = "There's an error when render this audio file!"
    }
    
    static let btnPlayTagPause = 0
    static let btnPlayTagPlaying = 1
    static let startRenderNotification = "StartRender"
    static let endRenderNotification = "EndRender"
    static let maxSpeed: Float = 1.5
    static let minSpeed: Float = 0.5
    static let modifySpeedStep: Float = 0.1

}
