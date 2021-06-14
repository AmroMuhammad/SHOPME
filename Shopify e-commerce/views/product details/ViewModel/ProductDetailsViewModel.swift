//
//  ProductDetailsViewModel.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 03/06/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class ProductDetailsViewModel: ProductDetailsViewModelType {
    
    private var productObject: ProductDetails?
    private var productMainCategory: String = "Men"
    
    
    var imagesObservable: Observable<[ProductDetailsImage]>
    var colorsObservable: Observable<[UIColor]>
    var sizesObservable: Observable<[String]>
    var productTitleObservable: Observable<String>
    var productPriceObservable: Observable<String>
    var productVendorObservable: Observable<String>
    var productDescriptionObservable: Observable<String>
    
    private var imagesSubject = PublishSubject<[ProductDetailsImage]>()
    private var colorsSubject = PublishSubject<[UIColor]>()
    private var sizesSubject = PublishSubject<[String]>()
    private var productTitleSubject = PublishSubject<String>()
    private var productPriceSubject = PublishSubject<String>()
    private var productVendorSubject = PublishSubject<String>()
    private var productDescriptionSubject = PublishSubject<String>()
    
    var quantutyObservable: Observable<String>
    private var quantitySubject = PublishSubject<String>()
    var currencyObservable: Observable<String>
    private var currencySubject = PublishSubject<String>()
    var userCityObservable: Observable<String>
    private var userCitySubject = PublishSubject<String>()

//    var favoriteProductsObservable: Observable<[LocalProductDetails]>
//    private var favoriteProductsSubject = PublishSubject<[LocalProductDetails]>()
//    var cartProductsObservable: Observable<[LocalProductDetails]>
//    private var cartProductsSubject = PublishSubject<[LocalProductDetails]>()
    

    var checkProductInFavoriteObservable: Observable<Bool>
    private var checkProductInFavoriteSubject = PublishSubject<Bool>()
    var checkProductInCartObservable: Observable<(Bool, (String, Int), (UIColor, Int))>
    private var checkProductInCartSubject = PublishSubject<(Bool, (String, Int), (UIColor, Int))>()
