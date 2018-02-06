//
//  AppServerRequests.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation
import ObjectMapper

class AppServerRequests {
    
    // for fetch the basic information of user
    static func fetchUserBaseInformation(username: String, callback: ServerRequestCallback?) {
        let req = ServerRequest(url: ServerUrls.loginUrl, postData: ["names[]": username], header: [:]) { (r) in
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: Array<UserInfoData>?) in
            callback?(.success(items as AnyObject))
        }
        
    }
    
    
    // for get the Hot posts
    
    static func getDiscussions(tag: String, limit: String,imageOnly: Bool, includeBody: Bool, callback: ServerRequestCallback?) {
        let req = ServerRequest(url: ServerUrls.discussions, postData: ["select_authors[]": tag, "limit": limit,"image_only": imageOnly, "include_body": includeBody,"include_author_profile_image": true], header: [:]) { (r) in
            print(ServerUrls.discussions)

            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        print(ServerUrls.discussions)
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: Array<DiscussionsData>?) in
            callback?(.success(items as AnyObject))
        }
    }
    
    static func authenticateUser(username: String, password: String, role: String, callback: ServerRequestCallback?) {
        let req = ServerRequest(url: ServerUrls.authUserUrl, postData: ["name": username, "password": password, "role": role], header: [:]) { (r) in
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .post
        ServerRequestInitiater.i.hitServerWith(req) {  (items: WifKeyData?) in
            callback?(.success(items))
        }
        
    }
    
    //MARK:- For comment on Post
   static func commnentOnPost(param: PostCommentResponseData) {
    
        let headers = [
            "content-type": "application/json",
            ]
        let parameters = [
            "parent_author": param.parent_author ?? "",
            "parent_permlink": param.parent_permlink ?? "",
            "author": param.author ?? "",
            "permlink": param.permlink ?? "",
            "title": param.title ?? "",
            "body": param.body ?? "",
            "json_metadata": [
                "tags": [""],
                "users": [""],
                "links": [""],
                "image": [""],
                "format": "html",
                "app": "instachain_mobile/0.1"
            ],
            "wif": param.wif ?? ""
            ] as [String : Any]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.postComment)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    _ = response as? HTTPURLResponse
                    let responseString = String(data: data!, encoding: .utf8)
                    let commentsData = Mapper<CommentResponseData>().map(JSONString: responseString!)
                    print(responseString)
                    print(commentsData?.blockNum)
                    print("responseString = \(String(describing: responseString))")
                    if let operations = commentsData?.operationData as? Array<Any> {
                        for items in operations {
                            if let operation = items as? Array<Any> {
                                for items in operation {
                                    if let item = items as? String{
                                        print(item)
                                    }else {
                                        if let item = items as? CommentResponseData {
                                            print(item.id)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                }
            })
            
            dataTask.resume()
        }
        catch {
            
        }
        
    }
    
    //MARK:- To get count of users followers
    static func getFollowersCount(account: String, callback: ServerRequestCallback?) {
        
        let req = ServerRequest(url: ServerUrls.followFollowersUrl, postData: ["account": account], header: [:]) { (r) in
            
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: FollowersFollowingData?) in
            callback?(.success(items))
        }
    }
    
    // MARK:- For check validation of wif
    static func wifValidation(pubWif: String, privWif: String, callback: ServerRequestCallback?) {
        
        let req = ServerRequest(url: ServerUrls.wifValid, postData: ["pubWif": pubWif, "privWif": privWif], header: [:]) { (r) in
            
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .post
        ServerRequestInitiater.i.hitServerWith(req) {  (items: WifKeyData?) in
            callback?(.success(items))
        }
    }
    

    // Login user
    static func login(userName: String, password: String, role: RoleType, completionHandler: @escaping (Data?, URLResponse?, Error? ) -> Void) {
        
        let headers = ["content-type": "application/json",]
        let parameters = ["name": userName,"password":password,"role": role.rawValue]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.authUserUrl)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            
            dataTask.resume()
        }
        catch {
            
        }
    }

    // get post in detail
    
    static func getDetailDiscussion(author: String, permlink: String, authorImage: Bool, callback: ServerRequestCallback?) {
        
        let req = ServerRequest(url: ServerUrls.detailDiscussion, postData: ["permlink": permlink, "author": author,"include_author_profile_image": authorImage], header: [:]) { (r) in
            
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: DetailDiscussionData?) in
            callback?(.success(items))
        }
    }
    
    //get image array post by user
    
    static func fetchPostedImage(tag: String, limit: String, imageOnly: String, callback: ServerRequestCallback?) {
        
        let req = ServerRequest(url: ServerUrls.imageOnly, postData: ["select_authors[]": tag, "limit": limit, "image_only": imageOnly], header: [:]) { (r) in
            
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: Array<PostedImageData>?) in
            callback?(.success(items as AnyObject))
        }
    }
    
    // vote a discussion
    static func voteToDiscussion(voter: String, author: String, permlink: String, weight: Int, wif: String, completionHandler: @escaping (Data?, URLResponse?, Error? ) -> Void) {
        
        let headers = ["content-type": "application/json",]
        let parameters = ["voter": voter,"author":author,"permlink": permlink, "weight": weight, "wif": wif] as [String : Any]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.vote)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            
            dataTask.resume()
        }
        catch {
            
        }
    }
    
    // start following
    static func startFollowing(author: [String], json: String, wif: String, completionHandler: @escaping (Data?, URLResponse?, Error? ) -> Void) {
        
        let headers = ["content-type": "application/json",]
        let parameters = ["required_auths": "[]","required_posting_auths": author,"id": "follow", "json": json, "wif": wif] as [String : Any]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.startAndStopFollow)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            
            dataTask.resume()
        }
        catch {
            
        }
    }
    
    //Get user followers
    
    static func getFollowers(follower: String, followType: String, limit: String, url: String, callback: ServerRequestCallback?) {
        var userStatus: String = ""
        if url == ServerUrls.followers {
            userStatus = "following"
        } else{
             userStatus = "follower"
        }
        
        
        
        let req = ServerRequest(url: url, postData: [userStatus: follower, "followType": followType, "limit": limit,"include_author_profile_image": true], header: [:]) { (r) in
            
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: Array<FollowersData>?) in
            callback?(.success(items as AnyObject))
        }
    }
    
    //get comments data
    
    static func getCommentsOfPost(author: String, permlink: String, callback: ServerRequestCallback?) {
        
        let req = ServerRequest(url: ServerUrls.comments, postData: ["parent": author, "parent_permlink": permlink, "include_author_profile_image": true], header: [:]) { (r) in
            
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: Array<PostData>?) in
            callback?(.success(items as AnyObject))
        }
    }
  
    //For update the profile picture
    
    static func upadteProfile(author: [String], json: String, wif: String, completionHandler: @escaping (Data?, URLResponse?, Error? ) -> Void) {
        
        let headers = ["content-type": "application/json",]
        let parameters = ["required_auths": "[]","required_posting_auths": author,"id": "follow", "json": json, "wif": wif] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.startAndStopFollow)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            
            dataTask.resume()
        }
        catch {
            
        }
    }

    //New Api

    static func getDiscussionByHot(limit: String,imageOnly: Bool, includeBody: Bool, postType: PostType, callback: ServerRequestCallback?) {
        let req = ServerRequest(url: postType.rawValue, postData: ["limit": limit,"image_only": imageOnly, "include_body": includeBody, "include_author_profile_image": true], header: [:]) { (r) in
            switch r {
            case .failure(let error):
                print(error!)
                // self.showAlert(msg: error?.description ?? "Parse error")
                if let c = callback {
                    c(.failure(error))
                }
                break
            default:
                break
            }
        }
        print(postType.rawValue)
        req.postType = .get
        ServerRequestInitiater.i.hitServerWith(req) {  (items: Array<DiscussionsData>?) in
            callback?(.success(items as AnyObject))
        }
    }



}
