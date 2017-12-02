//
//  Extensions.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import AVKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func setDashBorder() {
        let border = CAShapeLayer()
        border.name = "dash border"
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(border)
    }
    
    func removeDashBorder() {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.name == "dash border" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension Double {
    func toMinuteAndSecond() -> String {
        let total = Int(self)
        
        let minute = total / 60
        let second = total % 60
        
        if second < 10 {
            return "\(minute):0\(second)"
        }
        return "\(minute):\(second)"
    }
}

extension URL {
    func toSongObject() -> Song {
        let playerItem = AVPlayerItem(url: self)
        let metadataList = playerItem.asset.commonMetadata
        
        var song = Song()
        song.url = self
        
        for item in metadataList {
            if let key = item.commonKey?.rawValue, let value = item.value {
                if key == "title" {
                    song.title = value as! String
                }
                if key  == "artist" {
                    song.artist = value as! String
                }
                if key == "artwork" {
                    if let audioImage = UIImage(data: value as! Data) {
                        song.image = audioImage
                    }
                }
            }
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: self)
            song.duration = audioPlayer.duration
        } catch {
            song.duration = 0
        }
        
        return song
    }
}

extension UIColor {
    // initialize UIColor from hex
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
