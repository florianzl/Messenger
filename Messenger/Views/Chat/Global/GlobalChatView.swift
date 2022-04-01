//
//  GlobalChatView.swift
//  Messenger
//
//  Created by Florian Zitlau on 26.03.22.
//

import SwiftUI

//hide keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct GlobalChatView: View {
    @State var tmp = ""
    
    var body: some View {
        
            VStack {
                
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
                
                ScrollViewReader {reader in
                    
                    ScrollView {
                        
                        VStack(spacing: 15) {
                            Text("test")
                            Text("test")
                            Text("test")
                            Text("test")
                            Text("test")
                            
                            /*
                            ForEach(homeData.msgs) {msg in
                                ChatRow(chatData: msg)
                                    .onAppear {
                                        if msg.id == self.homeData.msgs.last!.id && scrolled {
                                            
                                            reader.scrollTo(homeData.msgs.last!.id, anchor: .bottom)
                                            scrolled = true
                                        }
                                    }
                            }
                            .onChange(of: homeData.msgs) { value in
                                reader.scrollTo(homeData.msgs.last!.id, anchor: .bottom)
                            }*/
                        }
                        .padding(.vertical)
                    }
                }
                
                HStack(spacing: 15) {
                    
                    TextField("Enter Message", text: $tmp) {
                        if true { //check if message != ""
                            //send message
                            UIApplication.shared.endEditing()
                        }
                    }
                        .padding(.horizontal)
                        .frame(height: 45)
                        .background(Color.primary.opacity(0.06))
                        .clipShape(Capsule())
                    
                    if true { //check if message != ""
                        Button {
                            //send message
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .background(Color("accentColor"))
                                .clipShape(Circle())
                        }

                    }
                }
                .padding()
            }
            .background(Color("backgroundColor"))
            .ignoresSafeArea(.all, edges: .top)
    }
}


struct GlobalChatView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalChatView()
    }
}
