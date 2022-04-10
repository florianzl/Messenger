//
//  TabView.swift
//  Messenger
//
//  Created by Florian Zitlau on 26.03.22.
//

import SwiftUI
import CloudKit

struct TabHandlerView: View {
    
    @StateObject private var ckUser = CKUserModel()
    
    var body: some View {
        TabView {
            
            GlobalChatView(vm: GlobalChatModel(container: CKContainer.default()))
                .tabItem {
                    Image(systemName: "globe.americas")
                    Text("Global Chat")
                }
            
            Text("private chats coming soon")
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }
            
        }
    }
}

struct TabHandlerView_Previews: PreviewProvider {
    static var previews: some View {
        TabHandlerView()
    }
}
