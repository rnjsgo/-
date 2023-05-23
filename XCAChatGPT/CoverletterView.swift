//
//  CoverletterView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI

struct CoverletterView: View {
    var cf:ContextFlow
    @State private var text = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    HStack{
                        Text("자기소개서")
                            .font(.custom("Arial-BoldMT", size: 35)).foregroundColor(Color(hex: "#7B7B7B")) +
                        Text("를\n작성해주세요")
                            .font(.custom("Arial", size: 35)).foregroundColor(Color(hex: "#7B7B7B"))
                        Spacer()
                    }.frame(height:150)
                    Rectangle().size(width:50, height: 2).foregroundColor(Color(hex: "#7B7B7B")).padding([.top,.bottom],0)
                }.frame(width:250).padding(.top, 30)
                VStack{
                    HStack{
                        if(cf.coverLetterQuestion != nil){
                            Text(cf.coverLetterQuestion!).font(.custom("Arial",size: 20))
                        }else{
                            Text("질문").font(.custom("Arial",size: 20))
                        }
                        Spacer()
                    }.frame(width:280,height: 60)
                        .padding(.bottom,3)
                    HStack{
                        Spacer()
                        Text("500자 내외").font(.custom("Arial",size:10)).foregroundColor(Color(hex: "#B1B1B1"))
                        
                    }.frame(width: 280)
                }.padding(.bottom,15)
                
                Group {
                    VStack {
                        TextField("여기에 자기소개서를 작성해주세요!",text: $text,axis: .vertical)
                            .frame(width: 280.0, height: 300.0)
                            .onChange(of: text) { newValue in
                                if newValue.count > 550 {
                                    text = String(newValue.prefix(550))
                                }
                            }
                            .background(Color.white)
                            .focused($isFocused)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical,2)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Button("완료") {
                                            isFocused = false
                                        }
                                    }
                                }
                            }
                        
                    }
                    .background(Color.white)
                    .cornerRadius(1)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.16), radius: 1, x: 5, y: 4)
                    .padding(.bottom, 20)
                    
                }
                
                
                NavigationLink(destination:LazyView(ContentView(cf:cf.setCoverLetterAnswer(answer: text), vm: ViewModel(api: ChatGPTAPI(apiKey: "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"))))){
                    MenuButton_small_View(text:"작성완료")
                }
                .padding(.bottom, 30)
            }
        }
    }
}
struct CoverletterView_Previews: PreviewProvider {
    static var previews: some View {
        CoverletterView(cf:ContextFlow(coverLetterQuestion:"테스트질문입니다."))
    }
}


