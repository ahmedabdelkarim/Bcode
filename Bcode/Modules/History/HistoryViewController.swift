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
    
    //MARK: - Functions
    func loadHistoryBarcodes() {
        barcodeInfoArray = [BarcodeInfo]()
        
        for i in 1..<21 {
            let b = BarcodeInfo()
            b.text = "barcode text \(i)"
            barcodeInfoArray.append(b)
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
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
