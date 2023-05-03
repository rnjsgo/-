//
//  HomeView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
            VStack{
                VStack{
                    HStack{
                        Text("어떤대화")
                            .font(.custom("Arial-BoldMT", size: 35)).foregroundColor(Color(hex: "#7B7B7B")) +
                        Text("를\n시작할까요?")
                            .font(.custom("Arial", size: 35)).foregroundColor(Color(hex: "#7B7B7B"))
                        Spacer()
                    }
                    Rectangle().size(width:50, height: 2).foregroundColor(Color(hex: "#7B7B7B"))
                }.padding(.top, 90.0).frame(width:250)
                

                Button(action: {
                    print("test")
                }, label:{
                    Text("단일면접").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
                }).buttonStyle(MenuButton())
                    .padding(.bottom, 40)
                Button(action: {
                    print("test")
                }, label:{
                    Text("실전면접").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
                }).buttonStyle(MenuButton()).padding(.bottom, 40)
                Button(action: {
                    print("test")
                }, label:{
                    Text("영어회화").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
                }).buttonStyle(MenuButton()).padding(.bottom, 90)
                
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
