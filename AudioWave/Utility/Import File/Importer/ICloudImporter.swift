//
//  ICloudImporter.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

// for getting audio file from iCloud drive
class ICloudImporter: Importer, UIDocumentPickerDelegate {
    override func showImportPage() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [ "public.audio"], in: .import)
        documentPickerController.delegate = self
        self.getRootViewController()?.present(documentPickerController, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls.first!
        self.selectedUrlSubject.onNext(url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}
