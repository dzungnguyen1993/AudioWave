//
//  AudioPlayer.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import AVFoundation
import RxSwift
import NSObject_Rx

class AudioPlayer: NSObject {
    var audioUrl: URL!
    var player : AVAudioPlayer!
    var timer: Timer!
    var timePublisher = PublishSubject<Double>()
    
    init(url: URL) {
        self.audioUrl = url
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.enableRate = true
            player.prepareToPlay()
        } catch {
            
        }
    }
    
    func play() {
        player.play()
        
        // start timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (timer) in
            self.timePublisher.onNext(self.player.currentTime)
        })
    }
    
    func pause() {
        player.pause()
        timer.invalidate()
    }
    
    func getDuration() -> Double {
        return player.duration
    }
    
    func increaseSpeed() -> Float {
        player.rate = min(player.rate + 0.1, 1.5)
        
        return player.rate
    }
    
    func decreaseSpeed() -> Float {
        player.rate = max(player.rate - 0.1, 0.5)
        
        return player.rate
    }
}

