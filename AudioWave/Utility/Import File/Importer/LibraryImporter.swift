//
//  LibraryImporter.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import MediaPlayer
import RxSwift
import RxCocoa

// for getting audio file from music library
class LibraryImporter: Importer, MPMediaPickerControllerDelegate {
    override func showImportPage() {
        // request authority before opening picker
        let authorized = MPMediaLibrary.authorized
            .share()
        
        authorized
            .skipWhile { $0 == false }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                // open picker
                let mediaPicker = MPMediaPickerController(mediaTypes: .music)
                mediaPicker.delegate = self
                Utility.getRootViewController()?.present(mediaPicker, animated: true, completion: {})
            })
            .disposed(by: rx_disposeBag)
        
        authorized
            .skip(1)
            .takeLast(1)
            .filter { $0 == false }
            .subscribe(onNext: { [weak self] _ in
                // show error message
                guard let errorMessage = self?.errorMessage else { return }
                DispatchQueue.main.async(execute: errorMessage)
            })
            .disposed(by: rx_disposeBag)
    }
    
    private func errorMessage() {
        let rootViewController = Utility.getRootViewController()
        rootViewController?.alert(title: "No access to media library",
              text: "You can grant access to AudioWave from settings")
            .take(5.0, scheduler: MainScheduler.instance)
            .subscribe(onDisposed: {
                
            })
            .disposed(by: rx_disposeBag)
    }
    
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let mpMediaItem = mediaItemCollection.items.first!
        let url = mpMediaItem.assetURL!
        
        self.selectedUrlSubject.onNext(url)
        
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
}

