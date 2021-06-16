//
//  LocalManager.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 06/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import CoreData

class LocalManagerHelper {
    static let localSharedInstance = LocalManagerHelper()
    
    private init(){}
    
    
    //-------------------------------------------------------------------------------------------------------------------------
    
    func checkProduct(entityName: EntityName, userEmail: String, productId: Int, completion: @escaping (LocalProductDetails?, Bool) -> Void) { //return obj         from LocalPDs to display user selection when navigate to productDeatails screen and show his selections  [ later ]
        let appDelegte: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegte.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        print("checkProduct - start with id => \(productId)")
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: Constants.productIdCoraDataAtt){
                            if prodId as! Int == productId {
                                print("checkProduct - FOUNDD id")
                                
                                switch entityName {
                                case .FavoriteProducts:
                                    completion(nil, true)
                                case .CartProducts:
                                    let mainCategory = item.value(forKey: Constants.mainCategoryCoraDataAtt) as? String ?? "---"
                                    let imgData = item.value(forKey: Constants.productImageCoraDataAtt) as? Data ?? Data()
                                    let price = item.value(forKey: Constants.productPriceCoraDataAtt) as? String ?? "--"
                                    let titleVal = item.value(forKey: Constants.titleCoraDataAtt) as? String ?? "Product"
                                    let sizeVal = item.value(forKey: Constants.selectedSizeCoraDataAtt) as? String ?? "-"
                                    let colorVal = item.value(forKey: Constants.selectedColorCoraDataAtt) as? String ?? "-"
                                    let quantVal = item.value(forKey: Constants.quantityCoraDataAtt) as? Int ?? 1
                                    let invQuant = item.value(forKey: Constants.invQuantCoraDataAtt) as? Int ?? 0
                                    completion(LocalProductDetails(productId: productId, userEmail: userEmail, title: titleVal, productPrice: price, productImageData: imgData,     quantity: quantVal, selectedSize: sizeVal, selectedColor: colorVal, mainCategory: mainCategory, inventory_quantity: invQuant), true)
                                }
                                return                // useless???
                                
                            } else {
                                print("checkProduct - id - not match")
                            }
                        } else {
                            print("checkProduct - Failed to get id")
                        }
                    } else {
                        print("checkProduct -  Not match")
                    }
                } else {
                    print("checkProduct - Failed to get email")
                }
            }
        } catch {
            print("checkProduct - CAAAAAAAAATCHHHHHHHH")
            completion(nil, false)
        }
        print("checkProduct - finish checking")
        completion(nil, false)
    }
    
    //----------------------------------------------FAVORITE--------------------------------------------------------
    
    func addProductToFavorite(localProduct: LocalProductDetails, completion: @escaping (Bool) -> Void){
        
        checkProduct(entityName: .FavoriteProducts, userEmail: localProduct.userEmail, productId: localProduct.productId) { (_, resBool) in
            if !resBool {
                print("addProductToFavorite - start adding")
                let appDelegte = UIApplication.shared.delegate as? AppDelegate
                let context = appDelegte!.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: Constants.favoriteCoraDataEntity, in: context)
                let productMngObj = NSManagedObject(entity: entity!, insertInto: context)
                
                print("addProductToFavorite - imgData => \(String(describing: localProduct.productImageData))")
                
                let mainCategory = localProduct.mainCategory ?? "---"
                let price = localProduct.productPrice ?? "--"
                let titleVal = localProduct.title ?? "Product"
                
                productMngObj.setValue(localProduct.userEmail, forKey: Constants.userEmailCoraDataAtt)
                productMngObj.setValue(localProduct.productId, forKey: Constants.productIdCoraDataAtt)
                productMngObj.setValue(localProduct.productImageData, forKey: Constants.productImageCoraDataAtt)
                productMngObj.setValue(price, forKey: Constants.productPriceCoraDataAtt)
                productMngObj.setValue(mainCategory, forKey: Constants.mainCategoryCoraDataAtt)
                productMngObj.setValue(titleVal, forKey: Constants.titleCoraDataAtt)
                
                do{
                    try context.save()
                    print("\naddProductToFavorite - DataAdded Successfully")
                    
                } catch {
                    print("addProductToFavorite - CATCH WHEN add")
                    completion(false)
                }
                print("\naddProductToFavorite- finish adding")
                completion(true)
            } else {
                print("\naddProductToFavorite- product is already in the favorite")
                completion(false)
            }
        }

    }
   
    func getAllProductsFromFavorite(userEmail: String, completion: @escaping ([LocalProductDetails]?) -> Void){
        
        var localProductDetails: [LocalProductDetails] = [LocalProductDetails]()
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.favoriteCoraDataEntity)
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: Constants.productIdCoraDataAtt){
                            print("getAllProductsFromFavorite - append product with id => \(prodId as! Int)")
                            
                            let mainCategory = item.value(forKey: Constants.mainCategoryCoraDataAtt) as? String ?? "---"
                            let imgData = item.value(forKey: Constants.productImageCoraDataAtt) as? Data ?? Data()
                            let price = item.value(forKey: Constants.productPriceCoraDataAtt) as? String ?? "--"
                            let titleVal = item.value(forKey: Constants.titleCoraDataAtt) as? String ?? "Product"
                            
                            localProductDetails.append(LocalProductDetails(productId: prodId as! Int, userEmail: userEmail, title: titleVal, productPrice: price, productImageData: imgData, quantity: nil, selectedSize: nil, selectedColor: nil, mainCategory: mainCategory, inventory_quantity: nil))
                            
                        } else {
                            print("getAllProductsFromFavorite - failed to get ID")
                        }
                    } else {
                        print("getAllProductsFromFavorite - email does NOT match")
                    }
                } else {
                    print("getAllProductsFromFavorite - Failed to get email")
                }
            }
        } catch {
            print("CAAAAAAAAATCHHHHHHHH - getAllProductsFromFavorite ")
            completion(nil)
        }
        print("getAllProductsFromFavorite - Finish Retrive")
        
        if localProductDetails.isEmpty {
            completion(nil)
        } else {
            completion(localProductDetails)
        }
    }
    
    
    func deleteProductFromFavorite(localProductDetails: LocalProductDetails, completion: @escaping (Bool) -> Void){
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.favoriteCoraDataEntity)
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if localProductDetails.userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: Constants.productIdCoraDataAtt){
                            if prodId as! Int == localProductDetails.productId{
                                print("deleteProductFromFavorite - FOUNDDDDDDDDDD  DLT")
                                context.delete(item)
                                try context.save()
                                print("deleteProductFromFavorite - DataDeletedFromLocal  DLT")
                                completion(true)
                                return
                            } else {
                                print("id does NOT Match to DLT")
                            }
                        } else {
                            print("failed to get ID to DLT")
                        }
                    } else {
                        print("email does NOT Match to DLT")
                    }
                } else {
                    print("failed to get email to DLT")
                }
            }
        } catch {
            print("deleteProductFromFavorite - CAAAAAAAAATCHHHHHHHH")
            completion(false)
        }
        print("deleteProductFromFavorite - did not found to DLT")
        completion(false)
    }
    
    
    //--------------------------------------------------------CART-----------------------------------------------------------
        
    func addProductToCart(localProduct: LocalProductDetails, completion: @escaping (Bool) -> Void){
        
        checkProduct(entityName: .CartProducts, userEmail: localProduct.userEmail, productId: localProduct.productId) { (product, resBool) in
            if product == nil {
                print("addProductToCart - start adding to Local")
                let appDelegte = UIApplication.shared.delegate as? AppDelegate
                let context = appDelegte!.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: Constants.cartCoraDataEntity, in: context)
                let productMngObj = NSManagedObject(entity: entity!, insertInto: context)
                
                print("addProductToCart - PUT ID => \(localProduct.productId)")
                print("addProductToCart - PUT imgData => \(String(describing: localProduct.productImageData))")
                print("addProductToCart - PUT title => \(String(describing: localProduct.title))")
                
                let mainCategory = localProduct.mainCategory ?? "---"
                let price = localProduct.productPrice ?? "--"
                let titleVal = localProduct.title ?? "Product"
                let size = localProduct.selectedSize ?? "-"
                let color = localProduct.selectedColor ?? "-"
                let quantity = localProduct.quantity ?? 1
                let invQuantity = localProduct.inventory_quantity ?? 0
                
                productMngObj.setValue(localProduct.userEmail, forKey: Constants.userEmailCoraDataAtt)
                productMngObj.setValue(localProduct.productId, forKey: Constants.productIdCoraDataAtt)
                productMngObj.setValue(localProduct.productImageData, forKey: Constants.productImageCoraDataAtt)
                productMngObj.setValue(price, forKey: Constants.productPriceCoraDataAtt)
                productMngObj.setValue(mainCategory, forKey: Constants.mainCategoryCoraDataAtt)
                productMngObj.setValue(titleVal, forKey: Constants.titleCoraDataAtt)
                productMngObj.setValue(size, forKey: Constants.selectedSizeCoraDataAtt)
                productMngObj.setValue(color, forKey: Constants.selectedColorCoraDataAtt)
                productMngObj.setValue(quantity, forKey: Constants.quantityCoraDataAtt)
                productMngObj.setValue(invQuantity, forKey: Constants.invQuantCoraDataAtt)
             
                do{
                    try context.save()
                    print("\naddProductToCart - DataAddedToLocalCART")
                } catch {
                    print("addProductToCart - CATCH WHEN SAVE")
                    completion(false)
                }
                print("\naddProductToCart - DataSavedCART")
                completion(true)
            } else {
                print("\naddProductToCart - product is already in the cart")
                completion(false)
            }
        }
    }
    
    func deleteProductFromCart(localProductDetails: LocalProductDetails, completion: @escaping (Bool) -> Void){
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.cartCoraDataEntity)
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if localProductDetails.userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: Constants.productIdCoraDataAtt){
                            if prodId as! Int == localProductDetails.productId{
                                print("deleteProductFromCart - FOUNDDDDDDDDDD  DLT")
                                context.delete(item)
                                try context.save()
                                print("deleteProductFromCart - DataDeletedFromLocal  DLT")
                                completion(true)
                                return
                            } else {
                                print("id does NOT Match to DLT")
                            }
                        } else {
                            print("failed to get ID to DLT")
                        }
                    } else {
                        print("email does NOT Match to DLT")
                    }
                } else {
                    print("failed to get email to DLT")
                }
            }
        } catch {
            print("deleteProductFromCart - CAAAAAAAAATCHHHHHHHH")
            completion(false)
        }
        print("deleteProductFromCart - did not found to DLT")
        completion(false)
    }
    
    func deleteAllProductFromCart(userEmail: String, completion: @escaping (Bool) -> Void){
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.cartCoraDataEntity)
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if userEmail == uEmail as! String {
                        print("deleteAllProductFromCart - match email")
                        context.delete(item)
                        try context.save()
                        print("deleteProductFromCart - DataDeletedFromLocal  DLT")
                    } else {
                        print("email does NOT Match to DLT")
                    }
                } else {
                    print("failed to get email to DLT")
                }
            }
        } catch {
            print("deleteProductFromCart - CAAAAAAAAATCHHHHHHHH")
            completion(false)
        }
        print("deleteAllProductFromCart - finish")
        completion(true)
    }
    
    func updateCartProduct(type: UpdateType, localProductDetails: LocalProductDetails, completion: @escaping (Bool) -> Void){
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.cartCoraDataEntity)
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if localProductDetails.userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: Constants.productIdCoraDataAtt){
                            if prodId as! Int == localProductDetails.productId{
                                print("updateCartProduct - FOUNDDDDDDDDDD  UPDaTe")
                                switch type {
                                    case .Quantity:
                                        item.setValue(localProductDetails.quantity, forKey: Constants.quantityCoraDataAtt)
                                    case .SizeColor:
                                        item.setValue(localProductDetails.selectedSize, forKey: Constants.selectedSizeCoraDataAtt)
                                        item.setValue(localProductDetails.selectedColor, forKey: Constants.selectedColorCoraDataAtt)
                                }
                                try context.save()
                                print("updateCartProduct -  UPDaTe")
                                completion(true)
                                return
                            } else {
                                print("updateCartProduct - id does NOT Match to UPDaTe")
                            }
                        } else {
                            print("updateCartProduct - failed to get ID to UPDaTe")
                        }
                    } else {
                        print("updateCartProduct - email does NOT Match to UPDaTe")
                    }
                } else {
                    print("updateCartProduct - failed to get email to UPDaTe")
                }
            }
        } catch {
            print("updateCartProduct - CAAAAAAAAATCHHHHHHHH")
            completion(false)
        }
        print("updateCartProduct - did NOT UPDaTe")
        completion(false)
    }
    
    func getAllCartProducts(userEmail: String, completion: @escaping ([LocalProductDetails]?) -> Void){
        var localProductDetails: [LocalProductDetails] = [LocalProductDetails]()
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.cartCoraDataEntity)
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: Constants.productIdCoraDataAtt){
                            print("getAllCartProducts - append product with id => \(prodId as! Int)")
                            
                            let mainCategory = item.value(forKey: Constants.mainCategoryCoraDataAtt) as? String ?? "---"
                            let imgData = item.value(forKey: Constants.productImageCoraDataAtt) as? Data ?? Data()
                            let price = item.value(forKey: Constants.productPriceCoraDataAtt) as? String ?? "--"
                            let titleVal = item.value(forKey: Constants.titleCoraDataAtt) as? String ?? "Product"
                            let sizeVal = item.value(forKey: Constants.selectedSizeCoraDataAtt) as? String ?? "-"
                            let colorVal = item.value(forKey: Constants.selectedColorCoraDataAtt) as? String ?? "-"
                            let quantVal = item.value(forKey: Constants.quantityCoraDataAtt) as? Int ?? 1
                            let invQuantVal = item.value(forKey: Constants.invQuantCoraDataAtt) as? Int ?? 0
                            
                            localProductDetails.append(LocalProductDetails(productId: prodId as! Int, userEmail: userEmail, title: titleVal, productPrice: price, productImageData: imgData, quantity: quantVal, selectedSize: sizeVal, selectedColor: colorVal, mainCategory: mainCategory, inventory_quantity: invQuantVal))
                            
                        } else {
                            print("getAllCartProducts - failed to get ID")
                        }
                    } else {
                        print("getAllCartProducts - email does NOT match")
                    }
                } else {
                    print("getAllCartProducts - Failed to get email")
                }
            }
        } catch {
            print("getAllCartProducts - CAAAAAAAAATCHHHHHHH")
            completion(nil)
        }
        print("getAllCartProducts - Finish Retrive")
        
        if localProductDetails.isEmpty {
            print("getAllCartProducts - Finish Retrive arr is empty")
            completion(nil)
        } else {
            print("getAllCartProducts - Finish Retrive arr fully")
            completion(localProductDetails)
        }
    }
    
    //--------------------------------------------------------Order-----------------------------------------------------------
    
    func addOrder(order: Order, completion: @escaping (Bool) -> Void){
        
        print("addOrder - start adding to Local")
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.ordersCoraDataEntity, in: context)
        let productMngObj = NSManagedObject(entity: entity!, insertInto: context)
        
        print("addOrder - PUT ID => \(order.productId)")
        print("addOrder - PUT img => \(String(describing: order.productImage))")
        print("addOrder - PUT title => \(String(describing: order.title))")
        
        productMngObj.setValue(order.userEmail, forKey: Constants.userEmailCoraDataAtt)
        productMngObj.setValue(order.productId, forKey: Constants.productIdCoraDataAtt)
        productMngObj.setValue(order.productImage, forKey: Constants.productImageCoraDataAtt)
        productMngObj.setValue(order.productPrice, forKey: Constants.productPriceCoraDataAtt)
        productMngObj.setValue(order.title, forKey: Constants.titleCoraDataAtt)
        productMngObj.setValue(order.totalPrice, forKey: Constants.totalPriceCoraDataAtt)
        productMngObj.setValue(order.creationDate, forKey: Constants.creationDateCoraDataAtt)
        productMngObj.setValue(order.quantity, forKey: Constants.quantityCoraDataAtt)
        productMngObj.setValue(order.orderId, forKey: Constants.orderIdCoraDataAtt)

        do{
            try context.save()
            print("\naddOrder - DataAddedToLocal")
        } catch {
            print("addOrder - CATCH WHEN SAVE")
            completion(false)
        }
        print("\naddOrder - DataSavedCART")
        completion(true)
        
    }
    
    func getAllOrdersByEmail(userEmail: String, completion: @escaping ([Order]?) -> Void){
        var ordersArr: [Order] = [Order]()
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.ordersCoraDataEntity)
        do{
            let orders = try context.fetch(fetchReq)
            for item in orders {
                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
                    if userEmail == uEmail as! String {
                        let productId = item.value(forKey: Constants.productIdCoraDataAtt) as? Int ?? 0
                        let img = item.value(forKey: Constants.productImageCoraDataAtt) as? String ?? ""
                        let price = item.value(forKey: Constants.productPriceCoraDataAtt) as? String ?? ""
                        let title = item.value(forKey: Constants.titleCoraDataAtt) as? String ?? ""
                        let quant = item.value(forKey: Constants.quantityCoraDataAtt) as? String ?? ""
                        let totalPrice = item.value(forKey: Constants.totalPriceCoraDataAtt) as? String ?? ""
                        let creationDate = item.value(forKey: Constants.creationDateCoraDataAtt) as? String ?? ""
                        let orderId = item.value(forKey: Constants.orderIdCoraDataAtt) as? Int ?? 0
                        
                        ordersArr.append(Order(productId: productId, userEmail: userEmail, title: title, productPrice: price, productImage: img, quantity: quant, totalPrice: totalPrice, creationDate: creationDate, orderId: orderId))
                    }
                }
            }
        } catch {
            print("getAllCartProducts - CAAAAAAAAATCHHHHHHH")
            completion(nil)
        }
        print("getAllCartProducts - Finish Retrive")
        
        if ordersArr.isEmpty {
            print("getAllCartProducts - Finish Retrive arr is empty")
            completion(nil)
        } else {
            print("getAllCartProducts - Finish Retrive arr fully")
            completion(ordersArr)
        }
    }
    
    func getAllOrdersByOrederId(orderId: Int, completion: @escaping ([Order]?) -> Void){
        var ordersArr: [Order] = [Order]()
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.ordersCoraDataEntity)
        do{
            let orders = try context.fetch(fetchReq)
            for item in orders {
                if let ordId = item.value(forKey: Constants.orderIdCoraDataAtt){
                    if orderId == ordId as! Int {
                        let userEmail = item.value(forKey: Constants.userEmailCoraDataAtt) as? String ?? ""
                        let img = item.value(forKey: Constants.productImageCoraDataAtt) as? String ?? ""
                        let price = item.value(forKey: Constants.productPriceCoraDataAtt) as? String ?? ""
                        let title = item.value(forKey: Constants.titleCoraDataAtt) as? String ?? ""
                        let quant = item.value(forKey: Constants.quantityCoraDataAtt) as? String ?? ""
                        let totalPrice = item.value(forKey: Constants.totalPriceCoraDataAtt) as? String ?? ""
                        let creationDate = item.value(forKey: Constants.creationDateCoraDataAtt) as? String ?? ""
                        let orderId = item.value(forKey: Constants.orderIdCoraDataAtt) as? Int ?? 0
                        
                        ordersArr.append(Order(productId: orderId, userEmail: userEmail, title: title, productPrice: price, productImage: img, quantity: quant, totalPrice: totalPrice, creationDate: creationDate, orderId: orderId))
                    }
                }
            }
        } catch {
            print("getAllCartProducts - CAAAAAAAAATCHHHHHHH")
            completion(nil)
        }
        print("getAllCartProducts - Finish Retrive")
        
        if ordersArr.isEmpty {
            print("getAllCartProducts - Finish Retrive arr is empty")
            completion(nil)
        } else {
            print("getAllCartProducts - Finish Retrive arr fully")
            completion(ordersArr)
        }
    }
    
    
}






