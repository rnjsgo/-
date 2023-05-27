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
    @State private var messageRow: FeedbackButtonView?
    
    @State private var messages:[FeedbackButtonView] = []
    
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
            chatListView
                .navigationTitle("피드백")
                .navigationBarTitleDisplayMode(.inline)
                //.navigationBarItems(leading: )
                .onAppear{
                    for message in vm.messages  {
                        let m = message.copy(messageRow: message)
                        self.messages.append(FeedbackButtonView(message: m))
                        self.messages.append(FeedbackButtonView(message: m,isResponse: true))
                    }
                    print(self.messages)
                }
    }
    
    var chatListView: some View {
        ScrollView{
            ForEach(self.messages) { message in
                Button(action: {
                    messageRow = message
                }, label:{
                    message
                }).buttonStyle(PlainButtonStyle())
            }.sheet(item: $messageRow){message in
                feedbackSheetView(message:message, vm:vm)
            }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static let message2 = MessageRow(
        isInteractingWithChatGPT: false, sendImage: "profile",
        send: .rawText("What is SwiftUI?가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하"),
        responseImage: "openai",
        response: .rawText("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하"))


    static let m: [FeedbackButtonView]=[
        FeedbackButtonView(message: message2),
        FeedbackButtonView(message: message2,isResponse: true),
        FeedbackButtonView(message: message2),
        FeedbackButtonView(message: message2,isResponse: true)
    ]

    static var previews: some View {
        ScrollView {
            ForEach(m){ mm in
                mm
            }
        }
    }
}

struct feedbackSheetView: View{
    var message: FeedbackButtonView
    var vm: ViewModel
    @State private var text:String = ""
    
    var body: some View{
        ScrollView{
            message
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

struct FeedbackButtonView: View, Identifiable{
    var id = UUID()
    var isIgnore : Bool = false
    var text: String
    var image: String
    var responseError:String?
    
    init(message:MessageRow, isResponse:Bool=false){
        if(isResponse){
            self.text = message.responseText!
            self.image = message.responseImage
            if(message.responseError != nil){
                self.responseError = message.responseError!
            }
        }else{
            self.text = message.sendText
            self.image = message.sendImage
            self.isIgnore = message.isIgnore
        }
    }
    
    var body: some View{
        if(!isIgnore){
            VStack{
                HStack(alignment: .center, spacing:24) {
                        Image(image).resizable()
                            .frame(width: 32, height: 32)
                        
                        VStack(alignment: .leading) {
                            if !text.isEmpty {
                                Text(text)
                                    .frame(width:300,alignment: .leading)
                                    .textSelection(.enabled)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            if let error = responseError {
                                Text("Error: \(error)")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    HStack{
                        Rectangle().size(width:50, height:1).foregroundColor(Color(hex: "#7B7B7B"))
                    }.frame(width: 50, height:1)
                }
        }
    }
}


