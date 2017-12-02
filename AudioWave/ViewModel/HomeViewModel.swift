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

    init(rootController: UIViewController) {
        super.init()
        
        // subscribe to render
        selectedUrlSubject
            .asObservable()
            .subscribe(onNext: {[weak self] (url) in
                self?.render(withURL: url)
            }).disposed(by: self.rx_disposeBag)
    }
    
    // open picker
    func showImport(withType type: PickerType) {
        // open picker to pick audio file
        ImportManager.shared.openPicker(withType: type) { (url) in
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
}
