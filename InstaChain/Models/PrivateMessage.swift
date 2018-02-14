//
//  PrivateMessage.swift
//  InstaChain
//
//  Created by John Nik on 14/02/2018.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

struct PrivateMessage: Codable {
    
    let from: String?
    let to: String?
    let amount: String?
    let memo: String?
    let priv_memo_wif: String?
    let wif: String?
    
}

struct PrivateMessageResponse: Codable {
    
    let ref_block_num: Int?
    let ref_block_prefix: Int?
    let expiration: String?
    
}

struct PrivateMessageHistoryRequest {
    
    let name: String
    let priv_memo_wif: String
}


//"ref_block_num":31971,"ref_block_prefix":1230114856,"expiration":"2018-02-14T21:24:15","operations":[["transfer",{"from":"mobile","to":"amintest","amount":"0.001 INSTA","memo":"#GL3ZJ7CwC489v8HjdcESMx1n4FRUdfNL17pvDwUwmfsZZmvZiajsFmFpL5c3Aoc5Zo71jJTX8dL3WyuD3LHC8Jf2FAGEgnK57VG53LzDCaQWKiGHoNMBnptyosdeDJ8K3"}]],"extensions":[],"signatures":["1f1a508eb43ffa2be482e392401b5ac2d66d44bcf92ddb488dcbb4843b704f46f0667a25e32ff14dfc8d792dd3cfb1bac23761f03f98a8ff3dc472095d375b361e"]

