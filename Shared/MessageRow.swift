//
//  MessageRow.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import SwiftUI

struct AttributedOutput {
    let string: String
    let results: [ParserResult]
}

enum MessageRowType {
    case attributed(AttributedOutput)
    case rawText(String)
    
    var text: String {
        switch self {
        case .attributed(let attributedOutput):
            return attributedOutput.string
        case .rawText(let string):
            return string
        }
    }
    
}

struct MessageRow: Identifiable {
    
    let id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    var isIgnore:Bool = false
    
    let sendImage: String
    let send: MessageRowType
    var sendText: String {
        send.text
    }
    
    let responseImage: String
    var response: MessageRowType?
    var responseText: String? {
        response?.text
    }
    
    var responseError: String?
    public func copy(messageRow:MessageRow)->MessageRow{
        return MessageRow(isInteractingWithChatGPT: messageRow.isInteractingWithChatGPT, sendImage: messageRow.sendImage, send: messageRow.send, responseImage: messageRow.responseImage,response:messageRow.response,responseError: messageRow.responseError)
    }
}


