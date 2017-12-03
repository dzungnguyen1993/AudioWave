//
//  HomeVC.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import RxCocoa
import NVActivityIndicatorView

class HomeVC: UIViewController {

    @IBOutlet weak var importedImageView: UIImageView!
    @IBOutlet weak var importLb: UILabel!
    @IBOutlet weak var songLb: UILabel!
    @IBOutlet weak var artistLb: UILabel!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var speedLb: UILabel!
    @IBOutlet weak var waveScrollView: WaveScrollView!
    @IBOutlet weak var bottomWaveView: WaveFormView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    
    @IBOutlet weak var constraintSmallMarkerLeading: NSLayoutConstraint!
    
    lazy var viewModel = HomeViewModel(rootController: self)
    
    let stopTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
        addActions()
        subscribeToViewModel()
        
        // add observer to animate render
        NotificationCenter.default.addObserver(self, selector: #selector(startRender), name: Notification.Name(Constants.startRenderNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endRender), name: Notification.Name(Constants.endRenderNotification), object: nil)
    }
    
    // MARK: Initialize layout
    func initLayout() {
        importedImageView.setDashBorder()
        importedImageView.cornerRadius = 3.0
        
        // set indicator color
        indicator.color = UIColor.orange
    }
    
    // MARK: Actions
    func addActions() {
        // import
        importBtn.rx.tap
//            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.showImportActions()
            })
            .disposed(by: rx_disposeBag)
        
        // tap play
        playBtn.rx.tap
            .skipWhile({[weak self] () -> Bool in
                return self?.viewModel.song == nil
            })
            .subscribe(onNext: { [weak self] () in
                self?.tapPlay()
            })
            .disposed(by: rx_disposeBag)
        
        // tap increase speed
        forwardBtn.rx.tap
            .skipWhile({[weak self] () -> Bool in
                return self?.viewModel.song == nil
            })
            .subscribe(onNext: { [weak self] () in
                self?.tapForward()
            })
            .disposed(by: rx_disposeBag)
        
        // tap decrease speed
        backwardBtn.rx.tap
            .skipWhile({[weak self] () -> Bool in
                return self?.viewModel.song == nil
            })
            .subscribe(onNext: { [weak self] () in
                self?.tapBackward()
            })
            .disposed(by: rx_disposeBag)
    }
    
    // show import action sheets
    func showImportActions() {
        // present action sheet to import audio
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // cancel
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // music library
        let importVideoButton = UIAlertAction(title: "Music Library", style: .default) { (action) in
            // show import from music library
            self.viewModel.showImport(withType: .itunes)
            
            // pause player when show import
            if (self.playBtn.tag == Constants.btnPlayTagPlaying) {
                self.tapPlay()
            }
        }
        importVideoButton.setValue(UIImage(named: "video"), forKey: "image")
        
        // icloud
        let importMoreButton = UIAlertAction(title: "Browse", style: .default) { (action) in
            // show import from icloud drive
            self.viewModel.showImport(withType: .icloud)
            
            // pause player when show import
            if (self.playBtn.tag == Constants.btnPlayTagPlaying) {
                self.tapPlay()
            }
        }
        importMoreButton.setValue(UIImage(named: "more"), forKey: "image")
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(importVideoButton)
        actionSheetController.addAction(importMoreButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: Subscribe to ViewModel
    func subscribeToViewModel() {
        let globalScheduler = ConcurrentDispatchQueueScheduler(queue:
            DispatchQueue.global())
        
        // show audio information
        viewModel.selectedUrlSubject.asObservable().map { (url) -> Song in
            url.toSongObject()!
            }
            .observeOn(globalScheduler)
            .subscribe(onNext: {[weak self] (song) in
                self?.showMetadata(song: song)
            })
            .disposed(by: rx_disposeBag)
        
        // draw wave
        viewModel.drawPoints.asObservable()
            .subscribe(onNext: {[weak self] (drawPoints) in
                self?.drawWave(withPoints: drawPoints)
            })
            .disposed(by: rx_disposeBag)
        
        // show time
        viewModel.timeAndPercentPublisher.asObservable()
            .map { (timeLeft, percent) -> String in
                timeLeft.toMinuteAndSecond()
            } .asDriver(onErrorJustReturn: "")
            .drive(timeLb.rx.text)
            .disposed(by: rx_disposeBag)
        
        // update play percent
        viewModel.timeAndPercentPublisher
            .asObservable()
            .map { (timeLeft, percent) -> Double in
                return percent
            }
            .subscribe(onNext: {[weak self] (percent) in
                self?.scroll(toPercentage: percent)
            }).disposed(by: rx_disposeBag)
        
        // be notified when finish playing
        viewModel.endPlayingPublisher.asObservable().subscribe(onNext: {[weak self] in
            self?.resetAfterPlaying()
        }).disposed(by: rx_disposeBag)
    }
    
    deinit {
        // remove observer
        NotificationCenter.default.removeObserver(self)
    }
}

// Show audio information
extension HomeVC {
    func showMetadata(song: Song) {
        DispatchQueue.main.async {
            if song.title != "" || song.artist != "" {
                self.songLb.text = song.title
                self.artistLb.text = song.artist
                self.importLb.isHidden = true
                self.songLb.isHidden = false
                self.artistLb.isHidden = false
            } else {
                self.importLb.isHidden = false
                self.songLb.isHidden = true
                self.artistLb.isHidden = true
            }
            
            if song.image != nil {
                self.importedImageView.removeDashBorder()
                self.importedImageView.image = song.image
                self.importedImageView.contentMode = .scaleAspectFit
            } else {
                self.importedImageView.setDashBorder()
                self.importedImageView.contentMode = .center
                self.importedImageView.image = UIImage(named: "plus")
            }
            
            // display time
            self.timeLb.text = song.duration.toMinuteAndSecond()
            self.speedLb.text = "1.0x"
        }
    }
    
    func resetAfterPlaying() {
        let song = viewModel.song
        
        DispatchQueue.main.async {
            self.timeLb.text = song?.duration.toMinuteAndSecond()
            self.playBtn.setImage(UIImage(named: "play"), for: .normal)
            self.playBtn.tag = 0
            
            self.waveScrollView.scrollToTop()
        }
    }
}

// Draw wave
extension HomeVC {
    func drawWave(withPoints points: [CGFloat]) {
        DispatchQueue.main.async {
            self.waveScrollView.drawWave(points)
            
            self.bottomWaveView.points = points
            
            self.bottomWaveView.setNeedsDisplay()
        }
    }
    
    @objc func startRender() {
        // show indicator
        indicator.startAnimating()
    }
    
    @objc func endRender() {
        // end indicator
        indicator.stopAnimating()
    }
}

// Play audio
extension HomeVC {
    func tapPlay() {
        if playBtn.tag == Constants.btnPlayTagPause {
            viewModel.play()
            
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(named: "pause"), for: .normal)
            }
        } else {
            viewModel.pause()
            
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(named: "play"), for: .normal)
            }
        }
        
        playBtn.tag = 1 - playBtn.tag
    }
    
    func tapForward() {
        // increase speed
        let speedString = viewModel.increaseSpeed()
        DispatchQueue.main.async {
            self.speedLb.text = speedString
        }
    }
    
    func tapBackward() {
        // decrease speed
        let speedString = viewModel.decreaseSpeed()
        DispatchQueue.main.async {
            self.speedLb.text = speedString
        }
    }
}

// Scrolling
extension HomeVC {
    func scroll(toPercentage percent: Double) {
        self.waveScrollView.scroll(toPercentage: percent)
        
        // also move the small marker here
        DispatchQueue.main.async {
            self.constraintSmallMarkerLeading.constant = CGFloat(percent) * self.view.frame.size.width
            self.view.layoutIfNeeded()
        }
    }
}
