//
//  BarcodeInfo.swift
//  Bcode
//
//  Created by Ahmed Abdelkarim on 5/27/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BarcodeInfo {
    //MARK: - Static Variables
    static private var historyBarcodes:[BarcodeInfo]? = nil
    static private var favoriteBarcodes:[BarcodeInfo]? = nil
    
    //MARK: - Variables
    private var id:Int64!
    var text:String!
    var contentType:BarcodeContentType!
    var isFavorite:Bool!
    var date:Date!
    
    //MARK: - Init
    init(text:String, contentType:BarcodeContentType, isFavorite:Bool) {
        self.text = text
        self.contentType = contentType
        self.isFavorite = isFavorite
        
        id = generateID()
    }
    
    init(id:Int64, text:String, contentType:BarcodeContentType, isFavorite:Bool, date:Date) {
        self.id = id
        self.text = text
        self.contentType = contentType
        self.isFavorite = isFavorite
        self.date = date
    }
    
    //MARK: - Properties
    public var actionImage:UIImage? {
        get {
            return contentType.actionImage
        }
    }
    
    //MARK: - Functions
    private func generateID() -> Int64 {
        return Int64(Date().hashValue)
    }
    
    public func performMainAction() {
        contentType.performMainAction(text: text)
    }
    
    static func getAllHistory() -> [BarcodeInfo] {
        if(BarcodeInfo.historyBarcodes == nil) {
            BarcodeInfo.historyBarcodes = BarcodeInfo.getAllHistoryFromDatabase()
            BarcodeInfo.historyBarcodes?.reverse()
        }
        
        return BarcodeInfo.historyBarcodes!
    }
    
    static func getFavorites() -> [BarcodeInfo] {
        if(BarcodeInfo.favoriteBarcodes == nil) {
            BarcodeInfo.favoriteBarcodes = BarcodeInfo.getFavoritesFromDatabase()
            //order by date descending (items added in database ascending)
            BarcodeInfo.favoriteBarcodes?.reverse()
        }
        
        return BarcodeInfo.favoriteBarcodes!
    }
    
    func addToHistory() {
        self.date = Date()
        
        self.addToHistoryInDatabase()
        
        if(BarcodeInfo.historyBarcodes != nil) {
            BarcodeInfo.historyBarcodes!.insert(self, at: 0)
        }
    }
    
    func favorite() {
        self.favoriteInDatabase()
        
        if(BarcodeInfo.favoriteBarcodes != nil) {
            BarcodeInfo.favoriteBarcodes!.append(self)
            //order by date descending
            BarcodeInfo.favoriteBarcodes = BarcodeInfo.favoriteBarcodes!.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
        }
        
        self.isFavorite = true
    }
    
    func unfavorite() {
        self.unfavoriteInDatabase()
        
        if(BarcodeInfo.favoriteBarcodes != nil) {
            BarcodeInfo.favoriteBarcodes!.removeAll(where: { $0.id == self.id })
        }
        
        self.isFavorite = false
    }
    
    func delete() {
        self.deleteFromDatabase()
        
        if(BarcodeInfo.historyBarcodes != nil) {
            BarcodeInfo.historyBarcodes!.removeAll(where: { $0.id == self.id })
        }
        
        if(BarcodeInfo.favoriteBarcodes != nil) {
            BarcodeInfo.favoriteBarcodes!.removeAll(where: { $0.id == self.id })
        }
    }
    
    static func deleteAllHistory() {
        BarcodeInfo.deleteAllHistoryFromDatabase()
        
        BarcodeInfo.historyBarcodes = [BarcodeInfo]()
        BarcodeInfo.favoriteBarcodes = [BarcodeInfo]()
    }
    
    //MARK: - Database
    private var barcodeInfoEntity:BarcodeInfoEntity!
    
    
    
    
    
    
    static var allBarcodeInfoArray:[BarcodeInfo]? = nil
    
    
    //TODO: get from database
    private static func getAllHistoryFromDatabase() -> [BarcodeInfo] {
        
        
        let request:NSFetchRequest<BarcodeInfoEntity> = BarcodeInfoEntity.fetchRequest()
        
        do {
            let entityArray = try Database.context.fetch(request)
            
            let array = entityArray.map({ (entity) -> BarcodeInfo in
                let item = BarcodeInfo(id: entity.id, text: entity.text!, contentType: BarcodeContentType(rawValue: entity.contentTypeString!)!, isFavorite: entity.isFavorite, date: entity.date!)
                item.barcodeInfoEntity = entity
                return item
            })
            
            return array
        } catch {
            return [BarcodeInfo]()
        }
        
//        if(allBarcodeInfoArray != nil) {
//            return allBarcodeInfoArray!
//        }
//
//        allBarcodeInfoArray = [BarcodeInfo]()
//
//        let types:[BarcodeContentType] = [.text, .link, .phoneNumber, .mapLocation, .image]
//
//        var favorite = false
//        for i in 1..<21 {
//            var text = ""
//            switch types[(i-1)%5] {
//            case .text:
//                text = "Ahmed Abdelkarim"
//                break
//            case .link:
//                text = "http://www.google.com"
//                break
//            case .phoneNumber:
//                text = "01221290994"
//                break
//            case .mapLocation:
//                text = "30.5,31.5"
//                break
//            case .image:
//                text = "base64-image-string"
//                break
//            }
//
//            let b = BarcodeInfo(text: text, contentType: types[(i-1)%5], isFavorite: favorite)
//            b.date = Date()
//            favorite = !favorite
//            allBarcodeInfoArray!.append(b)
//        }
//
//        return allBarcodeInfoArray!
    }
    
    
    //TODO: get from database
    private static func getFavoritesFromDatabase() -> [BarcodeInfo] {
        
        let request:NSFetchRequest<BarcodeInfoEntity> = BarcodeInfoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        
        do {
            let entityArray = try Database.context.fetch(request)
            
            let array = entityArray.map({ (entity) -> BarcodeInfo in
                let item = BarcodeInfo(id: entity.id, text: entity.text!, contentType: BarcodeContentType(rawValue: entity.contentTypeString!)!, isFavorite: entity.isFavorite, date: entity.date!)
                item.barcodeInfoEntity = entity
                return item
            })
            
            return array
        } catch {
            return [BarcodeInfo]()
        }
        
        
//        if(allBarcodeInfoArray == nil) {
//            allBarcodeInfoArray = getAllHistoryFromDatabase()
//        }
//
//        return allBarcodeInfoArray!.filter( { $0.isFavorite == true } )
    }
    
    private func addToHistoryInDatabase() -> Bool {
        
        
        let newEntity = BarcodeInfoEntity(context: Database.context)
        newEntity.id = self.id
        newEntity.text = self.text
        newEntity.contentTypeString = self.contentType.rawValue
        newEntity.isFavorite = self.isFavorite
        newEntity.date = self.date
        
        self.barcodeInfoEntity = newEntity
        
        return Database.saveContext()
        
        
//        if(BarcodeInfo.allBarcodeInfoArray == nil) {
//            BarcodeInfo.allBarcodeInfoArray = BarcodeInfo.getAllHistoryFromDatabase()
//        }
//
//        BarcodeInfo.allBarcodeInfoArray!.append(self)
    }
    
    private func favoriteInDatabase() -> Bool {
        
        barcodeInfoEntity.isFavorite = true
        
        return Database.saveContext()
        
        
//        if(BarcodeInfo.allBarcodeInfoArray == nil) {
//            BarcodeInfo.allBarcodeInfoArray = BarcodeInfo.getAllHistoryFromDatabase()
//        }
//
//        BarcodeInfo.allBarcodeInfoArray!.first(where: { $0.id == self.id })?.isFavorite = true
    }
    
    private func unfavoriteInDatabase() -> Bool {
        
        barcodeInfoEntity.isFavorite = false
        
        return Database.saveContext()
        
        
//        if(BarcodeInfo.allBarcodeInfoArray == nil) {
//            BarcodeInfo.allBarcodeInfoArray = BarcodeInfo.getAllHistoryFromDatabase()
//        }
//
//        BarcodeInfo.allBarcodeInfoArray!.first(where: { $0.id == self.id })?.isFavorite = false
    }
    
    private func deleteFromDatabase() -> Bool {
        
        Database.context.delete(barcodeInfoEntity)
        
        return Database.saveContext()
        
        
//        if(BarcodeInfo.allBarcodeInfoArray == nil) {
//            BarcodeInfo.allBarcodeInfoArray = BarcodeInfo.getAllHistoryFromDatabase()
//        }
//
//        BarcodeInfo.allBarcodeInfoArray!.removeAll(where: { $0.id == self.id })
    }
    
    private static func deleteAllHistoryFromDatabase() -> Bool {
        let fetchRequest:NSFetchRequest<BarcodeInfoEntity> = BarcodeInfoEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try Database.context.execute(batchDeleteRequest)
            return true
        } catch {
            return false
        }
    }
}
