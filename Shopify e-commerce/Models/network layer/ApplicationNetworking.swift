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
    
    //end
    
    // MARK: Amr Section
    case getMenCategoryProducts
    case getWomenCategoryProducts
    case getKidsCategoryProducts

    //end
    
    
    // MARK: Ayman Section
    
    //end
    
    
    // MARK: Marwa Section
    
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
            
            //end
            
            // MARK: Amr Section
            case .getMenCategoryProducts:
                return Constants.menCatPath
            case .getWomenCategoryProducts:
                return Constants.womenCatPath
            case .getKidsCategoryProducts:
                return Constants.kidCatPath
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            
            //end
            
        }
    }
    
    var method: HTTPMethod {
        switch self{
            // MARK: Ahmed Section
            
            //end
            
            // MARK: Amr Section
            case .getMenCategoryProducts:
                return .get
            case .getWomenCategoryProducts:
                return .get
            case .getKidsCategoryProducts:
                return .get
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            
            //end
        
        }
    }
    
    var task: Task {
        switch self{
            // MARK: Ahmed Section
            
            //end
            
            // MARK: Amr Section
            case .getMenCategoryProducts:
                return .requestPlain
            case .getWomenCategoryProducts:
                return .requestPlain
            case .getKidsCategoryProducts:
                return .requestPlain
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            
            //end
        }
    }
    
    var headers: [String : String]? {
        switch self{
        default:
            return ["X-Shopify-Access-Token":"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"]
        }
    }
}


