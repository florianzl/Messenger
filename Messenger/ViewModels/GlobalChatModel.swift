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
    
    func saveMessage(content: String) {
        
        let record = CKRecord(recordType: RecordType.globalMessages.rawValue)
        let globalMessage = GlobalMessages(content: content)
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
        
        database.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap { $0.1 }
                    .forEach {
                        switch $0 {
                        case .success(let record):
                            print(record)
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
}


/*
class CKGlobalChatModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var messages: [String] = []
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    init() {
        fetchGlobalMessages()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else {return}
        addGlobalMessage(content: text)
    }
    
    private func addGlobalMessage(content: String) {
        let newGlobalMessage = CKRecord(recordType: "GlobalMessages")
        newGlobalMessage["content"] = content
        saveGlobalMessage(record: newGlobalMessage)
    }
    
    private func saveGlobalMessage(record: CKRecord) {
        publicDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Record: \(String(describing: returnedRecord))")
            print("Error: \(String(describing: returnedError))")
            
            DispatchQueue.main.async {
                self?.text = ""
            }
            
        }
    }
    
    private func fetchGlobalMessages() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "GlobalMessages", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [String] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    print("success")
                    guard let content = record["content"] as? String else {return}
                    returnedItems.append(content)
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { record in
                guard let content = record["content"] as? String else {return}
                returnedItems.append(content)
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in 
                DispatchQueue.main.async {
                    switch returnedResult {
                    case .success(_):
                        print("query was successful")
                        self?.messages = returnedItems
                    case .failure(_):
                        print("error")
                    }
                }
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                print("returned queryCompletionBlock")
                DispatchQueue.main.async {
                    self?.messages = returnedItems
                }
            }
        }
        
        print(messages)
        
    }
}*/
