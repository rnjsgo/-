//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Alfian Losari on 01/02/23.
//

import SwiftUI
import AVKit

struct MicChatView: View {
    var cf:ContextFlow?
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    
    
    @State var isRecording:Bool = false
    //recording instance
    @State var session : AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var player: AVAudioPlayer!
    @State var alert=false
    @State var recFileString:URL!
    //@State var playing:Bool = false
    var body: some View {
        NavigationStack{
            chatListView
                .navigationTitle("XCA ChatGPT")
            NavigationLink("feedbackview", destination:LazyView(FeedbackView(vm:vm)), isActive: $vm.isInterviewOver).hidden()
        }
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                }
#if os(iOS) || os(macOS)
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
#endif
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
                }
//            .onChange(of: vm.isInterviewOver){_ in
//                NavigationStack{
//                    FeedbackView(vm:vm,messages)
//                }
//            }
            .onChange(of: vm.isInteractingWithChatGPT){_ in
                let str:String = vm.messages.last?.responseText ?? "없어용"
                Task{
                    if(!vm.isInteractingWithChatGPT){
                        await TTS.shared.getSpeech(from : str){result in
                            do{
                                var data = try Data(contentsOf: result)
                                
                                if((self.player != nil && !self.player.isPlaying) ||
                                   (self.player == nil)
                                   && !isRecording) {
                                    try self.player = AVAudioPlayer(data:data)
                                    try? session.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
                                    self.player.setVolume(15, fadeDuration: 9999999)
                                    self.player.play()
                                }
                            }catch{
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack {
            
            
            
            //            TextField("Send message", text: $vm.inputMessage, axis: .vertical)
            //                #if os(iOS) || os(macOS)
            //                .textFieldStyle(.roundedBorder)
            //                #endif
            //                .focused($isTextFieldFocused)
            //                .disabled(vm.isInteractingWithChatGPT)
            
            if vm.isInteractingWithChatGPT {
                DotLoadingView().frame(width: 60, height: 60).overlay(
                    RoundedRectangle(cornerRadius: 120)
                        .stroke(.black, lineWidth: 4)
                        .frame(width:75,height:75)
                    )
            } else {
                Button(action: {
//                    self.isRecording.toggle()
                    
//                    Task { @MainActor in
//                        scrollToBottom(proxy: proxy)
//                        await vm.sendTapped()
//                    }
//                    Initialization
                    do{
                        if self.isRecording{
                            //버튼을 눌렀을때 이미 레코딩중이다 -> 레코딩을 중지하고 저장
                            self.recorder.stop()
                            self.isRecording.toggle()
                            do{
                                let rec = try Data(contentsOf:self.recFileString)
                                STT.shared.getText(data: rec){result in
                                    print(result)
                                    vm.inputMessage = result as! String
                                    Task{@MainActor in
                                        scrollToBottom(proxy: proxy)
                                        await vm.sendTapped()
                                    }
                                }
                            }catch{
                                print(error.localizedDescription)
                            }
                            
                            //let rec = Data(from: self.recFileString)
                            return
                        }
                            if let p = self.player{
                                if p.isPlaying{
                                    player.stop()
                                }
                            }
     
                        
                        
                        let fileManager = FileManager.default
                        let documentURL = fileManager.urls(for:.documentDirectory, in:.userDomainMask).first!
                        //let dateFormatter = DateFormatter()
                        
                        //dateFormatter.dateFormat="YYYYMMDDHHMMSS"
                        //저장될 파일 이름
                        //let fileName = documentURL.appendingPathComponent(dateFormatter.string(from:Date())+"Q.m4a")
                        let fileName = documentURL.appendingPathComponent("Q.m4a")
                        let settings=[
                            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 44100,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue
                        ]
                        
                        self.recorder = try AVAudioRecorder(url:fileName, settings:settings)
                        self.recorder.record()
                        self.isRecording.toggle()
                        self.recFileString = fileName
                    }
                   catch{
                       print(error.localizedDescription)
                    }
                    
                },label: {
                    if self.isRecording{
                        Image(image)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 120)
                                    .stroke(.black, lineWidth: 4)
                                    .frame(width:75,height:75)
                                )
                    }else{
                        Image(image)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                                
                }).buttonStyle(PlainButtonStyle())
//                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
    }.padding(.horizontal, 16)
        .padding(.top, 20)
        .alert(isPresented: self.$alert, content:{
            Alert(title:Text("오류"), message: Text("접근권한을 확인해주세요"))
        })
        .onAppear{
            print("-----------------------------면접시작-----------------------------")
            do{
                self.session=AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                self.session.requestRecordPermission{(status) in
                    if !status{
                        //에러메세지
                        self.alert.toggle()
                    }
                }
            }catch{
                print(error.localizedDescription)
            }
            Task { @MainActor in
                scrollToBottom(proxy: proxy)
                vm.inputMessage="너는 지금부터 면접관이고 나는 면접 대상자야. 가벼운 인사와 함께 이 다음 문장을 질문으로 해줘 "+(cf?.selectedQuestion ?? "질문을 찾을수 없습니다")
                await vm.promptSend(ignore:true)
            }
        }
}
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct MicChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MicChatView(vm: ViewModel(api: ChatGPTAPI(apiKey: "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")))
        }
    }
}
