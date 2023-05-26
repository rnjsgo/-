//
//  SentenceSelectView.swift
//  XCAChatGPT
//
//  Created by 허현준 on 2023/05/04.
//

import SwiftUI

struct SentenceSelectView: View {
    
    var title: String
    @State private var sentences=[""]
    let cf:ContextFlow
    
    
    var real_category=["IT, 통신", "서비스업", "기관, 협회", "교육업", "은행, 금융업", "미디어,디자인", "의료, 제약, 복지", "유통, 무역, 운송", "제조, 화학", "건설"]
    var coverletterQuestion=["지원동기", "입사 후 포부", "성장배경", "성격 및 장단점", "위기 극복 사례", "주도적으로 업무를 수행한 사례", "사회경험", "직무를 선택한 이유", "본인의 역량"]
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                }.frame(width:400,height: 180)
                    .padding(.top,10)
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
                            }.frame(width: 250.0, height: 100.0).padding(.top,10)
                        }
                    }
                
                
                ScrollView{
                    VStack{
                        //단일질문 ->
                        if(cf.dialogType == ContextFlow.DialogType.single){
                            ForEach(sentences,id: \.self){text in
                                NavigationLink(destination:LazyView(MicChatView(cf:cf.setSelectedQuestion(question:text), vm: ViewModel(api: ChatGPTAPI(apiKey: "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"))))){
                                    SentenceButtonView(text: text)
                                }
                            }
                        }else if(cf.dialogType == ContextFlow.DialogType.real
                                 && cf.jobCategory == nil){
                            //실전면접 -> 카테고리
                            ForEach(real_category,id: \.self){text in
                                NavigationLink(destination:LazyView(SentenceSelectView(title:"자기소개서 질문을",cf:cf.setJobCategory(jobCategory: text)))){
                                    SentenceButtonView(text: text)
                                }
                            }
                        }else if(cf.dialogType == ContextFlow.DialogType.real
                                 && cf.jobCategory != nil){
                            //실전면접 -> 카테고리 -> 자소서질문 -> 자소서
                            ForEach(coverletterQuestion,id: \.self){text in
                                NavigationLink(destination:LazyView(CoverletterView(cf:cf.setCoverLetterQuestion(question: text)))){
                                    SentenceButtonView(text: text)
                                }
                            }
                        }
                        else{
                            //그외
                            ForEach(sentences,id: \.self){text in
                                NavigationLink(destination:HomeView()){
                                    SentenceButtonView(text: text)
                                }
                            }
                        }
                        
                    }
                    }.frame(width:350).padding(.top,10)
                
                }
            }.task {
                if(cf.questionCategory == ContextFlow.QuestionCategory.creativity){
                    await questionList(category:"creativity")
                }else if(cf.questionCategory == ContextFlow.QuestionCategory.personality){
                    await questionList(category:"personality")
                }else if(cf.questionCategory == ContextFlow.QuestionCategory.social){
                    await questionList(category:"social")
                }else if(cf.questionCategory == ContextFlow.QuestionCategory.job){
                    await questionList(category:"suitability")
                }
            }
    }
    
    func questionList(category:String) async{
        await ViewController.shared.getQuestion(from:category){ret in
            self.sentences=ret
        }
    }
}

struct SentenceSelectView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceSelectView(title:"창의질문", cf: ContextFlow(dialogType:ContextFlow.DialogType.real,questionCategory:ContextFlow.QuestionCategory.creativity))
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
