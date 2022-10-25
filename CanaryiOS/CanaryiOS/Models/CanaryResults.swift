//
//  CanaryResults.swift
//  CanaryiOS
//
//  Created by Mafalda on 10/24/22.
//

import Foundation
import SwiftUI

struct CanaryResult: Identifiable
{
    let id = UUID()
    let name: String
    let url: URL
    let document: ResultDocument
    
    init(name: String, url: URL)
    {
        self.name = name
        self.document = ResultDocument(url: url)
        self.url = url
    }
}

struct ResultDocument: Transferable
{
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation
    {
        FileRepresentation(exportedContentType: .commaSeparatedText)
        {
            result in
            
            SentTransferredFile(result.url)
        }
    }
}


// MARK: In an actual app you should not use this to display results as the backing library could change the way the results file is formatted in the future which would break this struct and any views using it to display results.
struct Results: Identifiable
{
    let id: UUID
    let dateStamp: String
    let serverIP: String
    let transport: String
    let success: String

    init?(csvString: String)
    {
        let fields = csvString.components(separatedBy: ",")
        
        guard fields.count == 4 else
        { return nil }
        
        self.id = UUID()
        self.dateStamp = fields[0]
        self.serverIP = fields[1]
        self.transport = fields[2]
        self.success = fields[3]
    }
}