//    var checkProductInCartWithObjectObservable: Observable<LocalProductDetails?>
//    private var checkProductInCartWithObjectSubject = PublishSubject<LocalProductDetails?>()
    
    
    var showErrorObservable: Observable<[String]>
    private var showErrorSubject = PublishSubject<[String]>()
    var showLoadingObservable: Observable<Bool>
    private var showLoadingSubject = PublishSubject<Bool>()
    var showToastObservable: Observable<String>
    private var showToastSubject = PublishSubject<String>()
    var connectivityObservable: Observable<Bool>
    private var connectivitySubject = PublishSubject<Bool>()
    
    private var shopifyAPI: ShopifyAPI!
    private var localManager: LocalManagerHelper!
    private var userData: UserData!
    
    
    init() {
        imagesObservable = imagesSubject.asObservable()
        colorsObservable = colorsSubject.asObservable()
        sizesObservable = sizesSubject.asObservable()
        productTitleObservable = productTitleSubject.asObservable()
        productPriceObservable = productPriceSubject.asObservable()
        productVendorObservable = productVendorSubject.asObservable()
        productDescriptionObservable = productDescriptionSubject.asObservable()
        quantutyObservable = quantitySubject.asObservable()
        currencyObservable = currencySubject.asObservable()
        userCityObservable = userCitySubject.asObservable()
        
//        favoriteProductsObservable = favoriteProductsSubject.asObservable()
//        cartProductsObservable = cartProductsSubject.asObservable()
        
        
        checkProductInFavoriteObservable = checkProductInFavoriteSubject.asObservable()
        checkProductInCartObservable = checkProductInCartSubject.asObservable()
//        checkProductInCartWithObjectObservable = checkProductInCartWithObjectSubject.asObservable()

        
        showErrorObservable = showErrorSubject.asObservable()
        showLoadingObservable = showLoadingSubject.asObservable()
        showToastObservable = showToastSubject.asObservable()
        connectivityObservable = connectivitySubject.asObservable()
        
        shopifyAPI = ShopifyAPI.shared
        localManager = LocalManagerHelper.localSharedInstance
        userData = UserData.sharedInstance
    }
    
    
    
    
    private func getMainCategory() -> String {
        return productMainCategory
    }
    private func getInventoryQuantityOfProductSize(productObject: ProductDetails, selectedSize: String?) -> Int? {
        let variantsArr = productObject.variants ?? []
        for item in variantsArr {
            if item.option1 == selectedSize {
                return item.inventory_quantity
            }
        }
        return 0
    }
    
    //----------------------------------------User Defaults------------------------------------------------
    func getLocalData() {
        let city = userData.getUserFromUserDefaults().addresses?[0]?.city ?? "Giza"
        let country = userData.getUserFromUserDefaults().addresses?[0]?.country ?? "Egypt"
        userCitySubject.onNext(city+", "+country)
        currencySubject.onNext(userData.getCurrency())
    }
    
    private func getUserEmail() -> String {
        let userEmail = userData.getUserFromUserDefaults().email ?? ""
        return userEmail
    }
    
    
    
    //----------------------------------------check Local------------------------------------------------
    
    private func checkIfFavorite(){
//        showLoadingSubject.onNext(true)
        print("VM B4 checkIfFavorite \(String(describing: productObject?.id))")
        if let productObj = productObject{
            localManager.checkProduct(entityName: .FavoriteProducts, userEmail: getUserEmail(), productId: productObj.id) { [weak self] (_, resBool) in
                guard let self = self else {return}
//                self.showLoadingSubject.onNext(true)
                self.checkProductInFavoriteSubject.onNext(resBool)
            }
        }
//        showLoadingSubject.onNext(true)
    }
    
    func checkIfCart(){
//        showLoadingSubject.onNext(true)
        print("VM B4 checkIfCart \(String(describing: productObject?.id))")
        if let productObj = productObject{
            localManager.checkProduct(entityName: .CartProducts, userEmail: getUserEmail(), productId: productObj.id) { [weak self] (product, resBool) in
                guard let self = self else {return}
//                self.showLoadingSubject.onNext(false)
                if product != nil {
                    print("VM checkIfCart Found Successfully ")
                    self.checkProductInCartSubject.onNext((resBool, self.getSize(localProduct: product!), self.getColor(localProduct: product!)))
                } else {
                    self.checkProductInCartSubject.onNext((resBool, ("", 0), (UIColor.white, 0)))
                }
            }
        }
//        showLoadingSubject.onNext(false)
    }
    
    private func getSize(localProduct: LocalProductDetails) -> (String, Int) {
        
        if let size = localProduct.selectedSize{
            if let sizesArr = productObject?.options?[0].values {
                var counter = 0
                for item in sizesArr {
                    if size == item {
                        print("\n\n\nVM - getSize - \(size) & \(counter)\n\n")
                        return (size, counter)
                    }
                    counter += 1
                }
            }
        }
        print("\n\n\nVM - getSize - NIL\n\n")
        return ("", 0)
    }
    
    private func getColor(localProduct: LocalProductDetails) -> (UIColor, Int) {
        
        if let color = localProduct.selectedColor{
            if let colorsArr = productObject?.options?[1].values {
                var counter = 0
                for item in colorsArr {
                    if color == item {
                        print("\n\n\nVM - getSize - \(color) & \(counter)\n\n")
                        
                        return (mapToColors(colorsNames: [color])[0], counter)
                    }
                    counter += 1
                }
            }
        }
        print("\n\n\nVM - getColor - NIL\n\n")
        return (UIColor.white, 0)
    }
    
    //----------------------------------------Favorite------------------------------------------------
    func addTofavorite(){
        var imgData: Data!
        if let productObj = productObject{
            if let productImg = productObj.image?.src {
                print("VM addTofavorite B44  dataImage => \(String(describing: imgData))")
                let url = URL(string: productImg)
                DispatchQueue.global(qos: .background).sync {
                    do{
                        let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        imgData = data
                        print("VM addTofavorite dataImage has value => \(String(describing: imgData))")
                    } catch {
                        imgData = Data()
                        print("VM addTofavorite dataImage CATCH => \(String(describing: imgData))")
                    }
                }
            } else {
                imgData = Data()
                print("VM addTofavorite dataImage Empty => \(String(describing: imgData))")
            }
            print("VM addTofavorite id => \(productObj.id)")
            
            localManager.addProductToFavorite(localProduct: LocalProductDetails(productId: productObj.id, userEmail: getUserEmail(), title: productObj.title, productPrice: productObj.variants?[0].price, productImageData: imgData, quantity: nil, selectedSize: nil, selectedColor: nil, mainCategory: getMainCategory(), inventory_quantity: nil)) { [weak self] (resBool) in
                guard let self = self else {return}
                if resBool {
                    self.showToastSubject.onNext("Data added successfuly")
                } else {
//                    self.showErrorSubject.onNext(["Oops :(", "We're sorry, but can't add this product. Please try again."])
                    //comment this cause it need to handle and make heart did NOT fill
                }
            }
        } else {
            print("VM addTofavorite => CAN NOT ADD TO FAVORITE !!!")
            showErrorSubject.onNext(["Oops :(", "We're sorry, but can't add this product. Please try again."])
        }
    }
    
    func removefromFavorite(){
        if let productObj = productObject{
            print("VM addTofavorite id => \(productObj.id)")
            localManager.deleteProductFromFavorite(localProductDetails: LocalProductDetails(productId: productObj.id, userEmail: getUserEmail(), title: nil, productPrice: nil, productImageData: Data(), quantity: nil, selectedSize: nil, selectedColor: nil, mainCategory: nil, inventory_quantity: nil)) { (_) in
//                guard let self = self else {return}
//                if resBool {
//
//                } else {
//                    print("product has NOT been deleted")
//                    self.showErrorSubject.onNext(["Oops :(", "We're sorry, but can't remove this product from favorite. Please try again."])
//                }
            }
        }
//        else {
//            print("VM addTofavorite => CAN NOT REMOVE FROM FAVORITE !!!")
//        }
    }
    
    //------------------------------------------------CART------------------------------------------------
    
    func addToCart(selectedSize: String?, selectedColor: UIColor?){
        var imgData: Data!
        if let productObj = productObject{
            if let productImg = productObj.image?.src {  // (if let) useless?
                print("VM addToCart B44  dataImage => \(String(describing: imgData))")
                let url = URL(string: productImg)
                DispatchQueue.global(qos: .background).sync {
                    do {
                        let data = try Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        imgData = data
                        print("VM addToCart dataImage has value => \(String(describing: imgData))")
                    } catch {
                        imgData = Data()
                    }
                }
            } else {
                imgData = Data()
                print("VM addToCart dataImage Empty => \(String(describing: imgData))")
            }
            print("VM addToCart id => \(productObj.id)")
            
            localManager.addProductToCart(localProduct: LocalProductDetails(productId: productObj.id, userEmail: getUserEmail(), title: productObj.title, productPrice: productObj.variants?[0].price, productImageData: imgData, quantity: 1, selectedSize: selectedSize, selectedColor: mapFromColor(color: selectedColor), mainCategory: getMainCategory(), inventory_quantity: getInventoryQuantityOfProductSize(productObject: productObj, selectedSize: selectedSize))) { [weak self] (resBool) in
                guard let self = self else {return}
                if resBool {
                    self.showToastSubject.onNext("Data added successfuly")
                } else {
                    self.showErrorSubject.onNext(["Oops :(", "We're sorry, but can't add this product. Please try again."])
                }
            }
        } else {
            print("VM addToCart => CAN NOT ADD TO CART !!!")
            showErrorSubject.onNext(["Oops :(", "We're sorry, but can't add this product. Please try again."])
        }
    }

    func getCartQuantity() {
        localManager.getAllCartProducts(userEmail: getUserEmail()) { [weak self] (localProductsArr) in
            guard let self = self else {return}
            var allQuantity = 0
            if let localArr = localProductsArr {
                for item in localArr {
                    allQuantity += item.quantity ?? 0
                }
            }
            self.quantitySubject.onNext(String(allQuantity))
        }
    }
    
    private func mapFromColor(color: UIColor?) -> String {
        var clr: String = ""
        print("from COLOR MAPPINGGGGGGG")
            switch color {
            case UIColor.black:
                clr = "black"
            case UIColor.blue:
                clr = "blue"
            case UIColor.white:
                clr = "white"
            case UIColor.yellow:
                clr = "yellow"
            case UIColor.red:
                clr = "red"
            case #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.862745098, alpha: 1):
                clr = "beige"
            case #colorLiteral(red: 0.7098039216, green: 0.3960784314, blue: 0.1137254902, alpha: 1):
                clr = "light_brown"
            case #colorLiteral(red: 0.5019607843, green: 0, blue: 0.1254901961, alpha: 1):
                clr = "burgandy"
            default:
                clr = "white"
            }
        return clr
    }

    //------------------------------------------------API------------------------------------------------
    
    private func checkConnectivity() -> Bool {
        if(Connectivity.isConnectedToInternet){
            connectivitySubject.onNext(true)
            return true
        }
        connectivitySubject.onNext(false)
        return false
    }
    
    func getProductDetails(id: String, mainCategory: String?){
        if checkConnectivity(){
            showLoadingSubject.onNext(true)
            shopifyAPI.getProductDetails(productId: id) { [weak self] (result) in
                guard let self = self else {return}
                switch(result){
                case .success(let product):
                    self.showLoadingSubject.onNext(false)
                    print("VM getProductDetails => id => \(product?.product.id ?? 707)")
                    if let productResponse = product {
                        self.productMainCategory = mainCategory ?? "Men"
                        self.filterData(product: productResponse.product)
                        self.productObject = product?.product
                        self.checkIfFavorite()
                        self.checkIfCart()
                    }
                case .failure(let err):
                    self.showLoadingSubject.onNext(false)
                    self.showErrorSubject.onNext(["Oops :(","We're sorry, but something went wrong. Please try again."])
                    print("\n\n\n\n errrrr => \(err.localizedDescription) \nEND\n\n\n\n")
                }
            }
        }
    }
    
    private func filterData(product: ProductDetails) {
        if let imgsArr = product.images {
            imagesSubject.onNext(imgsArr)
        }
        if let productName = product.title {
            productTitleSubject.onNext(productName)
        }
        if let productPrice = product.variants?[0].price {
            productPriceSubject.onNext(productPrice)
        }
        if let productVendor = product.vendor {
            productVendorSubject.onNext(productVendor)
        }
        if let productDescription = product.body_html {
            productDescriptionSubject.onNext(productDescription)
        }
        if let optionsArr = product.options {
            for option in optionsArr {
                if option.name == "Color" {
                    if let clrsArr = option.values{
                        print("COLOR DIDSET")
                        colorsSubject.onNext(mapToColors(colorsNames: clrsArr))
                        print("COLOR \(clrsArr)")
                    }
                    break
                }
            }
        }
        if let sizeArr = product.options {
            for option in sizeArr {
                if option.name == "Size" {
                    if let sizesArr = option.values{
                        print("SIZE DIDSET")
                        sizesSubject.onNext(sizesArr)
                        print("SIZE \(sizesArr)")
                    }
                    break
                }
            }
        }
    }
    
    private func mapToColors(colorsNames: [String]) -> [UIColor] {
        var arrClr: [UIColor] = []
        print("COLOR MAPPINGGGGGGG")
        for clr in colorsNames {
            switch clr {
            case "black":
                arrClr.append(UIColor.black)
            case "blue":
                arrClr.append(UIColor.blue)
            case "white":
                arrClr.append(UIColor.white)
            case "yellow":
                arrClr.append(UIColor.yellow)
            case "red":
                arrClr.append(UIColor.red)
            case "beige":
                arrClr.append(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.862745098, alpha: 1))
            case "light_brown":
                arrClr.append(#colorLiteral(red: 0.7098039216, green: 0.3960784314, blue: 0.1137254902, alpha: 1))
            case "burgandy":
                arrClr.append(#colorLiteral(red: 0.5019607843, green: 0, blue: 0.1254901961, alpha: 1))
            default:
                arrClr.append(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            }
        }
        return arrClr
    }
    
}
