//
//  HistoryViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BarcodeDetailsViewControllerDelegate {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadHistoryBarcodes()
    }
    
    //MARK: - Functions
    func loadHistoryBarcodes() {
        allBarcodeInfoArray = BarcodeInfo.getAllHistory()
        barcodeInfoArray = allBarcodeInfoArray
        
        tableView.reloadData()
    }
    
    func showBarcodeDetails() {
        performSegue(withIdentifier: "showBarcodeDetails", sender: nil)
    }
    
    override func scrollToTop() {
        tableView.setContentOffset(CGPoint.zero, animated: true)
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
            viewController?.delegate = self
        }
    }
    
    //MARK: - BarcodeDetailsViewControllerDelegate
    func barcodeDetailsDismissed(viewController: BarcodeDetailsViewController, barcodeInfo: BarcodeInfo) {
        if(tableView.indexPathForSelectedRow != nil) {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
