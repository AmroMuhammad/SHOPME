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
    
    //end
    
    
    // MARK: Ayman Section
    
    //end
    
    
    // MARK: Marwa Section
    case allWomenProduct
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
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            case .allWomenProduct :
            return Constants.allWomenProduct
            //end
            
        
        }
    }
    
    var method: HTTPMethod {
        switch self{
            // MARK: Ahmed Section
            
            //end
            
            // MARK: Amr Section
            
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            case .allWomenProduct:
                       return .get
            //end
       
        }
    }
    
    var task: Task {
        switch self{
            // MARK: Ahmed Section
            
            //end
            
            // MARK: Amr Section
            
            
            //end
            
            
            // MARK: Ayman Section
            
            //end
            
            
            // MARK: Marwa Section
            case .allWomenProduct:
                return.requestPlain
            }
            //end
        
    }
    
    var headers: [String : String]? {
        switch self{
        default:
            return [:]
        }
    }
}


