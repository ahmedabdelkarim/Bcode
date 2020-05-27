//
//  ScanningViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 1/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit
import AVFoundation

//TODO: handle urls by displaying button to open the url
//TODO: add UI to select barcode type (qr/ean13/all)
//TODO: add UI to change vibration enabled/disabled
//TODO: Quick action to share, and any other useful action

class ScanningViewController: UIViewController, BarcodeScannerDelegate, ShortcutItemHandlerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var barcodeScanner: BarcodeScanner!
    @IBOutlet weak var scanButtonView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    
    //MARK: - Variables
    private var detectedCode:String = ""
    
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
            scanButtonView.layer.borderColor = UIColor.systemRed.cgColor
            scanButton.backgroundColor = .systemRed
        }
        else {
            scanButton.setTitle("Scan", for: .normal)
            scanButtonView.layer.borderColor = UIColor.systemBlue.cgColor
            scanButton.backgroundColor = .systemBlue
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
    
    func displayDetectedCode(code: String) {
        detectedCode = code
        performSegue(withIdentifier: "showScanDetails", sender: nil)
        
        //        let detailsViewController = ScanDetailsViewController()
        //        detailsViewController.barcodeText = code
        //        //detailsViewController.isModalInPresentation = true
        //        present(detailsViewController, animated: true, completion: nil)
    }
    
    func scanBarcodeWithType(_ type:AVMetadataObject.ObjectType) {
        if(self.presentedViewController as? ScanDetailsViewController != nil) {
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
        if(segue.identifier == "showScanDetails") {
            let viewController = segue.destination as? ScanDetailsViewController
            viewController?.barcodeText = detectedCode
        }
    }
    
    //MARK: - BarcodeScannerDelegate
    func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String) {
        print("detected code: \(code)")
        print("isScanning: \(barcodeScanner.isScanning)")
        
        updateScanButtonState()
        updateChangeCameraButtonState()
        
        displayDetectedCode(code: code)
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
