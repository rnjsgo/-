//
//  SingleInterviewCategory.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI

struct SingleInterviewCategory: View {
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("질문유형")
                        .font(.custom("Arial-BoldMT", size: 35)).foregroundColor(Color(hex: "#7B7B7B")) +
                    Text("을\n선택해주세요")
                        .font(.custom("Arial", size: 35)).foregroundColor(Color(hex: "#7B7B7B"))
                    Spacer()
                }
                Rectangle().size(width:50, height: 2).foregroundColor(Color(hex: "#7B7B7B"))
            }.padding(.top, 90.0).frame(width:250)
            

            Button(action: {
                print("test")
            }, label:{
                Text("인성").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
            })
            .buttonStyle(MenuButton_small())
                .padding(.bottom, 30)
                
            Button(action: {
                print("test")
            }, label:{
                Text("직무적합도").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
            }).buttonStyle(MenuButton_small()).padding(.bottom, 30)
            Button(action: {
                print("test")
            }, label:{
                Text("사회/시사").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
            }).buttonStyle(MenuButton_small()).padding(.bottom, 30)
            Button(action: {
                print("test")
            }, label:{
                Text("사회/창의성").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
            }).buttonStyle(MenuButton_small()).padding(.bottom, 90)
            
        }
    }
}

struct SingleInterviewCategory_Previews: PreviewProvider {
    static var previews: some View {
        SingleInterviewCategory()
    }
}
