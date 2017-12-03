//
//  MPMediaLibrary+rx.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/3/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift

extension MPMediaLibrary {
    static var authorized: Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    requestAuthorization { newStatus in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}


