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
    @Published private var chatCount:Int
    @Published private var realInterviewPrompts:[String] = ["방금 답변에 대해서 추가적으로 단 하나의 질문을 생성하고 그 질문으로 질문해줘", "이번엔 면접 상황에 맞는 적절한 다른 주제의 새로운 질문을 생성하고 면접자에게 그 질문으로 질문해줘","이번에는 질문을 하지 말고, 지금까지 했던 답변에 대해 피드백 해줘"]
    
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
    func promptSend(ignore:Bool=false) async {
        let text = inputMessage
        inputMessage = ""
        #if os(iOS)
        await sendAttributed(text: text,ignore:ignore)
        #else
        await send(text: text)
        #endif
    }
    
    @MainActor
    func sendTapped(ignore:Bool=false, overCount:Int=2) async {
        let text = inputMessage
        inputMessage = ""
//        if(questionCount==1){
//            isInterviewOver=true
//            self.api.changePrompt(text: realInterviewPrompts[2])
//        }
        if(!isInterviewOver){
            if (self.chatCount % 3 == 0){
                self.api.changePrompt(text: realInterviewPrompts[1])
                print(realInterviewPrompts[1])
            }else{
                self.api.changePrompt(text: realInterviewPrompts[0])
                print(realInterviewPrompts[0])
            }
            self.chatCount = self.chatCount + 1

            if(self.chatCount == questionCount){
                isInterviewOver = true
            }
            print("chatcount")
            print(self.chatCount)
            print("isover")
            print(isInterviewOver)
            if (self.chatCount % 3 == 0){
                self.api.appendPromptToHistoryList(text: realInterviewPrompts[1])
                print(realInterviewPrompts[1])
            }else{
                self.api.appendPromptToHistoryList(text: realInterviewPrompts[0])
                print(realInterviewPrompts[0])
            }
            
            self.chatCount = self.chatCount + 1
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
    private func send(text: String) async {
        isInteractingWithChatGPT = true
        //var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChatGPT: true,
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


