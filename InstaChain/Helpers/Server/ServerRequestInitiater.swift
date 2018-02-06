//
//  ServerRequestInitiater.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
//import SwiftyJSON

typealias ServerRequestCallback = (ServerResult) -> Void
typealias ServerRequestSucessCallback = (AnyObject?) -> Void

enum ServerResult{
    case success(AnyObject?);
    case failure(NSError?)
    case uploadProgress(Float)
}


class ServerRequestInitiater {

    static let i:ServerRequestInitiater = ServerRequestInitiater()
    
    fileprivate init (){
        
    }
    
    typealias ServerRequestInitiaterCallback = (_ status : Int, _ forTextField : UITextField)->()
    
    func postMessageToServerForJsonResponse(_ url:String, postData:[String:Any]?, header: HTTPHeaders, completionHandler: @escaping ServerRequestCallback) {
        
        Alamofire.request(url, parameters: postData,  headers: header)
            .responseJSON { (response)  in
                print(response.response ?? "")
                
                if response.result.isSuccess {
                    completionHandler(.success(response.result.value as AnyObject?))
                    
                }
                else if response.result.isFailure  {
                    print(response.request!)
                    
                    completionHandler(.failure(response.result.error as NSError?))
                    
                }
                
                
                if let _ = response.result.value {
                    //   print("data is \(json)")
                }
        }
        
    }
    
    
    func postMessageToServerForStringResponse(_ url:String, postData:[String:Any]?,header: HTTPHeaders, completionHandler: @escaping ServerRequestCallback) {
        
        Alamofire.request(url, headers: header).responseString(completionHandler: { (response) in
            // print(response.response)
            
            if response.result.isSuccess {
                completionHandler(.success(response.result.value as AnyObject?))
                print(response.result.value)
            }
            else if response.result.isFailure  {
                print(response.request!)
                completionHandler(.failure(response.result.error as NSError?))
                
            }
        })
        
    }
    
//    static func uploadImage(url: String, imageData: Data?){
//        let header: HTTPHeaders = ["Content-Type":"image/png"]
//        let view = BaseViewController()
//        view.showLoader()
//
//        Alamofire.upload(imageData!, to: url, method: HTTPMethod.put, headers: header)
//            .uploadProgress { progress in
//                print("Upload Progress: \(progress.fractionCompleted)")
//            }
//            .responseString { (response) in
//                BaseViewController.hideLoader()
//        }
//
//    }
    
    
    func initiateServerRequest(_ req:ServerRequest){
        switch req.responseType {
        case .json:
            Alamofire.request(req.url, parameters: req.postData, encoding: URLEncoding.default).responseJSON { (response) -> Void in
                // print(response.response)
                // print(response.data)
                if response.result.isSuccess {
                    if let cH = req.completionHandler {
                        cH(.success(response.result.value as AnyObject?))
                    }
                    
                }
                else if response.result.isFailure  {
                    if req.retryCount > 0 {
                        print("retry......!!!!!!!!")
                        req.retryCount-=1
                        
                        MyUtils.delay(req.intervalBetweenRetry, work: { () -> () in
                            self.initiateServerRequest(req)
                        })
                    }
                    else{
                        print(response.request!)
                        
                        if let cH = req.completionHandler {
                            cH(.failure(response.result.error as NSError?))
                        }
                    }
                }
            }
            
            break;
        case .normal:
            Alamofire.request(req.url, parameters: req.postData, encoding: URLEncoding.default).responseString(completionHandler: { (response) -> Void in
                //print(response.result)
                
                if response.result.isSuccess {
                    if let cH = req.completionHandler {
                        cH(.success(response.result.value as AnyObject?))
                    }
                    
                }
                else if response.result.isFailure  {
                    if req.retryCount > 0 {
                        print("retry......!!!!!!!!")
                        req.retryCount-=1
                        
                        MyUtils.delay(req.intervalBetweenRetry, work: { () -> () in
                            self.initiateServerRequest(req)
                        })
                    }
                    else{
                        print(response.request!)
                        
                        if let cH = req.completionHandler {
                            cH(.failure(response.result.error as NSError?))
                        }
                    }
                }
            })
            
            break
        }
        
    }
    
    func hitServerWith<T:Mappable>(_ req:ServerRequest, onSucess:@escaping ([T]?) -> Void){
        //  let encoding = req.postType == HTTPMethod.get ? URLEncoding.default : URLEncoding.httpBody
        
        Alamofire.request(req.url, method: req.postType, parameters: req.postData, encoding: URLEncoding.default, headers: req.header).responseArray(completionHandler: { (r:DataResponse<[T]>) in
            if r.result.isSuccess {
                onSucess(r.result.value)
                
            }
            else if r.result.isFailure  {
                if req.retryCount > 0 {
                    print("retry......!!!!!!!!")
                    req.retryCount-=1
                    
                    MyUtils.delay(req.intervalBetweenRetry, work: { () -> () in
                        self.hitServerWith(req, onSucess: onSucess)
                    })
                }
                else{
                    print(r.request!)
                    
                    if let cH = req.completionHandler {
                        cH(.failure(r.result.error as NSError?))
                    }
                }
            }
        })
        
    }
    
    func hitServerWith<T:Mappable>(_ req:ServerRequest, onSucess:@escaping (T?) -> Void){
        // let encoding = req.postType == HTTPMethod.get ? URLEncoding.default : URLEncoding.httpBody
        
        Alamofire.request(req.url, method: req.postType, parameters: req.postData, encoding: URLEncoding.default, headers:["Content-Type":"application/json"]).responseObject(completionHandler: { (r:DataResponse<T>) in
            if r.result.isSuccess {
                onSucess(r.result.value)
                print(r.result.value)
            }
            else if r.result.isFailure  {
                if req.retryCount > 0 {
                    print("retry......!!!!!!!!")
                    req.retryCount-=1
                    
                    MyUtils.delay(req.intervalBetweenRetry, work: { () -> () in
                        self.hitServerWith(req, onSucess: onSucess)
                    })
                }
                else{
                    print(r.request ?? "")
                    
                    if let cH = req.completionHandler {
                        cH(.failure(r.result.error as NSError?))
                    }
                }
            }
        })
    }
    
    //......................Swift Method
 
 
    
}

class ServerRequest{
    var url:String!
    var postData:[String:Any]!
    var completionHandler:ServerRequestCallback?
    var postType:HTTPMethod = .post
    var responseType:ServerResponseType = .json
    var retryCount = 1
    var intervalBetweenRetry = 2.0
    var header: HTTPHeaders
    init(url:String, postData:[String:Any], header: [String: String], completionHandler: @escaping ServerRequestCallback){
        self.url = url
        self.postData = postData
        self.header = header
        self.completionHandler = completionHandler
    }
}


enum ServerResponseType{
    case normal;
    case json
}
