//
//  BaseAPI.swift
//  Sportify
//
//  Created by Amr Muhammad on 4/27/21.
//  Copyright © 2021 ITI-41. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPI<T:TargetType> {
    
    func fetchData<M:Decodable>(target:T,responseClass : M.Type,completion: @escaping (Result<M?,NSError>) -> Void){
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        AF.request(target.baseURL + target.path, method: method , parameters: params.0,encoding: params.1, headers: headers)
            .responseJSON { (response) in
                guard let statusCode = response.response?.statusCode else {
                    //add custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                    print("at guard statusCode")
                    completion(.failure(error))
                    return
                }
                if statusCode == 200 {
                    //successful request
                    guard let jsonResponse = try? response.result.get() else {
                        //add custom Error
                        let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                        print("at jsonResponse")
                        completion(.failure(error))
                        return
                    }
                    guard let theJsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                        //add custom Error
                        let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                        print("at jsonData error")
                        completion(.failure(error))
                        return
                    }
                    guard let responseObject = try? JSONDecoder().decode(M.self, from: theJsonData) else {
                        //add custom Error
                        let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                        print("at responseObject, error on parsing")
                        completion(.failure(error))
                        return
                    }
                    print("success API Call")
                    completion(.success(responseObject))
                }else{
                    //add error depending on statusCode
                    let message = "Error Message Parsed From Server"
                    let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                    print(error)
                    completion(.failure(error))
                }
        }
    }
    
    func postData<M:Codable>(target:T,responseClass : M.Type,completion: @escaping (Result<M?,NSError>) -> Void){
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        AF.request(target.baseURL+target.path,
                   method: method,
                   parameters: (params.0["object"] as! M),
                   encoder: JSONParameterEncoder.default,headers: headers,requestModifier: {$0.httpShouldHandleCookies = false
                    $0.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        }).response { response in
            guard let statusCode = response.response?.statusCode else {
                //add custom Error
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                print("at guard statusCode")
                completion(.failure(error))
                return
            }
            var errorMessage = ""
            if(statusCode >= 200 && statusCode < 300){
                print("==statusCode for \(method) is \(statusCode)")
                guard let jsonResponse = try? response.result.get() else {
                    //add custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                    print("at jsonResponse")
                    completion(.failure(error))
                    return
                }
                guard let responseObject = try? JSONDecoder().decode(M.self, from: jsonResponse) else {
                    //add custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.genericError])
                    print("at responseObject, error on parsing")
                    completion(.failure(error))
                    return
                }
                completion(.success(responseObject))
            }else{
                errorMessage = String(data:try! response.result.get()!, encoding: .utf8)!
                var message = "Error Message Parsed From Server"
                if(statusCode == 422){
                    if(errorMessage.lowercased().contains("email")){
                        message = "Email already exists"
                    }else if(errorMessage.lowercased().contains("phone")){
                        message = "phone already exists"
                    }else if(errorMessage.lowercased().contains("country")){
                        message = "Please enter valid country name"
                    }
                }
                let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    private func buildParams(task:Task)-> ([String:Any],ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:],URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
}
