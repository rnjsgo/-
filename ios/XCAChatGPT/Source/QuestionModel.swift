//
//  QuestionModel.swift
//  XCAChatGPT
//
//  Created by sun on 2023/05/10.
//

import Foundation

struct QuestionResponse:Codable{
    let question: [QuestionData]
//    let question: String
    
}

struct QuestionData:Codable{
    let question: String
}
