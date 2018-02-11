//
//  LoginResponse.swift
//  InstaChain
//
//  Created by PAC on 2/11/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable, Encodable {
    let result: Bool?
    let key_type: String?
    let priv_wif: String?
}
