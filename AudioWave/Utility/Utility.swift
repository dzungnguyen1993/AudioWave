//
//  Utility.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/3/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static func getRootViewController() -> UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }
}
