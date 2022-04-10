//
//  CKUserModel.swift
//  Messenger
//
//  Created by Florian Zitlau on 02.04.22.
//

import Foundation
import CloudKit

class CKUserModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var id: String = ""
    let container = CKContainer.default()
    
    init() {
        requestPermission()
        fetchRecordID()
    }
    
    func requestPermission() {
        container.requestApplicationPermission([.userDiscoverability]) { returnedStatus,
            returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .denied {
                    print("denied")
                }
            }
            
        }
    }
    
    func fetchRecordID() {
        container.fetchUserRecordID { returnedID, error in
            if let id = returnedID {
                self.discoverUser(id: id)
            }
        }
    }
    
    func discoverUser(id: CKRecord.ID) {
        container.discoverUserIdentity(withUserRecordID: id) { identity, error in
            DispatchQueue.main.async {
                if let name = identity?.nameComponents?.givenName {
                    self.userName = name
                }
                if let id = identity?.userRecordID?.recordName {
                    self.id = id
                }
            }
        }
    }
}
