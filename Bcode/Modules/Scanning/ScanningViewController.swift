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
    
    @IBOutlet weak var flashButton: RoundedButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var scanTypeButton: RoundedButton!
    @IBOutlet weak var scanTypesView: UIView!
    
    @IBOutlet weak var scanButtonView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var changeCameraButton: UIButton!
    
    //MARK: - Variables
    private var barcodeInfo:BarcodeInfo!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScanButtonState()
        updateChangeCameraButtonState()
        
        barcodeScanner.delegate = self
        barcodeScanner.supportedTypes = [.qr]
        
        ShortcutItemHandler.delegate = self
        
        print("isScanning: \(barcodeScanner.isScanning)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        barcodeScanner.vibrateWhenCodeDetected = Settings.vibrationEnabled
        scanButtonView.isHidden = Settings.autoScan
        updateChangeCameraButtonState()
    }
    
    //MARK: - Functions
    func toggleCameraTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    device.torchMode = .on
                    flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
                } else {
                    device.torchMode = .off
                    flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func updateScanTypeButton(imageName:String, title:String) {
        scanTypeButton.setImage(UIImage(systemName: imageName), for: .normal)
        scanTypeButton.setTitle(title, for: .normal)
    }

    func updateStausLabel(text: String = "") {
        statusLabel.text = text
    }
    
    func showScanTypes() {
        flashButton.isEnabled = false
        scanTypesView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.flashButton.alpha = 0
            self.statusLabel.alpha = 0
            self.scanTypesView.alpha = 1
        })
    }
    
    func hideScanTypes() {
        flashButton.isEnabled = true
        scanTypesView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.flashButton.alpha = 1
            self.statusLabel.alpha = 1
            self.scanTypesView.alpha = 0
        })
    }
    
    func updateScanButtonState() {
        if(barcodeScanner.isScanning) {
            scanButton.setTitle("Stop", for: .normal)
            scanButtonView.alpha = 0.75
        }
        else {
            scanButton.setTitle("Scan", for: .normal)
            scanButtonView.alpha = 1
        }
    }
    
    func updateChangeCameraButtonState() {
        if(Settings.autoScan){
            changeCameraButton.isEnabled = true
        }
        else {
            if(barcodeScanner.isScanning) {
                changeCameraButton.isEnabled = true
            }
            else {
                changeCameraButton.isEnabled = false
            }
        }
    }
    
    func showBarcodeDetails() {
        performSegue(withIdentifier: "showBarcodeDetails", sender: nil)
    }
    
    func scanBarcodeWithTypes(_ types:[AVMetadataObject.ObjectType]) {
        if(self.presentedViewController as? BarcodeDetailsViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        //barcodeScanner.stopScanning()
        barcodeScanner.supportedTypes = types
        //barcodeScanner.startScanning()
        
        updateScanButtonState()
        updateChangeCameraButtonState()
    }
    
    //MARK: - Actions
    @IBAction func cameraFlashButtonClick(_ sender: Any) {
        toggleCameraTorch()
    }
    
    @IBAction func scalTypeButtonClick(_ sender: Any) {
        if(scanTypesView.isUserInteractionEnabled == false) {
            showScanTypes()
        }
        else {
            hideScanTypes()
        }
    }
    
    @IBAction func scanAllButtonClick(_ sender: Any) {
        updateScanTypeButton(imageName: "viewfinder", title: "ALL")
        updateStausLabel(text: "Scanning ALL")
        
        hideScanTypes()
        scanBarcodeWithTypes([.qr, .ean13])
    }
    
    @IBAction func scanQRButtonClick(_ sender: Any) {
        updateScanTypeButton(imageName: "qrcode.viewfinder", title: "QR")
        updateStausLabel(text: "Scanning QR")
        
        hideScanTypes()
        scanBarcodeWithTypes([.qr])
    }
    
    @IBAction func scanEANButtonClick(_ sender: Any) {
        updateScanTypeButton(imageName: "barcode.viewfinder", title: "EAN")
        updateStausLabel(text: "Scanning EAN")
        
        hideScanTypes()
        scanBarcodeWithTypes([.ean13])
    }
    
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
        Behaviors.vibrate()
        
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
        scanBarcodeWithTypes([.qr])
    }
    
    func scanEAN13() {
        scanBarcodeWithTypes([.ean13])
    }
}
