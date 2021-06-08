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
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    func saveImage(data: Data) {
//        let imageInstance = Image(context: context)
//        imageInstance.img = data
//        do {
//            try context.save()
//            print("Image is saved")
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    func checkProduct(userEmail: String, productId: String, entityName: EntityName, completion: @escaping (Bool) -> Void) { //check if exist
        print("LocMng - checkData - \(productId)")
        let appDelegte: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        print("LocMng - checkData - appDelegte")
        let context = appDelegte.persistentContainer.viewContext
        print("LocMng - checkData - context")
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)     /// ? ? ? ? ? ? ? ? ? ? ? ? *** * * **||||\\\\////******
        print("LocMng - checkData - fetchReq")
        do{
            let products = try context.fetch(fetchReq)
            print("LocMng - checkData - context.fetch")
            for item in products {
                print("LocMng - checkData - for item ")
                if let uEmail = item.value(forKey: "userEmail"){
                    if userEmail == uEmail as! String {
                        if let prod = item.value(forKey: "productId"){
                            if prod as! String == productId {
                                print("FOUNDDDDDDDDDD")
                                completion(true)
                                //                        break
                                return                          //???????
                            } else {
                                print("LOC MNGR  - CHK \(entityName.rawValue)  -- not match")
                            }
                        } else {
                            print("LOC MNGR  - CHK \(entityName.rawValue) -- Failed to get id")
                        }
                    } else {
                        print("LOC MNGR  - CHK \(entityName.rawValue)  -- email Not match")
                    }
                } else {
                    print("LOC MNGR  - CHK \(entityName.rawValue) -- Failed to get email")
                }
            }
                     //???????????  line: 63
        } catch {
            print("CAAAAAAAAATCHHHHHHHH from entity => \(entityName.rawValue) ")
        }
        completion(false)
    }
    
    //----------------------------------------------FAVORITE--------------------------------------------------------
    func addProductToFavorite(favoriteProduct: FavoriteProduct, completion: @escaping (Bool) -> Void){
        
        print("start addToLocal in Local Manager")
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteProducts", in: context)
        let productMngObj = NSManagedObject(entity: entity!, insertInto: context)
        
        print("PUT imgData => \(String(describing: favoriteProduct.productImageData))")
        
        productMngObj.setValue(favoriteProduct.userEmail, forKey: "userEmail")
        productMngObj.setValue(favoriteProduct.productId, forKey: "productId")
        productMngObj.setValue(favoriteProduct.productPrice, forKey: "productPrice")
        productMngObj.setValue(favoriteProduct.productImageData, forKey: "productImage")
        
        do{
            try context.save()
            print("\nDataAddedToLocal")
            
        } catch {
            print("CATCH WHEN SAVE")
            completion(false)
            
        }
        print("\nDataSaved")
        completion(true)
    }
   
    func getAllProductsFromFavorite(userEmail: String, completion: @escaping (Result<[FavoriteProduct]?, NSError>) -> Void){
        
        var favoriteProducts: [FavoriteProduct]? = [FavoriteProduct]()
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "FavoriteProducts")
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: "userEmail"){
                    if userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: "productId"){
                            print("GET id => \(prodId as! Int)")
                            var price = "--"
                            var imgData = Data()
                            if let productPrice = item.value(forKey: "productPrice"){
                                print("GET price => \(productPrice as! String)")
                                price = productPrice as! String
                                if let productImageData = item.value(forKey: "productImage"){
                                    imgData = productImageData as! Data
                                    print("GET imgData => \(productImageData)")
                                    
                                } else {
                                    print("empty IMAGE  GET")
                                }
                            } else {
                                print("empty PRICE  GET")
                            }
                            
                            favoriteProducts?.append(FavoriteProduct(productId: prodId as! Int, productPrice: price, productImageData: imgData, userEmail: userEmail))
                            
                        } else {
                            print("empty ID  GET")
                            completion(.failure(NSError.init(domain: "", code: 707, userInfo: [NSLocalizedDescriptionKey : "Can NOT get product id"])))
                        }
                    } else {
                        print("email does NOT match")
                    }
                } else {
                    print("Failed to get email")
                }
            }
        } catch (let err) {
            print("CAAAAAAAAATCHHHHHHHH  GET \(err.localizedDescription)")
            completion(.failure(err as NSError))
        }
        print("Finish Retrive  GET")
        completion(.success(favoriteProducts))
    }
    
    
    func deleteProductFromFavorite(favoriteProduct: FavoriteProduct, completion: @escaping (Bool) -> Void){
        var res = false
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "FavoriteProducts")
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: "userEmail"){
                    if favoriteProduct.userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: "productId"){
                            if prodId as! Int == favoriteProduct.productId{
                                print("FOUNDDDDDDDDDD  DLT")
                                context.delete(item)
                                try context.save()
                                print("DataDeletedFromLocal  DLT")
                                res = true
                                break
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
            print("CAAAAAAAAATCHHHHHHHH  DLT")
//            completion(false)                   //
        }
        print("Finish Removing  DLT")
        completion(res)
    }
    
    
    //--------------------------------------------------------CART-----------------------------------------------------------
    func addProductToCart(cartObj: CartProduct, completion: @escaping (Bool) -> Void){
        
        print("start addToLocal in Local Manager")
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CartProducts", in: context)
        let productMngObj = NSManagedObject(entity: entity!, insertInto: context)
        
        print("PUT ID => \(cartObj.productId)")
        print("PUT imgData => \(String(describing: cartObj.productImageData))")
        
        productMngObj.setValue(cartObj.userEmail, forKey: "userEmail")
        productMngObj.setValue(cartObj.productId, forKey: "productId")
        productMngObj.setValue(cartObj.productPrice, forKey: "productPrice")
        productMngObj.setValue(cartObj.productImageData, forKey: "productImage")
        productMngObj.setValue(cartObj.title, forKey: "title")
        productMngObj.setValue(cartObj.selectedColor, forKey: "selectedColor")
        productMngObj.setValue(cartObj.selectedSize, forKey: "selectedSize")
        productMngObj.setValue(cartObj.quantity, forKey: "quantity")
        
        do{
            try context.save()
            print("\nDataAddedToLocalCART")
        } catch {
            print("CATCH WHEN SAVE")
            completion(false)
        }
        print("\nDataSavedCART")
        
        completion(true)
    }
    
    func deleteProductFromCart(cartObj: CartProduct, completion: @escaping (Bool) -> Void){
        var res = false
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "CartProducts")
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: "userEmail"){
                    if cartObj.userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: "productId"){
                            if prodId as! Int == cartObj.productId{
                                print("FOUNDDDDDDDDDD  DLT")
                                context.delete(item)
                                try context.save()
                                print("DataDeletedFromLocal  DLT")
                                res = true
                                break
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
            print("CAAAAAAAAATCHHHHHHHH  DLT")
//            completion(false)
        }
        print("Finish Removing  DLT")
        completion(res)
    }
    
    func updateCartProduct(cartObj: CartProduct, completion: @escaping (Bool) -> Void){
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "CartProducts")
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: "userEmail"){
                    if cartObj.userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: "productId"){
                            if prodId as! Int == cartObj.productId{
                                print("FOUNDDDDDDDDDD  UPDaTe")
                                
                                item.setValue(cartObj.quantity, forKey: "quantity")
                                try context.save()
                                print("DataDeletedFromLocal  UPDaTe")
                                completion(true)
                                return
                            } else {
                                print("id does NOT Match to UPDaTe")
                            }
                        } else {
                            print("failed to get ID to UPDaTe")
                        }
                    } else {
                        print("email does NOT Match to UPDaTe")
                    }
                } else {
                    print("failed to get email to UPDaTe")
                }
            }
        } catch {
            print("CAAAAAAAAATCHHHHHHHH  UPDaTe")
            //            completion(false)
        }
        print("Finish UPDaTe")
        completion(false)
    }
    
    func getAllCartProducts(userEmail: String, completion: @escaping (Result<[CartProduct]?, NSError>) -> Void){
        var cartProducts: [CartProduct]? = [CartProduct]()
        
        let appDelegte = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegte!.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "CartProducts")
        do{
            let products = try context.fetch(fetchReq)
            for item in products {
                if let uEmail = item.value(forKey: "userEmail"){
                    if userEmail == uEmail as! String {
                        if let prodId = item.value(forKey: "productId"){
                            print("GET id => \(prodId as! Int)")
                            var price = "--"
                            var imgData = Data()
                            var titl = ""
                            var siz = ""
                            var clr = ""
                            var qunt = 0
                            if let productPrice = item.value(forKey: "productPrice"){
                                print("GET price => \(productPrice as! String)")
                                price = productPrice as! String
                                if let productImageData = item.value(forKey: "productImage"){
                                    imgData = productImageData as! Data
                                    print("GET imgData => \(productImageData)")
                                    if let title = item.value(forKey: "title"){
                                        titl = title as! String
                                        if let size = item.value(forKey: "selectedSize"){
                                            siz = size as! String
                                            if let color = item.value(forKey: "selectedColor"){
                                                clr = color as! String
                                                if let quatity = item.value(forKey: "quantity"){
                                                    qunt = quatity as! Int
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            cartProducts?.append(CartProduct(productId: prodId as! Int, productPrice: price, productImageData: imgData, userEmail: userEmail, title: titl, selectedSize: siz, selectedColor: clr, quantity: qunt))
                            completion(.success(cartProducts))
                            return
                        }
                    } else {
                        print("email does NOT Match to DLT")
                    }
                } else {
                    print("failed to get email to DLT")
                }
            }
        } catch (let err) {
            print("CAAAAAAAAATCHHHHHHHH  GET \(err.localizedDescription)")
            completion(.failure(err as NSError))
//            return                                                              // ???????
        }
       
        completion(.failure(NSError.init(domain: "", code: 707, userInfo: [NSLocalizedDescriptionKey : "Can NOT get product id"])))
       
        print("Finish Retrive  GET")
        
    }
    
}
    









//    func getData(productId: String) -> (ProductDetails?, Data?) {
//
//        var imageData = Data()
//        var productObj: ProductDetails?
//        var variants = [ProductDetailsVariants]()
//
//        let appDelegte = UIApplication.shared.delegate as? AppDelegate
//        let context = appDelegte!.persistentContainer.viewContext
//        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "FavoriteProducts")
//        do{
//            let products = try context.fetch(fetchReq)
//            for item in products {
//                if let prodId = item.value(forKey: "productId"){
//                    print("GET id => \(prodId as! Int)")
//                    if let productPrice = item.value(forKey: "productPrice"){
//                        print("GET price => \(productPrice as! String)")
//                        if let productImageData = item.value(forKey: "productImage"){
//
////       ******                     if productId == prodId as! String {
////***
////   * *****                        }
//                            imageData = productImageData as! Data
//                            print("GET imgData => \(imageData)")
//                            let variant = ProductDetailsVariants(id: 70, product_id: nil, price: productPrice as? String)
//                            variants.append(variant)
//
//                            productObj = ProductDetails(id: prodId as! Int, title: nil, vendor: nil, product_type: nil, handle: nil, status: nil, tags: nil, variants: variants, options: nil, images: nil, image: nil)
//
//
////                                leaguesArr.append(Country(idLeague: leagueId as? String, idAPIfootball: nil, strSport: nil, strLeague: leagueName as? String, strLeagueAlternate: nil, strDivision: nil, idCup: nil, strCurrentSeason: nil, intFormedYear: nil, dateFirstEvent: nil, strGender: nil, strCountry: nil, strWebsite: nil, strFacebook: nil, strTwitter: nil, strYoutube: youtubeStr as? String, strRSS: nil, strDescriptionEN: nil, strBadge: leagueBadge as? String, strNaming: nil, strLocked: nil))
//
//                        } else {
//                            print("empty IMAGE  GET")
//                        }
//                    } else {
//                        print("empty PRICE  GET")
//                    }
//                } else {
//                    print("empty ID  GET")
//                }
//            }
//        } catch (let err) {
//            print("CAAAAAAAAATCHHHHHHHH  GET \(err.localizedDescription)")
////            delegate.onFailure(errorMessage: err.localizedDescription)
//        }
//        print("Finish Retrive  GET")
//        return (productObj, imageData)
////        delegate.onSuccess(leagues: leaguesArr)
//    }




/*
 var prdObjj: ProductDetails?
 
 let appDelegte = UIApplication.shared.delegate as? AppDelegate
 let context = appDelegte!.persistentContainer.viewContext
 let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "FavoriteLeagues")
 do{
     let leagues = try context.fetch(fetchReq)
     for item in leagues {
         if let leagueId = item.value(forKey: "leagueId"){
             if let leagueName = item.value(forKey: "leagueName"){
                 if let leagueBadge = item.value(forKey: "leagueBadge"){
                     if let youtubeStr = item.value(forKey: "youtubeStr"){
                         leaguesArr.append(Country(idLeague: leagueId as? String, idAPIfootball: nil, strSport: nil, strLeague: leagueName as? String, strLeagueAlternate: nil, strDivision: nil, idCup: nil, strCurrentSeason: nil, intFormedYear: nil, dateFirstEvent: nil, strGender: nil, strCountry: nil, strWebsite: nil, strFacebook: nil, strTwitter: nil, strYoutube: youtubeStr as? String, strRSS: nil, strDescriptionEN: nil, strBadge: leagueBadge as? String, strNaming: nil, strLocked: nil))
                     } else {
                         print("empty YOUTUBE  GET")
                     }
                 } else {
                     print("empty BADEG  GET")
                 }
             } else {
                 print("empty NAME  GET")
             }
         } else {
             print("empty ID  GET")
         }
     }
 } catch (let err) {
     print("CAAAAAAAAATCHHHHHHHH  GET")
     delegate.onFailure(errorMessage: err.localizedDescription)
 }
 print("Finish Retrive  GET")
 
 delegate.onSuccess(leagues: leaguesArr)
 */

/*
 func addData(leagueId: String, leagueCountry: Country) {              // response WHEN onSuccess or Fail  (missing)
     print("start addToLocal in Presenter")
     let appDelegte = UIApplication.shared.delegate as? AppDelegate
     let context = appDelegte!.persistentContainer.viewContext
     let entity = NSEntityDescription.entity(forEntityName: "FavoriteLeagues", in: context)
     let leagueMngObj = NSManagedObject(entity: entity!, insertInto: context)
 
     leagueMngObj.setValue(leagueId, forKey: "leagueId")
     leagueMngObj.setValue(leagueCountry.strLeague ?? "League", forKey: "leagueName")
     leagueMngObj.setValue(leagueCountry.strBadge, forKey: "leagueBadge")
     leagueMngObj.setValue(leagueCountry.strYoutube ?? "", forKey: "youtubeStr")
     
     do{
         try context.save()
         print("\nDataAddedToLocal")
     } catch {
         print("CATCH WHEN SAVE")
     }
     print("\nDataSaved")
 }
 */


/*

 //    func addData(product: ProductDetails, imageData: Data?) {              // response WHEN onSuccess or Fail  (missing)
 //        print("start addToLocal in Local Manager")
 //        let appDelegte = UIApplication.shared.delegate as? AppDelegate
 //        let context = appDelegte!.persistentContainer.viewContext
 //        let entity = NSEntityDescription.entity(forEntityName: "FavoriteProducts", in: context)
 //        let productMngObj = NSManagedObject(entity: entity!, insertInto: context)
 //
 //        print("PUT imgData => \(String(describing: imageData))")
 //
 //        productMngObj.setValue(product.id, forKey: "productId")
 //        productMngObj.setValue(product.variants?[0].price ?? "--", forKey: "productPrice")
 //        productMngObj.setValue(imageData, forKey: "productImage")
 //
 //        do{
 //            try context.save()
 //            print("\nDataAddedToLocal")
 //        } catch {
 //            print("CATCH WHEN SAVE")
 //        }
 //        print("\nDataSaved")
 //    }
     
 */
