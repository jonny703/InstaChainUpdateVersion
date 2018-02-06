//
//  RawData.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation
import ObjectMapper

class VoteRawData: BaseData {
    var voter: String?
    var author: String?
    var permlink: String?
    var weight: Int?
    var wif: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
         voter <- map["voter"]
         author <- map["author"]
         permlink <- map["permlink"]
         weight <- map["weight"]
         wif <- map["wif"]
    }
}

class followJsonRawData: BaseData{
    var follower: String?
    var following: String?
    var what: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        follower <- map[""]
        following <- map["following"]
        what <- map["what"]
    }
}
