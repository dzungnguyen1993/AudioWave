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
        
        let globalScheduler = ConcurrentDispatchQueueScheduler(queue:
            DispatchQueue.global())
        
        // subscribe to render
        selectedUrlSubject
            .asObservable()
            .observeOn(globalScheduler)
            .subscribe(onNext: {[weak self] (url) in
                self?.render(withURL: url)
            }).disposed(by: self.rx_disposeBag)
        
        // player
        selectedUrlSubject
            .asObservable()
            .observeOn(globalScheduler)
            .subscribe(onNext: {[weak self] (url) in
                self?.createPlayer(fromUrl: url)
            }).disposed(by: self.rx_disposeBag)
    }
    
    // open picker
    func showImport(withType type: PickerType) {
        // open picker to pick audio file
        ImportManager.shared.openPicker(withType: type) { (url) in
            // if valid url
            if let song = url.toSongObject() {
                // notify when finish render
                let notificationName = Notification.Name(Constants.startRenderNotification)
                NotificationCenter.default.post(name: notificationName, object: nil)

                self.song = song
                
                // notify about new url
                self.selectedUrlSubject.onNext(url)
            } else {
                // show alert
                let rootViewController = Utility.getRootViewController()
                rootViewController?.alert(title: Constants.Messages.importAudioFailedTitle,
                                          text: Constants.Messages.importAudioFailedMsg)
                    .take(5.0, scheduler: MainScheduler.instance)
                    .subscribe(onDisposed: {
                        
                    })
                    .disposed(by: self.rx_disposeBag)
            }
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
