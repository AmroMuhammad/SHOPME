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
    case customers
    case newCustomer
    
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
            
            //end
            
            
            // MARK: Ayman Section
        case .customers:
            return Constants.customersURL
            
        case .newCustomer:
            return Constants.newCustomer
            
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
            
            
            //end
            
            
            // MARK: Ayman Section
        case .customers:
            return .get
            
        case .newCustomer:
            return .post
            
        
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
            
            
            //end
            
            
            // MARK: Ayman Section
        case .customers:
            return .requestPlain
            
            
        case .newCustomer:
            return .requestPlain
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



