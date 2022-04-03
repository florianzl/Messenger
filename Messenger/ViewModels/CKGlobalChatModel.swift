//
//  CKGlobalChatModel.swift
//  Messenger
//
//  Created by Florian Zitlau on 03.04.22.
//

import Foundation
import CloudKit

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
                    guard let content = record["content"] as? String else {return}
                    returnedItems.append(content)
                case .failure(let error):
                    print("Error recordMatchedBlock: \(error)")
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { (returnedRecord) in
                guard let content = returnedRecord["content"] as? String else {return}
                returnedItems.append(content)
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                print("returned queryResultBlock: \(returnedResult)")
                DispatchQueue.main.async {
                    self?.messages = returnedItems
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
        
    }
}
