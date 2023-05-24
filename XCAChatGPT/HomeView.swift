//
//  HomeView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI

struct HomeView: View {
    @State private var isSingleInterviewCategoryActive = false
    var body: some View {
        NavigationStack{
            VStack{
                
                VStack{
                    HStack{
                        Text("어떤대화를")
                            .font(.custom("Arial-BoldMT", size: 35)).foregroundColor(Color(hex: "#7B7B7B")) +
                        Text("\n시작할까요?")
                            .font(.custom("Arial", size: 35)).foregroundColor(Color(hex: "#7B7B7B"))
                        Spacer()
                    }.frame(width:250,height: 90)
                    Rectangle().size(width:50, height: 2).foregroundColor(Color(hex: "#7B7B7B"))
                }.padding(.top, 90.0).frame(width:250)
                

                NavigationLink(destination: LazyView(SingleInterviewCategory(cf:ContextFlow(dialogType:ContextFlow.DialogType.single)))){
                    MenuButtonView(text:"단일면접")
                }.padding(.bottom, 40)
                NavigationLink(destination: LazyView(SentenceSelectView(title: "직무카테고리를",cf:ContextFlow(dialogType: ContextFlow.DialogType.real)))){
                    MenuButtonView(text:"실전면접")
                }.padding(.bottom, 40)
                NavigationLink(destination: LazyView(ContentView(vm: ViewModel(api: ChatGPTAPI(apiKey: "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"))))){
                    MenuButtonView(text:"영어회화")
                }.padding(.bottom, 90)
                
            }
        }
            
        }
    }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
