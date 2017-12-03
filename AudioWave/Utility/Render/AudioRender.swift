//
//  AudioRender.swift
//  AudioWave
//
//  Created by Thanh-Dung Nguyen on 12/2/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate
import RxSwift
import NSObject_Rx

class AudioRender: NSObject {    
    func render(url: URL) -> Observable<[CGFloat]>? {
        if let file = try? AVAudioFile(forReading: url) {
            let downSampledValues = self.getDownSampledValues(fromFile: file)
            
            return Observable.of(downSampledValues)
        }
        
        return nil
    }
    
    fileprivate func getDownSampledValues(fromFile file: AVAudioFile) -> [CGFloat] {
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
        let buffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: UInt32(file.length))!
        try! file.read(into: buffer)
        
        // create array of values in audio file
        let audioValues = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
        let downSampledValues = downSample(audioValues)
        
        return downSampledValues
    }
    
    // reduce number of samples based on multiplier
    fileprivate func downSample(_ originalValues: [Float]) -> [CGFloat] {
        var buffer = [Float](repeating: 0.0, count: Int(originalValues.count))
        
        let sampleCount = vDSP_Length(originalValues.count)
        vDSP_vabs(originalValues, 1, &buffer, 1, sampleCount);
        
        let samplesPerPixel = Int(Constants.WaveForm.samplePerPixel * Constants.WaveForm.multiplier)
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel),
                             count: Int(samplesPerPixel))
        let downSampledLength = Int(originalValues.count / samplesPerPixel)
        var downSampledData = [Float](repeating:0.0, count:downSampledLength)
        
        vDSP_desamp(buffer,
                    vDSP_Stride(samplesPerPixel),
                    filter, &downSampledData,
                    vDSP_Length(downSampledLength),
                    vDSP_Length(samplesPerPixel))
        
        return downSampledData.map{CGFloat($0)}
    }
}

