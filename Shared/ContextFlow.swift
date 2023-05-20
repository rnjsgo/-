//
//  Context.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/17.
//

import Foundation

struct ContextFlow{
    enum DialogType:String{
        case real
        case single
        case english
    }
    var dialogType:DialogType?
    
    var selectedQuestion:String?
    
    var jobCategory:String?
    
    var coverLetterQuestion:String?
    var coverLetterAnswer:String?

}
