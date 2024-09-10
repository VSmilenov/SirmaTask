//
//  CountryService.swift
//  SirmaTask
//
//  Created by Vasil Smilenov on 9/8/24.
//

import Foundation
import Alamofire


// Service class responsible for handling API requests
class CountryService {
    
    static let shared = CountryService()
    private init() {}
    
    private let baseUrl = "https://tsdm.dbank.bg/EBank/Enquiry"
    
    func fetchCountries(language: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        let requestModel = RequestModel(COMMON: RequestModel.COMMON(COUNTRIES: [:], lang: language))
        
        //Make the request using Alamofire
        AF.request(baseUrl, method: .post, parameters: requestModel, encoder: JSONParameterEncoder.default, headers: ["Content-Type": "application/json"])
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        // Attempt to decode the JSON response
                        let commonResponse = try JSONDecoder().decode(CommonResponse.self, from: data)
                        // Extract countries from the nested structure
                        if let countries = commonResponse.common.first?.countries.first?.countries {
                            completion(.success(countries))
                        } else {
                            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No countries data found"])))
                        }
                    } catch DecodingError.dataCorrupted(let context) {
                        print(context)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.valueNotFound(let value, let context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
