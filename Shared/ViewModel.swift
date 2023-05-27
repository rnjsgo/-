//
//  ViewModel.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 02/02/23.
//

import Foundation
import SwiftUI
import AVKit

class ViewModel: ObservableObject {
    
    @Published var isInteractingWithChatGPT = false
    @Published var isInterviewOver = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @State var pathStack = NavigationPath()
    @Published public var chatCount:Int
    @Published private var realInterviewPrompts:[String] = ["이전 답변에 대해서 단 하나의 추가 질문을 하라","면접 상황에 맞게 이전 질문과 다른 적절한 주제의 새로운 질문을 하라" ,"이전 답변에서 추가 질문이 꼭 필요하다고 판단하면 추가적인 질문을 하고, 그렇지 않다면 적절한 주제의 새로운 질문을 하라.","이전 답변에서 추가 질문이 꼭 필요하다고 판단하면 추가적인 질문을 하고, 그렇지 않다면 적절한 주제의 새로운 질문을 하라. 만약 새로운 질문을 한다면 지원자가 제출한 자기소개서 내용에 대한 질문을 하라. 자기소개서 답변이 비어있다면, 인성 관련 면접 질문을 하라. ","이전 답변에서 추가 질문이 꼭 필요하다고 판단하면 추가적인 질문을 하고, 그렇지 않다면 적절한 주제의 새로운 질문을 하라. 만약 새로운 질문을 한다면 지원 직무 관련 지식에 대한 질문을 하라."]

    #if !os(watchOS)
    private var synthesizer: AVSpeechSynthesizer?
    #endif
    
    let api: ChatGPTAPI
    
    init(api: ChatGPTAPI, enableSpeech: Bool = false) {
        self.api = api
        
        #if !os(watchOS)
        if enableSpeech {
            synthesizer = .init()
        }
        #endif
        self.chatCount = 1
    }
    
    @MainActor
    func promptSend(ignore:Bool=true) async {
        let text = inputMessage
        inputMessage = ""
//        #if os(iOS)
//        await sendAttributed(text: text,ignore:ignore)
//        #else
        await send(text: text,ignore:ignore)
//        #endif
    }
    
    @MainActor
    func sendTapped(ignore:Bool=false, overCount:Int=10) async {
        self.chatCount = self.chatCount + 1
        let text = inputMessage
        inputMessage = ""
//        if(questionCount==1){
//            isInterviewOver=true
//            self.api.changePrompt(text: realInterviewPrompts[2])
//        }
        if(!isInterviewOver){
//            if (self.chatCount % 3 == 0){
//                self.api.changePrompt(text: realInterviewPrompts[1])
//                print(realInterviewPrompts[1])
//            }else{
//                self.api.changePrompt(text: realInterviewPrompts[0])
//                print(realInterviewPrompts[0])
//            }
//            self.chatCount = self.chatCount + 1
//
//            if(self.chatCount == overCount){
//                isInterviewOver = true
//            }
            print("chatcount")
            print(self.chatCount)
            print("isover")
            print(isInterviewOver)
            if(overCount==2){
                
            }
            else{
//                if (self.chatCount % 3 == 0){
//                    self.api.changePrompt(text: realInterviewPrompts[1])
//                    print(realInterviewPrompts[1])
//                }else{
//                    self.api.changePrompt(text: realInterviewPrompts[0])
//                    print(realInterviewPrompts[0])
//                }
//                self.api.changePrompt(text: realInterviewPrompts[2])
                
                if(self.chatCount>5){
                    self.api.changePrompt(text: realInterviewPrompts[4])
                }
                else if(self.chatCount>3){
                    self.api.changePrompt(text: realInterviewPrompts[3])
                }
                else{
                    self.api.changePrompt(text: realInterviewPrompts[2])
                }
                
            }
            
//            #if os(iOS)
//            await sendAttributed(text: text,ignore:ignore)
//            #else
            await send(text: text)
//            #endif
            if(self.chatCount == overCount){
                isInterviewOver = true
            }
        }
    }
    
