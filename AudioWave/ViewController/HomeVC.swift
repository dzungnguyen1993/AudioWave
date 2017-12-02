//
//  HomeVC.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var importedImageView: UIImageView!
    @IBOutlet weak var importLb: UILabel!
    @IBOutlet weak var songLb: UILabel!
    @IBOutlet weak var artistLb: UILabel!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var speedLb: UILabel!
    @IBOutlet weak var waveScrollView: WaveScrollView!
    @IBOutlet weak var bottomWaveView: WaveFormView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
    }
    
    // initialize layout
    func initLayout() {
        importedImageView.setDashBorder()
        importedImageView.cornerRadius = 3.0
    }
}
