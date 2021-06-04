//
//  ApplicationAPI.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 5/23/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import Alamofire

enum ApplicationNetworking{
    // MARK: Ahmed Section
    
    case getProductDetails(id:String)
    
    //end
    
    // MARK: Amr Section
    
    //end
    
    
    // MARK: Ayman Section
    
    //end
    
    
    // MARK: Marwa Section
    case allWomenProduct
    case allMenProduct
    case allKidsProduct
    case discountCode
    //end
}

extension ApplicationNetworking : TargetType{
    var baseURL: String {
        switch self{
        default:
            return Constants.baseURL
        }
    }
    
    var path: String {
        switch self{
            // MARK: Ahmed Section
            case .getProductDetails(let id):
                return Constants.prductDetails + id + Constants.endPath
            //end
            
            // MARK: Amr Section
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            case .allWomenProduct :
                return Constants.allWomenProduct
            case .allMenProduct:
                return Constants.allMenProduct
            case .allKidsProduct:
                return Constants.allKidsProduct
            case .discountCode:
                return Constants.discountCode
            //end
            
        
        
       
       
        }
    }
    
    var method: HTTPMethod {
        switch self{
            // MARK: Ahmed Section
            
            case .getProductDetails:
                return .get
            //end
            
            // MARK: Amr Section
            
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            case .allWomenProduct:
                 return .get
            case .allMenProduct:
                return .get
            case .allKidsProduct:
                return .get
            case .discountCode:
                return .get
            //end
       
        
        
        }
    }
    
    var task: Task {
        switch self{
            // MARK: Ahmed Section
            case .getProductDetails:
                return .requestPlain
            //end
            
            // MARK: Amr Section
            
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            case .allWomenProduct:
                return.requestPlain
            case .allMenProduct:
                return .requestPlain
            case .allKidsProduct:
                return .requestPlain
           case .discountCode:
            return.requestPlain
        }
            //end
        
    }
    var headers: [String : String]? {
        switch self{
        default:
            return ["X-Shopify-Access-Token":"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"]
        }
    }
    
//    var headers: [String : String]? {
//        switch self{
//        default:
//            return [:]
//        }
//    }
}


