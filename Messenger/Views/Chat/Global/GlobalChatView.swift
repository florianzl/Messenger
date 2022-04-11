//
//  GlobalChatView.swift
//  Messenger
//
//  Created by Florian Zitlau on 26.03.22.
//

import SwiftUI
import CloudKit

//hide keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct GlobalChatView: View {
    
    @StateObject private var vm: GlobalChatModel
    @StateObject private var ckUser = CKUserModel()
    @State var content: String = ""
    
    func color(username: String) -> Color {
        if username == ckUser.userName {
            return .accentColor
        }
        return .purple
    }
    
    init(vm: GlobalChatModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    
    var body: some View {
        
            VStack {
                
                header
                messages
                input
            }
            .onReceive(vm.$messages) { _ in
                vm.fetchMessages()
            }
            .background(Color("backgroundColor"))
            .ignoresSafeArea(.all, edges: .top)
    }
}


struct GlobalChatView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalChatView(vm: GlobalChatModel(container: CKContainer.default()))
    }
}


extension GlobalChatView {
    private var header: some View {
        HStack {
            
            Text("Global Chat")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Spacer(minLength: 0)
        }
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("accentColor").opacity(0.4))
    }
    
    private var messages: some View {
        ScrollViewReader { reader in
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(vm.messages, id:\.recordId) { message in
                        HStack {
                            
                            if message.username == ckUser.userName {
                                Spacer()
                            }
                            else {
                                VStack {
                                    Spacer()
                                    Text(message.timestamp, style: .time)
                                        .fontWeight(.thin)
                                        .font(.system(size: 15))
                                        .padding(.bottom, 7)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(message.username)
                                    .foregroundColor(color(username: message.username))
                                    .font(.system(size: 20))
                                Text(message.content)
                                    .font(.system(size: 20))
                                
                            }
                            .padding([.top, .bottom], 7)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.4))
                            .clipShape(ChatBubble(ourMsg: message.username == ckUser.userName))
                            
                            if message.username != ckUser.userName {
                                Spacer()
                            }
                            else {
                                VStack {
                                    Spacer()
                                    Text(message.timestamp, style: .time)
                                        .fontWeight(.thin)
                                        .font(.system(size: 15))
                                        .padding(.bottom, 7)
                                }
                            }
                            
                            
                        }
                        .padding(.horizontal)
                    }
                    .onReceive(vm.$messages) { _ in
                        reader.scrollTo(vm.messages.last?.recordId)
                    }
                }
            }
            
        }
    }
    
    private var input: some View {
        HStack(spacing: 15) {
            
            TextField("Enter Message", text: $content)
                .padding(.horizontal)
                .frame(height: 45)
                .background(Color.primary.opacity(0.06))
                .clipShape(Capsule())
            
            Button {
                
                vm.saveMessage(content: content, username: ckUser.userName, timestamp: Date())
                
                self.content = ""
                
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .frame(width: 45, height: 45)
                    .background(Color("accentColor"))
                    .clipShape(Circle())
            }
            .disabled(content.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
    }
}
