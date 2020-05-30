//
//  VisionDetectorDelegate.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/30/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation

protocol VisionDetectorDelegate {
    ///The code was detected and extracted successfully.
    func visionDetectorDetectedCode(detector: VisionDetector, code: String, type: VisionDetectionType)
    ///Couldn't detect code.
    func visionDetectorFailedToDetectCode(detector: VisionDetector)
}
