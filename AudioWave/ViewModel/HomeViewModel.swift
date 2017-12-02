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

    init(rootController: UIViewController) {
        super.init()
        
    }
    
    func showImport(withType type: PickerType) {
        // open picker to pick audio file
        ImportManager.shared.openPicker(withType: type) { (url) in
            // notify about new url
            self.selectedUrlSubject.onNext(url)
        }
    }
}
