//
//  Importer.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import RxSwift

enum PickerType {
    case itunes
    case icloud
}

class Importer: NSObject {
    var type: PickerType!
    let selectedUrlSubject = PublishSubject<URL>()
    
    static let listImporters = [PickerType.itunes: LibraryImporter.self,
                                PickerType.icloud: ICloudImporter.self]
    
    static func initialize(withType type: PickerType) -> Importer {
        let importer: Importer = listImporters[type]!.init()
        return importer
    }
    
    required override init() {
        
    }
    
    func showImportPage() {
        
    }

    func getRootViewController() -> UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }


}
