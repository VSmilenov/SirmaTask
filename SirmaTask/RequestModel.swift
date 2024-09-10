//
//  RequestModel.swift
//  SirmaTask
//
//  Created by Vasil Smilenov on 9/8/24.
//

import Foundation

// Model representing the request body for the API call
struct RequestModel: Encodable {
    let COMMON: COMMON
    
    struct COMMON: Encodable {
        let COUNTRIES: [String: String]
        let lang: String
    }
}
