//
//  FavoritesViewController.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BarcodeDetailsViewControllerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var categorySegmentedControl: DesignableSegmentedControl!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var emptyStateIndicator: UILabel!
    
    //MARK: - Variables
    private var barcodeInfoArray:[BarcodeInfo]!
    private var allBarcodeInfoArray:[BarcodeInfo]!
    private var linksBarcodeInfoArray:[BarcodeInfo]!
    private var textBarcodeInfoArray:[BarcodeInfo]!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FavoriteCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavoriteBarcodes()
    }
    
    //MARK: - Functions
    func loadFavoriteBarcodes() {
        allBarcodeInfoArray = BarcodeInfo.getFavorites()
        
        resetCategories()
        updateCategory(index: categorySegmentedControl.selectedSegmentIndex)
        
        tableView.reloadData()
    }
    
    func showBarcodeDetails() {
        performSegue(withIdentifier: "showBarcodeDetails", sender: nil)
    }
    
    override func scrollToTop() {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func resetCategories() {
        barcodeInfoArray = nil
        linksBarcodeInfoArray = nil
        textBarcodeInfoArray = nil
    }
    
    func updateCategory(index:Int) {
        switch index {
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
        
        emptyStateIndicator.isHidden = barcodeInfoArray.count > 0
    }
    
    //MARK: - Actions
    @IBAction func selectedCategoryChanged(_ sender: UISegmentedControl) {
        updateCategory(index: categorySegmentedControl.selectedSegmentIndex)
        
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoriteCell
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
    func barcodeDetailsDismissed(viewController: BarcodeDetailsViewController, barcodeInfo: BarcodeInfo, isDeleted: Bool, isFavoriteChanged: Bool) {
        if(tableView.indexPathForSelectedRow == nil) {
            return
        }
        
        if(isDeleted || (isFavoriteChanged && barcodeInfo.isFavorite == false)) {
            allBarcodeInfoArray = BarcodeInfo.getFavorites()
            
            resetCategories()
            updateCategory(index: categorySegmentedControl.selectedSegmentIndex)
            
            if(isDeleted) {
                tableView.deleteRows(at: [tableView.indexPathForSelectedRow!], with: .fade)
            }
            else {
                tableView.deleteRows(at: [tableView.indexPathForSelectedRow!], with: .right)
            }
        }
        else {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
}
