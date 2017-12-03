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

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    var audioUrl: URL!
    var player : AVAudioPlayer!
    var timer: Timer!
    let timePublisher = PublishSubject<Double>()
    let endPublisher = PublishSubject<Void>()
    
    init(url: URL) {
        super.init()
        self.audioUrl = url
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.enableRate = true
            player.numberOfLoops = 1
            player.prepareToPlay()
            player.delegate = self
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
    
    // increase speed
    func increaseSpeed() -> Float {
        player.rate = min(player.rate + Constants.modifySpeedStep, Constants.maxSpeed)
        
        return player.rate
    }
    
    // decrease speed
    func decreaseSpeed() -> Float {
        player.rate = max(player.rate - Constants.modifySpeedStep, Constants.minSpeed)
        
        return player.rate
    }
    
    // notify when finish playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer.invalidate()
        self.endPublisher.onNext(())
    }
    
    func seek(toPercentage percent: Double) {
        let duration = self.getDuration()
        
        let time = duration * percent
        
        self.player.currentTime = time
    }
}

