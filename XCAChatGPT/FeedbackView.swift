//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI
import AVKit

struct FeedbackView: View {
    var cf:ContextFlow?
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    @State private var messageRow: MessageRow?
    
    @State private var messages:[MessageRow] = []
    
    let coloredNavAppearance = UINavigationBarAppearance()
    init(vm: ViewModel){
        self.vm = vm
        
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.white
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        
        
    }
    
    
    var body: some View {
        NavigationStack{
            
            chatListView
                .navigationTitle("피드백")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    for message in vm.messages  {
                        let m = message.copy(messageRow: message)
                        self.messages.append(m)
                    }
                    print(self.messages)
                }
                
        }
    }
    
    var chatListView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(self.messages) { message in
                            Button(action: {
                                messageRow = message
                            }, label:{
                                MessageRowView(message: message) { _ in
                                    
                                }
                            }).buttonStyle(PlainButtonStyle())
                        }.sheet(item: $messageRow){message in
                            feedbackSheetView(message:message, vm:vm)
                        }
                    }
                }
                Spacer()
            }
        }

    }
}

//struct FeedbackView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            FeedbackView(vm: ViewModel(api: ChatGPTAPI(apiKey: "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"),messages:))
//        }
//    }
//}

struct feedbackSheetView: View{
    var message: MessageRow
    var vm: ViewModel
    @State private var text:String = ""
    
    var body: some View{
        ScrollView{
            MessageRowView(message:message){message in
                
            }
            Text(text).task{
                do{
                    let stream = try! await vm.api.sendMessageStream(text: "자기소개해줘")
                    for try await tmp in stream{
                        text += tmp
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
}
