//
//  HistoryViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var tableView:UITableView!
    
    //MARK: - Variables
    private var barcodeInfoArray:[BarcodeInfo]!
    private var allBarcodeInfoArray:[BarcodeInfo]!
    private var linksBarcodeInfoArray:[BarcodeInfo]!
    private var textBarcodeInfoArray:[BarcodeInfo]!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        
        loadHistoryBarcodes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        //TODO: handle by delegate from presented view to know when dismissed
        //        if(tableView.indexPathForSelectedRow != nil) {
        //            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        //        }
    }
    
    //MARK: - Functions
    func loadHistoryBarcodes() {
        allBarcodeInfoArray = [BarcodeInfo]()
        
        let types:[BarcodeContentType] = [.text, .link, .phoneNumber, .mapLocation, .image]
        
        var favorite = false
        for i in 1..<21 {
            var text = ""
            switch types[(i-1)%5] {
            case .text:
                text = "Ahmed Abdelkarim"
                break
            case .link:
                text = "http://www.google.com"
                break
            case .phoneNumber:
                text = "01221290994"
                break
            case .mapLocation:
                text = "30.5,31.5"
                break
            case .image:
                text = "base64-image-string"
                break
            }
            
            let b = BarcodeInfo(text: text, contentType: types[(i-1)%5], isFavorite: favorite)
            favorite = !favorite
            allBarcodeInfoArray.append(b)
        }
        
        barcodeInfoArray = allBarcodeInfoArray
        tableView.reloadData()
    }
    
    func showBarcodeDetails() {
        performSegue(withIdentifier: "showBarcodeDetails", sender: nil)
    }
    
    //MARK: - Actions
    @IBAction func selectedCategoryChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            barcodeInfoArray = allBarcodeInfoArray
            break
        case 1:
            if(linksBarcodeInfoArray == nil) {
                linksBarcodeInfoArray = allBarcodeInfoArray.filter { $0.contentType == .link }
            }
            
            barcodeInfoArray = linksBarcodeInfoArray
            break
        case 2:
            if(textBarcodeInfoArray == nil) {
                textBarcodeInfoArray = allBarcodeInfoArray.filter { $0.contentType == .text }
            }
            
            barcodeInfoArray = textBarcodeInfoArray
            break
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.setup(barcodeInfo: barcodeInfoArray[indexPath.row])
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showBarcodeDetails()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showBarcodeDetails") {
            if(tableView.indexPathForSelectedRow == nil) {
                return
            }
            
            let viewController = segue.destination as? BarcodeDetailsViewController
            viewController?.barcodeInfo = barcodeInfoArray[tableView.indexPathForSelectedRow!.row]
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
