//
//  File.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import Foundation
import SwiftUI

struct MenuButtonView: View{
    var text: String
    var body: some View{
        VStack{
            Text(text)
                .font(.custom("Arial", size: 25))
                .foregroundColor(Color(hex: "#7B7B7B"))
        }
        .frame(width: 256, height: 97)
        
        .background(Color.white)
        
        .cornerRadius(18)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.16), radius: 2, x: 5, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
             .stroke(Color(hex:"#7B7B7B"),lineWidth: 1)
        )
    }
}

struct MenuButton_small_View: View{
    var text: String
    var body: some View{
        VStack{
            Text(text)
                .font(.custom("Arial", size: 25))
                .foregroundColor(Color(hex: "#7B7B7B"))
        }
        .frame(width: 256, height: 68)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.16), radius: 2, x: 5, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
             .stroke(Color(hex:"#7B7B7B"),lineWidth: 1)
        )
    }
}

struct MenuButton_small: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .frame(width: 256, height: 68)
               
               .background(Color.white)
               
               .cornerRadius(18)
               .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.16), radius: 2, x: 5, y: 4)
               .overlay(
                   RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(hex:"#7B7B7B"),lineWidth: 1)
               )
    }
}