/*

 //    func getAllOrders(getByType: GetOrderType, getByString: String, completion: @escaping ([Order]?) -> Void){
 //        var ordersArr: [Order] = [Order]()
 //
 //        let appDelegte = UIApplication.shared.delegate as? AppDelegate
 //        let context = appDelegte!.persistentContainer.viewContext
 //        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: Constants.ordersCoraDataEntity)
 //        do{
 //            let orders = try context.fetch(fetchReq)
 //            for item in orders {
 //
 //
 //                switch getByType {
 //                case .UserEmail:
 //                    if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
 //                        if getByString == uEmail as! String {
 //                            productMngObj.setValue(order.orderId, forKey: Constants.orderIdCoraDataAtt)
 //
 //                        }
 //                    }
 //                case .OrderID:
 //                    if let orderId = item.value(forKey: Constants.orderIdCoraDataAtt){
 //                        if getByString == orderId as! String {
 //
 //                        }
 //                    }
 //                }
 //
 //
 //                if let uEmail = item.value(forKey: Constants.userEmailCoraDataAtt){
 //                        let userEmail = item.value(forKey: Constants.userEmailCoraDataAtt) as? String ?? ""
 //                        let productId = item.value(forKey: Constants.productIdCoraDataAtt) as? Int ?? 0
 //                        let img = item.value(forKey: Constants.productImageCoraDataAtt) as? String ?? ""
 //                        let price = item.value(forKey: Constants.productPriceCoraDataAtt) as? String ?? ""
 //                        let title = item.value(forKey: Constants.titleCoraDataAtt) as? String ?? ""
 //                        let quant = item.value(forKey: Constants.quantityCoraDataAtt) as? String ?? ""
 //                        let totalPrice = item.value(forKey: Constants.totalPriceCoraDataAtt) as? String ?? ""
 //                        let creationDate = item.value(forKey: Constants.creationDateCoraDataAtt) as? String ?? ""
 //                        let orderId = item.value(forKey: Constants.orderIdCoraDataAtt) as? Int ?? 0
 //
 //                        ordersArr.append(Order(productId: productId, userEmail: userEmail, title: title, productPrice: price, productImage: img, quantity: quant, totalPrice: totalPrice, creationDate: creationDate, orderId: orderId))
 //
 //                } else {
 //                    print("getAllCartProducts - Failed to get email")
 //                }
 //            }
 //        } catch {
 //            print("getAllCartProducts - CAAAAAAAAATCHHHHHHH")
 //            completion(nil)
 //        }
 //        print("getAllCartProducts - Finish Retrive")
 //
 //        if localProductDetails.isEmpty {
 //            print("getAllCartProducts - Finish Retrive arr is empty")
 //            completion(nil)
 //        } else {
 //            print("getAllCartProducts - Finish Retrive arr fully")
 //            completion(localProductDetails)
 //        }
 //    }
     
 */
