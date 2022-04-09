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
    
    @State var tmp = ""
    @StateObject private var vm: GlobalChatModel
    @State var content: String = ""
    
    init(vm: GlobalChatModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        
            VStack {
                
                header
                messages
                input
            }
            .onAppear {
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
        VStack {
            List {
                ForEach(vm.messages, id:\.recordId) { message in
                    Text(message.content)
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
                
                vm.saveMessage(content: content)
                
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
