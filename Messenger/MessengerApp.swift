//
//  MessengerApp.swift
//  Messenger
//
//  Created by Florian Zitlau on 16.03.22.
//

import SwiftUI
import CloudKit


@main
struct MessengerApp: App {
    
    //public container
    let container = CKContainer(identifier: "iCloud.me.florianzitlau.IOSMessenger")
    
    var body: some Scene {
        WindowGroup {
            TabHandlerView()
        }
    }
}
