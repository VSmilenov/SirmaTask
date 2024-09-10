//
//  ResponseModel.swift
//  SirmaTask
//
//  Created by Vasil Smilenov on 9/8/24.
//

import Foundation

// Model representing a country object
struct Country: Decodable {
    let code: String
    let name: String
    let isocode: String
}

struct CountriesWrapper: Decodable {
    let countries: [CountryWrapper]
    let lang: String?
    
    // Enum that defines how to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case countries = "COUNTRIES"
        case lang
    }
}

struct CommonResponse: Decodable {
    let common: [CountriesWrapper]
    
    enum CodingKeys: String, CodingKey {
        case common = "COMMON"
    }
}

struct CountryWrapper: Decodable {
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case countries = "COUNTRY"
    }
}
