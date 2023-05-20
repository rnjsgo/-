//
//  SentenceSelectView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/04.
//

import SwiftUI

struct SentenceSelectView: View {
    var title: String

    
    var body: some View {
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
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("한 달을 시한부로 살 수 있고, 한 달 동안 5,000 만원의 돈이 주어진다면 어떻게 사용하겠습니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("10억이 생기면 무엇이 하고 싶습니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("서울 시내에 있는 중국집 전체의 하루 판매량을 논리적인 근거를 제시하여 정량을 계산하시오.").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("아이들을 웃게 하는 방법은 무엇입니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("자신이 얼마짜리 사람이라고 생각합니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("집의 뒷마당에 코끼리 한 마리를 숨길 수 있는 방법은 무엇이 있습니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("롤 모델은 누구이며, 왜 그렇습니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("회사 근무 중 다른 회사에서 제의가 들어온 경우, 어떠한 조건이라면 이직할 것입니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("1년 후에 무엇을 성취했을 것 같습니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                    Button(action: {
                        print("test")
                    }, label:{
                        Text("무인도에 3가지 물건을 가져갈 수 있다면 무엇을 가져가겠습니까?").font(.custom("Arial", size: 20)).foregroundColor(Color(hex: "#707070")).multilineTextAlignment(.center).frame(width:326, height:72)
                    }).buttonStyle(SentenceButton())
                }
            }.frame(width:350, height:550.0).padding(.bottom,100)
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
