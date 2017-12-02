//
//  WaveFormView.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class WaveFormView: UIView {

    @IBOutlet var contentView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("WaveFormView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    var points:[CGFloat] = []
    var isFixedSize = true
    
    override func draw(_ rect: CGRect) {
        if points.isEmpty {
            return
        }
        
        // calculate size of point and space between point
        let numberOfPoints = points.count
        var spacing = rect.size.width / CGFloat(numberOfPoints)
        var lineWidth = spacing * 2
        
        // if fixed size, we don't need to calculate, just get the default
        if !isFixedSize {
            // default size
            spacing = Constants.WaveForm.spacing
            lineWidth = Constants.WaveForm.lineWidth
        }
        
        let topPath = UIBezierPath()
        topPath.lineWidth = lineWidth
        topPath.move(to: CGPoint(x: 0.0, y: rect.height/2))
        
        // need to multiply the point so it'll be bigger and we can see
        let yMultiplier = rect.size.height
        
        for i in 0..<points.count {
            // mote to next point
            topPath.move(to: CGPoint(x: topPath.currentPoint.x + spacing, y: topPath.currentPoint.y))
            
            // draw line at this point
            topPath.addLine(to: CGPoint(x: topPath.currentPoint.x, y: topPath.currentPoint.y - (points[i] * yMultiplier)))
            
            topPath.close()
        }
        
        // set color for top
        UIColor(hex: Constants.WaveForm.waveColor).set()
        topPath.stroke()
        topPath.fill()
        
        // draw reflection (the bottom)
        let bottomPath = UIBezierPath()
        bottomPath.lineWidth = lineWidth
        bottomPath.move(to: CGPoint(x: 0.0, y: rect.height/2))
        
        // set the bottom will be half of top
        let yReflectMultiplier = yMultiplier/2
        
        for i in 0..<points.count {
            // move to next point
            bottomPath.move(to: CGPoint(x: bottomPath.currentPoint.x + spacing, y: bottomPath.currentPoint.y))
            
            // draw line at this point
            bottomPath.addLine(to: CGPoint(x: bottomPath.currentPoint.x, y: bottomPath.currentPoint.y - ((-1.0 * points[i]) * yReflectMultiplier)))
            
            bottomPath.close()
        }
        
        // set color for bottom
        UIColor(hex: Constants.WaveForm.waveColor).set()
        bottomPath.stroke(with: CGBlendMode.normal, alpha: 0.5)
        bottomPath.fill()
    }

}
