//
//  LoginResponse.swift
//  InstaChain
//
//  Created by John Nik on 2/11/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable, Encodable {
    let error: String?
    
    let result: Bool?
    let key_type: String?
    let priv_wif: String?
    let priv_memo_wif: String?
}
