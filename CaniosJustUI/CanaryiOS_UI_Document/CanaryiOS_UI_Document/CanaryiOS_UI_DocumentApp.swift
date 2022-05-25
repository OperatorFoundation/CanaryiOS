//
//  CanaryiOS_UI_DocumentApp.swift
//  CanaryiOS_UI_Document
//
//  Created by Robert on 5/23/22.
//

import SwiftUI

@main
struct CanaryiOS_UI_DocumentApp: App {
    var body: some Scene {
        WindowGroup{
            ContentView()
        }
        DocumentGroup(newDocument: CanaryiOS_UI_DocumentDocument()) { file in
            ContentView()//document: file.$document)
        }
    }
}
