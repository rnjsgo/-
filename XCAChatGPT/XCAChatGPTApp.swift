//
//  XCAChatGPTApp.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI

@main
struct XCAChatGPTApp: App {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "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"))
    @State var isShowingTokenizer = false
    
    var body: some Scene {
//        WindowGroup {
//            NavigationStack {
//                ContentView(vm: vm)
//                    .toolbar {
//                        ToolbarItem {
//                            Button("Clear") {
//                                vm.clearMessages()
//                            }
//                            .disabled(vm.isInteractingWithChatGPT)
//                        }
//
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button("Tokenizer") {
//                                self.isShowingTokenizer = true
//                            }
//                            .disabled(vm.isInteractingWithChatGPT)
//                        }
//                    }
//            }
//            .fullScreenCover(isPresented: $isShowingTokenizer) {
//                NavigationTokenView()
//            }
//        }
        WindowGroup{
            HomeView()
            //MicChatView(vm: vm)
        }
    }
}


struct NavigationTokenView: View {
    
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
        .interactiveDismissDisabled()
    }
}


