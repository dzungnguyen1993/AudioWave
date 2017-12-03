//
//  WaveScrollView.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol WaveScrollViewDelegate: class {
    func scrollView(didScrollToPercentage percent: Double)
}

class WaveScrollView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var waveView: WaveFormView!
    @IBOutlet weak var constraintWaveViewWidth: NSLayoutConstraint!
    weak var delegate: WaveScrollViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    fileprivate var isDragging = false
    
    func initView() {
        Bundle.main.loadNibNamed("WaveScrollView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        waveView.isFixedSize = false
        self.scrollView.delegate = self
    }
    
    // draw wave
    func drawWave(_ values: [CGFloat]) {
        waveView.points = values
        
        // update waveView frame
        DispatchQueue.main.async {
            self.constraintWaveViewWidth.constant = (CGFloat)(Double(values.count) * Double(Constants.WaveForm.spacing)) + self.frame.size.width/2
            self.waveView.setNeedsDisplay()
        }
        
        self.scrollToTop()
    }

    // scroll when playing
    func scroll(toPercentage percent: Double) {
        if isDragging {
            return
        }
        let size = Double(waveView.points.count) * Double(Constants.WaveForm.spacing)
        
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(CGPoint(x: size * percent, y: 0), animated: true)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
}

extension WaveScrollView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isDragging {
            let offset = Double(scrollView.contentOffset.x)
            let total = Double(waveView.points.count) * Double(Constants.WaveForm.spacing)
            
            let percent = Double(offset / total)
            isDragging = false
            
            self.delegate?.scrollView(didScrollToPercentage: percent)
        }
    }
}
