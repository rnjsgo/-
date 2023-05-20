//
//  APIConstants.swift
//  XCAChatGPT
//
//  Created by sun on 2023/05/10.
//

import Foundation

struct APIConstants{
    static let baseURL="http://localhost:8080"
    
    static let getCreativityURL=baseURL+"/question/creativity"
    static let getPersonalityURL=baseURL+"/question/personality"
    static let getSocialURL=baseURL+"/question/social"
    static let getSuitabilityURL=baseURL+"/question/suitability"

}
