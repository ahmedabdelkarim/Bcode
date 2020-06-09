//
//  ScanningViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 1/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit
import AVFoundation

class ScanningViewController: UIViewController, BarcodeScannerDelegate, ShortcutItemHandlerDelegate, VisionDetectorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BarcodeDetailsViewControllerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var barcodeScanner: BarcodeScanner!
    
    @IBOutlet weak var torchButton: RoundedButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var scanTypeButton: RoundedButton!
    @IBOutlet weak var scanTypesView: UIView!
    
    @IBOutlet weak var scanPhotoButton: RoundedButton!
    @IBOutlet weak var scanButtonView: UIView!
    @IBOutlet weak var scanButton: RoundedButton!
    @IBOutlet weak var switchCameraButton: RoundedButton!
    
    //MARK: - Variables
    private var currentBarcodeInfo:BarcodeInfo!
    private var previousBarcodeInfo:BarcodeInfo?
    private var visionDetector:VisionDetector!
    private var imagePicker:UIImagePickerController!
    private var isScanning = false
    private var torchIsOn = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButtonsState()
        
        barcodeScanner.delegate = self
        barcodeScanner.supportedTypes = [.qr]
        
        ShortcutItemHandler.delegate = self
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        barcodeScanner.vibrateWhenCodeDetected = Settings.vibrationEnabled
        scanButtonView.isHidden = Settings.autoScan
        updateButtonsState()
        hideScanTypes()
        
        if(Settings.autoScan) {
            if(isScanning == false) {
                startScanning()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopScanning()
        closeTorch()
    }
    
    @objc func appDidEnterBackground() {
        stopScanning()
        closeTorch()
    }
    
    @objc func appWillEnterForeground() {
        if(Settings.autoScan) {
            if(isScanning == false) {
                startScanning()
            }
        }
    }
    
    //MARK: - Functions
    func initImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.modalTransitionStyle = .flipHorizontal
    }
    
    func toggleCameraTorch() {
        if torchIsOn == false {
            openTorch()
        } else {
            closeTorch()
        }
    }
    
    func openTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .on
                device.unlockForConfiguration()
                
                torchIsOn = true
                torchButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func closeTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
                
                torchIsOn = false
                torchButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
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
        torchButton.isEnabled = false
        scanTypesView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.torchButton.alpha = 0
            self.statusLabel.alpha = 0
            self.scanTypesView.alpha = 1
        })
    }
    
    func hideScanTypes() {
        torchButton.isEnabled = isScanning && (barcodeScanner.camera == .backCamera)
        scanTypesView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.torchButton.alpha = 1
            self.statusLabel.alpha = 1
            self.scanTypesView.alpha = 0
        })
    }
    
    func startScanning() {
        barcodeScanner.startScanning()
        isScanning = barcodeScanner.isScanning
        
        updateButtonsState()
        
        torchButton.isEnabled = isScanning && (barcodeScanner.camera == .backCamera)
    }
    
    func stopScanning() {
        barcodeScanner.stopScanning()
        isScanning = barcodeScanner.isScanning
        
        updateButtonsState()
        
        closeTorch()
        torchButton.isEnabled = false
    }
    
    func updateButtonsState() {
        updateScanPhotoButtonState()
        updateScanButtonState()
        updateSwitchCameraButtonState()
    }
    
    func updateScanPhotoButtonState() {
        if(isScanning) {
            scanPhotoButton.alpha = 0.75
        }
        else {
            scanPhotoButton.alpha = 1
        }
    }
    
    func updateScanButtonState() {
        if(isScanning) {
            scanButton.setTitle("Stop", for: .normal)
            scanButtonView.alpha = 0.75
        }
        else {
            scanButton.setTitle("Scan", for: .normal)
            scanButtonView.alpha = 1
        }
    }
    
    func updateSwitchCameraButtonState() {
        if(Settings.autoScan){
            switchCameraButton.isEnabled = true
            switchCameraButton.alpha = 0.75
        }
        else {
            if(isScanning) {
                switchCameraButton.isEnabled = true
                switchCameraButton.alpha = 0.75
            }
            else {
                switchCameraButton.isEnabled = false
                switchCameraButton.alpha = 1
            }
        }
    }
    
    func handleBarcode(text: String) {
        let contentType = getContentType(text: text)
        currentBarcodeInfo = BarcodeInfo(text: text, contentType: contentType, isFavorite: false)
        
        //if continuous scan enabled, and detected a code different from previous one, add to history and continue scanning
        if(Settings.autoScan && Settings.continuousScan) {
            if(currentBarcodeInfo.text != previousBarcodeInfo?.text) { // new barcode detected
                currentBarcodeInfo.addToHistory()
                previousBarcodeInfo = currentBarcodeInfo //TODO: debug if previous is changed with current when detect new code!! (by reference)
                startScanning()
                
                //TODO: show animmated confirmation "added to history"
                
            }
            else {
                startScanning()
                
                //TODO: show "already added"
                
            }
        }
        else {//if continuous scan disabled, show details of detected code
            self.performSegue(withIdentifier: "showBarcodeDetails", sender: self)
        }
    }
    
    func getContentType(text: String) -> BarcodeContentType {
        if(text.isLink()) {
            return .link
        }
        else if(text.isPhoneNumber()) {
            return .phoneNumber
        }
        else if(text.isAddress()) {
            return .mapLocation
        }
        else if(text.isBase64Image()) {
            return .image
        }
        else {
            return .text
        }
    }
    
    func scanBarcodeWithTypes(_ types:[AVMetadataObject.ObjectType]) {
        if(self.presentedViewController as? BarcodeDetailsViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        stopScanning()
        barcodeScanner.supportedTypes = types
        startScanning()
    }
    
    func detectBarcodeInImage(image: UIImage) {
        if(visionDetector == nil) {
            visionDetector = VisionDetector()
            visionDetector.delegate = self
        }
        
        var detectionType:VisionDetectionType!
        
        if(barcodeScanner.supportedTypes == [.qr]) {
            detectionType = .qr
        }
        else if(barcodeScanner.supportedTypes == [.ean13]) {
            detectionType = .ean13
        }
        else {
            detectionType = .all
        }
        
        visionDetector.detect(image: image, detectionType: detectionType)
    }
    
    //MARK: - Actions
    @IBAction func torchButtonClick(_ sender: Any) {
        toggleCameraTorch()
    }
    
    @IBAction func scanTypeButtonClick(_ sender: Any) {
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
        closeTorch()
        scanBarcodeWithTypes([.qr, .ean13])
    }
    
    @IBAction func scanQRButtonClick(_ sender: Any) {
        updateScanTypeButton(imageName: "qrcode.viewfinder", title: "QR")
        updateStausLabel(text: "Scanning QR")
        
        hideScanTypes()
        closeTorch()
        scanBarcodeWithTypes([.qr])
    }
    
    @IBAction func scanEANButtonClick(_ sender: Any) {
        updateScanTypeButton(imageName: "barcode.viewfinder", title: "EAN")
        updateStausLabel(text: "Scanning EAN")
        
        hideScanTypes()
        closeTorch()
        scanBarcodeWithTypes([.ean13])
    }
    
    @IBAction func scanButtonClick(_ sender: Any) {
        
        //for testing on simulator
        
        //showBarcodeDetails(text: "+1-541-754-3010")
        //return
        
        if(isScanning) {
            stopScanning()
        }
        else {
            startScanning()
        }
    }
    
    @IBAction func switchCameraButtonClick(_ sender: Any) {
        Behaviors.vibrate()
        
        if(barcodeScanner.camera == .backCamera) {
            closeTorch()
            torchButton.isEnabled = false
            barcodeScanner.camera = .frontCamera
        }
        else {
            barcodeScanner.camera = .backCamera
            torchButton.isEnabled = true
        }
    }
    
    @IBAction func scanPhotoButtonClick(_ sender: Any) {
        scanPhotoButton.isUserInteractionEnabled = false
        
        if(imagePicker == nil) {
            initImagePicker()
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - BarcodeDetailsViewControllerDelegate
    func barcodeDetailsDismissed(viewController: BarcodeDetailsViewController, barcodeInfo: BarcodeInfo) {
        if(Settings.autoScan) {
            startScanning()
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showBarcodeDetails") {
            let viewController = segue.destination as? BarcodeDetailsViewController
            viewController?.barcodeInfo = currentBarcodeInfo
            viewController?.delegate = self
        }
    }
    
    //MARK: - BarcodeScannerDelegate
    func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String) {
        print("detected code: \(code)")
        
        stopScanning()
        updateButtonsState()
        
        handleBarcode(text: code)
    }
    
    func barcodeScannerFailedToDetectCode(scanner: BarcodeScanner) {
        print("loaded but failed to detect code")
        
        stopScanning()
        updateButtonsState()
    }
    
    func barcodeScannerFailedToLoad(scanner: BarcodeScanner) {
        print("failed to load")
        
        updateButtonsState()
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as! UIImage? {
            picker.dismiss(animated: true, completion: {
                self.detectBarcodeInImage(image: pickedImage)
            })
        }
        else {
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        scanPhotoButton.isUserInteractionEnabled = true
    }
    
    //MARK: - VisionDetectorDelegate
    func visionDetectorDetectedCode(detector: VisionDetector, code: String) {
        print("Detected code in photo: \(code)")
        
        Behaviors.vibrate()
        
        DispatchQueue.main.async {
            self.handleBarcode(text: code)
            self.scanPhotoButton.isUserInteractionEnabled = true
        }
    }
    
    func visionDetectorFailedToDetectCode(detector: VisionDetector) {
        print("Failed to detect code in photo")
        
        DispatchQueue.main.async {
            
            //TODO: show error popup
            
            self.scanPhotoButton.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - ShortcutItemHandlerDelegate
    func scanQR() {
        scanBarcodeWithTypes([.qr])
    }
    
    func scanEAN13() {
        scanBarcodeWithTypes([.ean13])
    }
    
    func scanPhoto() {
        if(self.presentedViewController as? BarcodeDetailsViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        if(imagePicker == nil) {
            initImagePicker()
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
}