    @MainActor
    func clearMessages() {
        stopSpeaking()
        api.deleteHistoryList()
        withAnimation { [weak self] in
            self?.messages = []
        }
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
//        #if os(iOS)
//        await sendAttributed(text: message.sendText,ignore:message.isIgnore)
//        #else
        await send(text: message.sendText)
//        #endif
    }
    
    #if os(iOS)
    @MainActor
    private func sendAttributed(text: String, ignore:Bool=false) async {
        isInteractingWithChatGPT = true
        
        let parsingTask = ResponseParsingTask()
        let attributedSend = await parsingTask.parse(text: text)
        
        var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChatGPT: true,
            isIgnore: ignore, sendImage: "profile",
            send: .attributed(attributedSend),
            responseImage: "openai",
            responseError: nil)

        self.messages.append(messageRow)
        
        let parserThresholdTextCount = 64
        var currentTextCount = 0
        var currentOutput: AttributedOutput?
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                currentTextCount += text.count
                
                if currentTextCount >= parserThresholdTextCount || text.contains("```") {
                    currentOutput = await parsingTask.parse(text: streamText)
                    currentTextCount = 0
                }

                if let currentOutput = currentOutput, !currentOutput.results.isEmpty {
                    let suffixText = streamText.trimmingPrefix(currentOutput.string)
                    var results = currentOutput.results
                    let lastResult = results[results.count - 1]
                    var lastAttrString = lastResult.attributedString
                    if lastResult.isCodeBlock {
                        lastAttrString.append(AttributedString(String(suffixText), attributes: .init([.font: UIFont.systemFont(ofSize: 12).apply(newTraits: .traitMonoSpace), .foregroundColor: UIColor.white])))
                    } else {
                        lastAttrString.append(AttributedString(String(suffixText)))
                    }
                    results[results.count - 1] = ParserResult(attributedString: lastAttrString, isCodeBlock: lastResult.isCodeBlock, codeBlockLanguage: lastResult.codeBlockLanguage)
                    messageRow.response = .attributed(.init(string: streamText, results: results))
                } else {
                    messageRow.response = .attributed(.init(string: streamText, results: [
                        ParserResult(attributedString: AttributedString(stringLiteral: streamText), isCodeBlock: false, codeBlockLanguage: nil)
                    ]))
                }
                
                self.messages[self.messages.count - 1] = messageRow
                
            }
        } catch {
            messageRow.responseError = error.localizedDescription
            messageRow.response = .rawText(streamText)
        }
        
        if let currentString = currentOutput?.string, currentString != streamText {
            let output = await parsingTask.parse(text: streamText)
            messageRow.response = .attributed(output)
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        
        isInteractingWithChatGPT = false
        //speakLastResponse()
    }
    #endif
    
    @MainActor
    private func send(text: String, ignore:Bool=false) async {
        isInteractingWithChatGPT = true
        //var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChatGPT: true,
            isIgnore: ignore,
            sendImage: "profile",
            send: .rawText(text),
            responseImage: "openai",
            response: .rawText(""),
            responseError: nil)
        
        self.messages.append(messageRow)
        
        do {
            let stream = try await api.sendMessage(text)
//            for try await text in stream {
//                streamText += text
//                messageRow.response = .rawText(streamText.trimmingCharacters(in: .whitespacesAndNewlines))
//                self.messages[self.messages.count - 1] = messageRow
//            }
            messageRow.response = .rawText(stream.trimmingCharacters(in:.whitespacesAndNewlines))
            self.messages[self.messages.count - 1] = messageRow
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractingWithChatGPT = false
        speakLastResponse()
        
    }
    
    func speakLastResponse() {
        #if !os(watchOS)
        guard let synthesizer, let responseText = self.messages.last?.responseText, !responseText.isEmpty else {
            return
        }
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: responseText)
        utterance.voice = .init(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        synthesizer.speak(utterance )
        #endif
    }
    
    func stopSpeaking() {
        #if !os(watchOS)
        synthesizer?.stopSpeaking(at: .immediate)
        #endif
    }
    
}


