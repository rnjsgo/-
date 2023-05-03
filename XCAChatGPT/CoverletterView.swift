//
//  CoverletterView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/03.
//

import SwiftUI

struct CoverletterView: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
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
                    Text("본인의 역량").font(.custom("Arial",size: 20))
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

            
            Button(action: {
                print("test")
            }, label:{
                Text("작성완료").font(.custom("Arial", size: 25)).foregroundColor(Color(hex: "#7B7B7B"))
            })
            .buttonStyle(MenuButton_small())
                .padding(.bottom, 30)
        }
    }
}
struct CoverletterView_Previews: PreviewProvider {
    static var previews: some View {
        CoverletterView()
    }
}


