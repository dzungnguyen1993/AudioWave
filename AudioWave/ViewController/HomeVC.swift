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
    
    lazy var viewModel = HomeViewModel(rootController: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
        addActions()
        subscribeToViewModel()
    }
    
    // MARK: Initialize layout
    func initLayout() {
        importedImageView.setDashBorder()
        importedImageView.cornerRadius = 3.0
    }
    
    // MARK: Actions
    func addActions() {
        importBtn.rx.tap
//            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.showImportActions()
            })
            .disposed(by: rx_disposeBag)
        
        playBtn.rx.tap
//            .debounce(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.tapPlay()
            })
            .disposed(by: rx_disposeBag)
        
        forwardBtn.rx.tap
//            .debounce(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.tapForward()
            })
            .disposed(by: rx_disposeBag)
        
        backwardBtn.rx.tap
//            .debounce(1.0, scheduler: MainScheduler.instance)
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
        }
        importVideoButton.setValue(UIImage(named: "video"), forKey: "image")
        
        // icloud
        let importMoreButton = UIAlertAction(title: "Browse", style: .default) { (action) in
            // show import from icloud drive
            self.viewModel.showImport(withType: .icloud)
        }
        importMoreButton.setValue(UIImage(named: "more"), forKey: "image")
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(importVideoButton)
        actionSheetController.addAction(importMoreButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: Subscribe to ViewModel
    func subscribeToViewModel() {
        // show audio information
        viewModel.selectedUrlSubject.asObservable().map { (url) -> Song in
            url.toSongObject()
            }.subscribe(onNext: {[weak self] (song) in
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
}

// Play audio
extension HomeVC {
    func tapPlay() {
        if playBtn.tag == 0 {
            viewModel.play()
            
            playBtn.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            viewModel.pause()
            
            playBtn.setImage(UIImage(named: "play"), for: .normal)
        }
        
        playBtn.tag = 1 - playBtn.tag
    }
    
    func tapForward() {
        // increase speed
        speedLb.text = viewModel.increaseSpeed()
    }
    
    func tapBackward() {
        // decrease speed
        speedLb.text = viewModel.decreaseSpeed()
    }
}
