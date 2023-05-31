//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    var cf:ContextFlow
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    @FocusState var isTextFieldFocused: Bool
    
    @State var overCount:Int = 0
    @State var isChatOver: Bool = false
    @State var sendCount:Int = 0
    
    var realInterviewPrompts:[String] = [
        "이전 답변에 대해서 단 하나의 추가 질문을 하라",
        "면접 상황에 맞게 이전 질문과 다른 적절한 주제의 새로운 질문을 하라" ,
        "이전 답변에서 추가 질문이 꼭 필요하다고 판단하면 추가적인 질문을 하고, 그렇지 않다면 적절한 주제의 새로운 질문을 하라.",
        "이전 답변에서 추가 질문이 꼭 필요하다고 판단하면 추가적인 질문을 하고, 그렇지 않다면 적절한 주제의 새로운 질문을 하라. 만약 새로운 질문을 한다면 지원자가 제출한 자기소개서 답변 내용에 대한 질문을 하라. 자기소개서 답변이 비어있다면, 인성 관련 면접 질문을 하라. ",
        "이전 답변에서 추가 질문이 꼭 필요하다고 판단하면 추가적인 질문을 하고, 그렇지 않다면 적절한 주제의 새로운 질문을 하라. 만약 새로운 질문을 한다면 지원 직무 관련 지식에 대한 질문을 하라."
    ]
    
    
    var body: some View {
        NavigationStack{
            chatListView
                .navigationTitle("XCA ChatGPT")
                .navigationBarTitleDisplayMode(.inline) 
                NavigationLink("feedbackview", destination:LazyView(FeedbackView(vm:vm))).hidden()
            NavigationLink("feedbackview", destination:LazyView(
                FeedbackView(vm:vm)),isActive: $isChatOver)
            .hidden()
        }.onAppear{
            //면접 오버카운트 초기화
            if(cf.dialogType == ContextFlow.DialogType.single){
                self.overCount = 1
            }else{
                self.overCount = 5
            }
        }
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            if (!message.isIgnore){
                                MessageRowView(message: message) { message in
                                    Task { @MainActor in
                                        await vm.retry(message: message)
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                #if os(iOS) || os(macOS)
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
                #endif
            }
            .onChange(of: vm.messages.last?.responseText) { _ in  scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
        
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                } placeholder: {
                    ProgressView()
                }

            } else {
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            TextField("Send message", text: $vm.inputMessage, axis: .vertical)
                #if os(iOS) || os(macOS)
                .textFieldStyle(.roundedBorder)
                #endif
                .focused($isTextFieldFocused)
                .disabled(vm.isInteractingWithChatGPT)
            
            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button {
                    self.sendCount = self.sendCount + 1
                    if(self.sendCount == self.overCount){
                        let messageRow = MessageRow(
                            isInteractingWithChatGPT: true,
                            isIgnore: false,
                            sendImage: "profile",
                            send: .rawText(vm.inputMessage),
                            responseImage: "openai",
                            response: .rawText(""),
                            responseError: nil)
                        vm.messages.append(messageRow)
                        self.isChatOver = true
                    }
                    //면접 프롬프트
                    if(cf.dialogType == ContextFlow.DialogType.real)
                    { //실제면접 프롬프트
                        if(self.sendCount>4){
                            vm.api.changePrompt(text: realInterviewPrompts[4])
                        }
                        else if(self.sendCount>2){
                            vm.api.changePrompt(text: realInterviewPrompts[3])
                        }
                        else{
                            vm.api.changePrompt(text: realInterviewPrompts[2])
                        }
                    }else if(cf.dialogType == ContextFlow.DialogType.single)
                    {// 단일면접 프롬프트
                        print("단일면접 프롬프트")
                    }else if(cf.dialogType == ContextFlow.DialogType.english)
                    {// 영어회화 프롬프트
                        print("영어회화 프롬프트")
                    }
                    
                    Task { @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }
                #if os(macOS)
                .buttonStyle(.borderless)
                .keyboardShortcut(.defaultAction)
                .foregroundColor(.accentColor)
                #endif
                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .onAppear{
            print("-----------------------------면접시작-----------------------------")
            Task { @MainActor in
                scrollToBottom(proxy: proxy)
                // 면접 시작 프롬프트
                if(cf.dialogType == ContextFlow.DialogType.single){ // 단일면접 첫 프롬프트
                    vm.inputMessage="너는 지금부터 면접관이고 나는 면접 대상자야. 가벼운 인사와 함께 최대한 간단하게 다음 문장을 질문으로 해줘. "+(cf.selectedQuestion ?? "질문을 찾을수 없습니다")
                }
                else if(cf.dialogType == ContextFlow.DialogType.real){ // 실전면접 첫 프롬프트
                    vm.api.changePrompt(text:"질문 전에 짧게 인사를 하고(본인을 소개하지 말 것), 자기소개를 부탁하는 질문으로 면접을 시작하라. ")
                    vm.api.systemMessage.content+=" 직무와 관련되지 않은 질문은 지양하라. 압박 면접 분위기를 조성하라. 다음은 지원자에 대한 정보이다.이를 참고하여 면접을 진행하라."
                    vm.api.systemMessage.content+="1. 지원자가 지원한 직무 분야는 "+(cf.jobCategory ?? "")+"이다. "
                    vm.api.systemMessage.content+="2. 다음은 지원자가 제출한 자기소개서 문항과 그에 대한 답변이다."
                    vm.api.systemMessage.content+="문항 :"+(cf.coverLetterQuestion ?? "")
                    vm.api.systemMessage.content+=", 답변 : "+(cf.coverLetterAnswer ?? "")
                    vm.inputMessage="너는 지금부터 면접관이고 나는 지원자야. 실제 면접처럼 하나씩만 질문해줘."
                }
                else if(cf.dialogType == ContextFlow.DialogType.english){// 영어회화 첫 프롬프트
                    print("영어회화 첫 프롬프트")
                }
                await vm.promptSend(ignore:true)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ContentView(vm: ViewModel(api: ChatGPTAPI()),GoToHome: .constant(true))
//        }
//    }
//}
