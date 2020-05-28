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
        barcodeInfoArray = [BarcodeInfo]()
        
        let types:[BarcodeContentType] = [.text, .url, .phoneNumber, .mapLocation, .image]
        
        var favorite = false
        for i in 1..<21 {
            let b = BarcodeInfo(text: "barcode text \(i)", contentType: types[(i-1)%5], isFavorite: favorite)
            favorite = !favorite
            barcodeInfoArray.append(b)
        }
        
        tableView.reloadData()
    }
    
    func showBarcodeDetails() {
        performSegue(withIdentifier: "showBarcodeDetails", sender: nil)
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
