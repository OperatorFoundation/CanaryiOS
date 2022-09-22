//
//  ShareViewController.swift
//  ReceiveConfig
//
//  Created by Robert on 7/25/22.
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

@objc(ShareExtensionViewController)
class ShareViewController: UIViewController{
    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        print("view DidAppear")
        
        // Get the object that holds whatever was shared. If not, dismiss view.
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                print("closing view did appear")
                return
        }
        
        // Check if object is of type text
        print("Checking shared item")
        if itemProvider.hasItemConformingToTypeIdentifier(typeText) {
            print("item conforms to text")
            handleIncomingText(itemProvider: itemProvider)
        // Check if object is of type URL
        } else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeJSON as String) {
            print("item conforms to kuttypeJSON")
            handleIncomingURL(itemProvider: itemProvider)
        } else {
            print("Error: No url or text found")
         self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
     }
}
    
@objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }

    
private func handleIncomingURL(itemProvider: NSItemProvider) {
    itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { (item, error) in
        if let error = error {
            print("URL-Error: \(error.localizedDescription)")
        }
        print("starting URL hanlder")

        if let url = item as? NSURL, let urlString = url.absoluteString {
            print(urlString)
        }

        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}


private func handleIncomingText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeText, options: nil) { (item, error) in
            if let error = error {
                print("Text-Error: \(error.localizedDescription)")
            }
            print("starting text handler")
            if let text = item as? String {
                do {
                    // Detect URLs in String
                    let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(
                        in: text,
                        options: [],
                        range: NSRange(location: 0, length: text.utf16.count)
                    )
                    // Get first URL found
                    if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                        print(text[range])
                    }
                } catch let error {
                    print("Do-Try Error: \(error.localizedDescription)")
                }
            }

            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
}

    


    
//    private func save (filename: String, json:String){
//        let path = FileManager.default.urls(for: .doc)
//    }
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }

}
