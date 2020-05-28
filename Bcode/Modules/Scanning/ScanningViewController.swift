//
//  ScanningViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 1/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit
import AVFoundation

//TODO: add UI to select barcode type (qr/ean13/all)

class ScanningViewController: UIViewController, BarcodeScannerDelegate, ShortcutItemHandlerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var barcodeScanner: BarcodeScanner!
    @IBOutlet weak var scanButtonView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    
    //MARK: - Variables
    //private var detectedCode:String = ""
    private var barcodeInfo:BarcodeInfo!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScanButtonState()
        updateChangeCameraButtonState()
        
        barcodeScanner.supportedTypes = [.qr, .ean13]
        barcodeScanner.delegate = self
        
        ShortcutItemHandler.delegate = self
        
        print("isScanning: \(barcodeScanner.isScanning)")
    }
    
    //MARK: - Functions
    func updateScanButtonState() {
        if(barcodeScanner.isScanning) {
            scanButton.setTitle("Stop", for: .normal)
            //scanButtonView.borderColor = .systemRed
            //scanButton.backgroundColor = .systemRed
        }
        else {
            scanButton.setTitle("Scan", for: .normal)
            //scanButtonView.borderColor = .systemBlue
            //scanButton.backgroundColor = .systemBlue
        }
    }
    
    func updateChangeCameraButtonState() {
        if(barcodeScanner.isScanning) {
            changeCameraButton.isEnabled = true
        }
        else {
            changeCameraButton.isEnabled = false
        }
    }
    
    func showBarcodeDetails() {
        performSegue(withIdentifier: "showBarcodeDetails", sender: nil)
    }
    
    func scanBarcodeWithType(_ type:AVMetadataObject.ObjectType) {
        if(self.presentedViewController as? BarcodeDetailsViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        barcodeScanner.stopScanning()
        barcodeScanner.supportedTypes = [type]
        barcodeScanner.startScanning()
        
        updateScanButtonState()
        updateChangeCameraButtonState()
    }
    
    //MARK: - Actions
    @IBAction func scanButtonClick(_ sender: Any) {
        
        //TODO: Set contentType based on detectedCode
        
        barcodeInfo = BarcodeInfo(text: "01221290994", contentType: .text, isFavorite: false)
        
        showBarcodeDetails()
        
        return
        
        
        
        if(barcodeScanner.isScanning) {
            barcodeScanner.stopScanning()
        }
        else {
            barcodeScanner.startScanning()
        }
        
        updateScanButtonState()
        updateChangeCameraButtonState()
        
        print("isScanning: \(barcodeScanner.isScanning)")
    }
    
    @IBAction func changeCameraButtonClick(_ sender: Any) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        if(barcodeScanner.camera == .backCamera) {
            barcodeScanner.camera = .frontCamera
        }
        else {
            barcodeScanner.camera = .backCamera
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showBarcodeDetails") {
            let viewController = segue.destination as? BarcodeDetailsViewController
            viewController?.barcodeInfo = barcodeInfo
        }
    }
    
    //MARK: - BarcodeScannerDelegate
    func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String) {
        print("detected code: \(code)")
        print("isScanning: \(barcodeScanner.isScanning)")
        
        updateScanButtonState()
        updateChangeCameraButtonState()
        
        //TODO: Set contentType based on detectedCode
        
        barcodeInfo = BarcodeInfo(text: code, contentType: .text, isFavorite: false)
        
        showBarcodeDetails()
    }
    
    func barcodeScannerFailedToDetectCode(scanner: BarcodeScanner) {
        print("loaded but failed to detect code")
        
        updateScanButtonState()
        updateChangeCameraButtonState()
    }
    
    func barcodeScannerFailedToLoad(scanner: BarcodeScanner) {
        print("failed to load")
        
        updateScanButtonState()
        updateChangeCameraButtonState()
    }
    
    //MARK: - ShortcutItemHandlerDelegate
    func scanQR() {
        scanBarcodeWithType(.qr)
    }
    
    func scanEAN13() {
        scanBarcodeWithType(.ean13)
    }
}
