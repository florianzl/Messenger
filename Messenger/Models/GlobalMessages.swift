//
//  GlobalMessages.swift
//  Messenger
//
//  Created by Florian Zitlau on 09.04.22.
//

import Foundation
import CloudKit

struct GlobalMessages {
    let content: String
    let username: String
    let recordId: CKRecord.ID?
    let timestamp: Date
    
    init(recordId: CKRecord.ID? = nil, content: String, username: String, timestamp: Date) {
        self.content = content
        self.username = username
        self.recordId = recordId
        self.timestamp = timestamp
    }
    
    func toDictionary() -> [String: Any] {
        return ["content": content, "username": username, "timestamp": timestamp]
    }
    
    static func fromRecord(_ record: CKRecord) -> GlobalMessages? {
        guard let content = record.value(forKey: "content") as? String , let username = record.value(forKey: "username") as? String , let timestamp = record.value(forKey: "timestamp") as? Date else {
            return nil
        }
        
        return GlobalMessages(recordId: record.recordID, content: content, username: username, timestamp: timestamp)
    }
}
