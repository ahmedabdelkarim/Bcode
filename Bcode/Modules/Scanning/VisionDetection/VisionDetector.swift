//
//  VisionDetector.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/30/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Vision

class VisionDetector {
    //MARK: - Variables
    var delegate: VisionDetectorDelegate?
    
    //MARK: - Functions
    func detect(image:UIImage, detectionType:VisionDetectionType) {
        switch detectionType {
        case .qr:
            let detected = detectQR(image:image)
            if(detected != nil) {
                print(detected!)
                delegate?.visionDetectorDetectedCode(detector: self, code: detected!, type: .qr)
            }
            else {
                delegate?.visionDetectorFailedToDetectCode(detector: self)
            }
            break
        case .ean13:
            detectBarcode(image:image)
            break
        case .all:
            let detected = detectQR(image:image)
            
            if(detected != nil) {
                print(detected!)
                delegate?.visionDetectorDetectedCode(detector: self, code: detected!, type: .qr)
            }
            else {
                detectBarcode(image:image)
            }
            break
        }
    }
    
    //MARK: - Private Functions
    private func detectQR(image:UIImage) -> String? {
        let ciImage = CIImage(image:image)!
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        
        var detected = ""
        
        let features = detector.features(in: ciImage)
        
        if(features.count == 0 || features as? [CIQRCodeFeature] == nil) {
            return nil
        }
        
        for feature in features as! [CIQRCodeFeature] {
            detected += feature.messageString!
        }
        
        return detected
    }
    
    private func detectBarcode(image:UIImage) {
        var vnBarCodeDetectionRequest : VNDetectBarcodesRequest{
            let request = VNDetectBarcodesRequest { (request,error) in
                if let error = error as NSError? {
                    print("Error in detecting - \(error)")
                    self.delegate?.visionDetectorFailedToDetectCode(detector: self)
                    return
                }
                else {
                    let observations = request.results as? [VNBarcodeObservation]
                    
                    if(observations != nil && observations!.count > 0) {
                        let detected = observations!.first!.payloadStringValue ?? ""
                        self.delegate?.visionDetectorDetectedCode(detector: self, code: detected, type: .ean13)
                    }
                    else {
                        self.delegate?.visionDetectorFailedToDetectCode(detector: self)
                    }
                }
            }
            
            return request
        }
        
        let cgImage = image.cgImage
        
        if(cgImage == nil) {
            delegate?.visionDetectorFailedToDetectCode(detector: self)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: CGImagePropertyOrientation.up, options: [:])
        let vnRequests = [vnBarCodeDetectionRequest]
        
        DispatchQueue.global(qos: .background).async {
            do{
                try requestHandler.perform(vnRequests)
            }
            catch let error as NSError {
                print("Error in performing Image request: \(error)")
                self.delegate?.visionDetectorFailedToDetectCode(detector: self)
            }
        }
    }
    
}
