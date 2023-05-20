//
//  SentenceSelectView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/04.
//

import SwiftUI

struct SentenceSelectView: View {
    var title: String
    var sentences=["질문을 불러오는데", "실패했습니다."]
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    
                }.frame(width:400,height: 200)
                    .padding(.top,100)
                    .background(Color.white)
                    .shadow(radius:5,x:1,y:5)
                    .overlay{
                        VStack{
                            HStack{
                                Text(title+"\n")
                                    .font(.custom("Arial-BoldMT", size: 32)).foregroundColor(Color(hex: "#7B7B7B")) +
                                Text("선택해주세요")
                                    .font(.custom("Arial", size: 32)).foregroundColor(Color(hex: "#7B7B7B"))
                                Spacer()
                            }.frame(width: 250.0, height: 100.0).padding(.top,100)
                        }
                    }
                
                
                ScrollView{
                    VStack{
                        ForEach(sentences,id: \.self){text in
                            NavigationLink(destination:HomeView()){
                                SentenceButtonView(text: text)
                            }
                        }
                    }.frame(width:350, height:550.0).padding(.bottom,100)
                }
            }
        }
    }
}

struct SentenceSelectView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceSelectView(title:"창의질문")
    }
}

struct NavigationSentenceView: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TokenizerView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
