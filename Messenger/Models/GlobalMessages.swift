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
    let recordId: CKRecord.ID?
    
    init(recordId: CKRecord.ID? = nil, content: String) {
        self.content = content
        self.recordId = recordId
    }
    
    func toDictionary() -> [String: Any] {
        return ["content": content]
    }
    
    static func fromRecord(_ record: CKRecord) -> GlobalMessages? {
        guard let content = record.value(forKey: "content") as? String else {
            return nil
        }
        
        return GlobalMessages(recordId: record.recordID, content: content)
    }
}
