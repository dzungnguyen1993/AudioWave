//
//  WaveScrollView.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class WaveScrollView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var waveView: WaveFormView!
    @IBOutlet weak var constraintWaveViewWidth: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("WaveScrollView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        waveView.isFixedSize = false
    }
    
    // draw wave
    func drawWave(_ values: [CGFloat]) {
        waveView.points = values
        
        // update waveView frame
        constraintWaveViewWidth.constant = (CGFloat)(Double(values.count) * Double(Constants.WaveForm.spacing)) + self.frame.size.width/2
        print(constraintWaveViewWidth.constant)
        waveView.setNeedsDisplay()
    }

}
