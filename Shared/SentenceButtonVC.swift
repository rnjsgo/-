//
//  SentenceButtonVC.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/04.
//

import Foundation
import SwiftUI

struct SentenceButton: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        VStack{
            configuration.label
                .frame(width: 390, height: 130)
                .background(Color.white)
            HStack{
                Rectangle().size(width:84, height:1).foregroundColor(Color(hex: "#7B7B7B"))
            }.frame(width: 84, height:1)
        }
        
    }
}

/*
 Button(action: {
     print("test")
 }, label:{
     Text("실전면접").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070"))
 }).buttonStyle(SentenceButton())
 */

struct SentenceButtonView: View{
    let text: String
    var body:some View{
        VStack{
            VStack{
                Text(text)
                    .font(.custom("Arial", size: 20))
                    .foregroundColor(Color(hex: "#707070"))
            }
            .frame(width: 390, height: 130)
            .background(Color.white)
            
            HStack{
                Rectangle().size(width:84, height:1).foregroundColor(Color(hex: "#7B7B7B"))
            }.frame(width: 84, height:1)
        }
    }
}
