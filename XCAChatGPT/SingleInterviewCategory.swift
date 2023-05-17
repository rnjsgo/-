//
//  SingleInterviewCategory.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI
let viewController = ViewController()

struct SingleInterviewCategory: View {
    @State private var isSocial = false
    @State private var isCreative = false
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    HStack{
                        Text("질문유형")
                            .font(.custom("Arial-BoldMT", size: 35)).foregroundColor(Color(hex: "#7B7B7B")) +
                        Text("을\n선택해주세요")
                            .font(.custom("Arial", size: 35)).foregroundColor(Color(hex: "#7B7B7B"))
                        Spacer()
                    }.frame(width:250,height: 90)
                        //.background(Color.red)
                    Rectangle().size(width:50, height: 2).foregroundColor(Color(hex: "#7B7B7B"))
                }.padding(.top, 20)
                    .frame(width:250,height:150)
                    //.background(Color.black)
                
                
                NavigationLink(destination:SentenceSelectView(title:"인성질문을")){
                    MenuButton_small_View(text:"인성")
                }.padding(.bottom, 30)
                    .padding(.top,50)
                
                NavigationLink(destination:SentenceSelectView(title:"창의질문을")){
                    MenuButton_small_View(text:"창의성")
                }.simultaneousGesture(TapGesture().onEnded({
                    viewController.loginButtonTapped()
                })).padding(.bottom, 30)
                
                NavigationLink(destination:SentenceSelectView(title:"사회질문을")){
                    MenuButton_small_View(text:"사회 / 시사")
                }.padding(.bottom, 30)
                
                NavigationLink(destination:SentenceSelectView(title:"직무적합도질문을")){
                    MenuButton_small_View(text:"직무적합도")
                }.padding(.bottom, 80)
                
            }
        }
    }
}
    
struct SingleInterviewCategory_Previews: PreviewProvider {
    static var previews: some View {
        SingleInterviewCategory()
    }
}

