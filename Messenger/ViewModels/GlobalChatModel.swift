//
//  GlobalChatModel.swift
//  Messenger
//
//  Created by Florian Zitlau on 03.04.22.
//

import Foundation
import CloudKit

enum RecordType: String {
    case globalMessages = "globalMessages"
}

class GlobalChatModel: ObservableObject {
    
    private var database: CKDatabase
    private var container: CKContainer
    
    @Published var messages: [GlobalMessageModel] = []
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    
    func saveMessage(content: String, username: String, timestamp: Date) {
        
        let record = CKRecord(recordType: RecordType.globalMessages.rawValue)
        let globalMessage = GlobalMessages(content: content, username: username, timestamp: timestamp)
        record.setValuesForKeys(globalMessage.toDictionary())
        
        //saving record in database
        self.database.save(record) { newRecord, error in
            if let error = error {
                print(error)
            } else {
                if let newRecord = newRecord {
                    if let globalMessages = GlobalMessages.fromRecord(newRecord){
                        DispatchQueue.main.async {
                            self.messages.append(GlobalMessageModel(globalMessages: globalMessages))
                        }
                    }
                }
            }
        }
    }
    
    func fetchMessages() {
        
        var messages: [GlobalMessages] = []
        
        let query = CKQuery(recordType: RecordType.globalMessages.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap { $0.1 }
                    .forEach {
                        switch $0 {
                        case .success(let record):
                            if let globalMessage = GlobalMessages.fromRecord(record) {
                                messages.append(globalMessage)
                            }
                                
                        case .failure(let error):
                            print(error)
                        }
                    }
                
                DispatchQueue.main.async {
                    self.messages = messages.map(GlobalMessageModel.init)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct GlobalMessageModel {
    
    let globalMessages: GlobalMessages
    
    var recordId: CKRecord.ID? {
        globalMessages.recordId
    }
    
    var content: String {
        globalMessages.content
    }
    
    var username: String {
        globalMessages.username
    }
    
    var timestamp: Date {
        globalMessages.timestamp
    }
}

