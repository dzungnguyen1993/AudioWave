//
//  HomeViewModel.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class HomeViewModel: NSObject {
    let selectedUrlSubject = PublishSubject<URL>()
    let drawPoints = PublishSubject<[CGFloat]>()
    var player: AudioPlayer!
    let timeAndPercentPublisher = PublishSubject<(Double, Double)>()
    let endPlayingPublisher = PublishSubject<Void>()
    
    var song: Song!
    
    init(rootController: UIViewController) {
        super.init()
        
        // subscribe to render
        selectedUrlSubject
            .asObservable()
            .subscribe(onNext: {[weak self] (url) in
                self?.render(withURL: url)
            }).disposed(by: self.rx_disposeBag)
        
        // player
        selectedUrlSubject
            .asObservable()
            .subscribe(onNext: {[weak self] (url) in
                self?.createPlayer(fromUrl: url)
            }).disposed(by: self.rx_disposeBag)
    }
    
    // open picker
    func showImport(withType type: PickerType) {
        // open picker to pick audio file
        ImportManager.shared.openPicker(withType: type) { (url) in
            // save current song
            self.song = url.toSongObject()
            // notify about new url
            self.selectedUrlSubject.onNext(url)
        }
    }
    
    // render audio
    func render(withURL url: URL) {
        // render here
        let render = AudioRender()
        
        render.render(url: url)?
            .subscribe(onNext: { (pointsToDraw) in
                self.drawPoints.onNext(pointsToDraw)
            }).disposed(by: rx_disposeBag)
    }
    
    // increase speed
    func increaseSpeed() -> String {
        let rate = player.increaseSpeed()
        
        return "\(rate)x"
    }
    
    // decrease speed
    func decreaseSpeed() -> String {
        let rate = player.decreaseSpeed()
        
        return "\(rate)x"
    }
}

extension HomeViewModel {
    func didPlay(toTime time: Double) {
        let duration = player.getDuration()
        let timeLeft = duration - time
        
        let percent = time / duration
        
        // notify about time and play percentage
        timeAndPercentPublisher.onNext((timeLeft, percent))
    }
    
    func createPlayer(fromUrl url: URL) {
        player = AudioPlayer(url: url)
        player.timePublisher.asObservable().subscribe(onNext: {[weak self] (time) in
            self?.didPlay(toTime: time)
        }).disposed(by: rx_disposeBag)
        
        player.endPublisher.asObservable().subscribe(onNext: {[weak self] in
            self?.didFinishPlaying()
        }).disposed(by: rx_disposeBag)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func didFinishPlaying() {
        self.endPlayingPublisher.onNext(())
    }
}
