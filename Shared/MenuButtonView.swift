//
//  File.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import Foundation
import SwiftUI

struct MenuButton: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .frame(width: 256, height: 97)
               .background(Color.white)
               .cornerRadius(18)
               .overlay(
                   RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("#707070"), lineWidth: 1)
               )
               .shadow(color: Color("#000000").opacity(0.16), radius: 6, x: 0, y: 3)
       }
}
