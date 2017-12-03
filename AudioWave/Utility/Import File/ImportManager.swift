//
//  ImportManager.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import NSObject_Rx
import RxSwift

class ImportManager: NSObject {
    var importer: Importer!
    typealias ImportCompletion = ((URL) -> Void)
    var completion: ImportCompletion?
    
    static let shared = ImportManager()
    
    override init() {
        
    }
    
    // open picker to pick audio file
    func openPicker(withType type: PickerType, completion: @escaping ImportCompletion) {
        importer = Importer.initialize(withType: type)
        importer.selectedUrlSubject.asObservable().subscribe(onNext: { (url) in
            completion(url)
        }).disposed(by: rx_disposeBag)
        
        importer.showImportPage()
    }
}

