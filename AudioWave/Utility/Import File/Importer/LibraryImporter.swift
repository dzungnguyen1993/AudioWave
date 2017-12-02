//
//  LibraryImporter.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import MediaPlayer

// for getting audio file from music library
class LibraryImporter: Importer, MPMediaPickerControllerDelegate {
    var mediaPicker: MPMediaPickerController!
    
    override func showImportPage() {
        mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.delegate = self
        self.getRootViewController()?.present(mediaPicker, animated: true, completion: {})
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

