//
//  ContentView.swift
//  CanaryiOS
//
//  Created by Robert on 5/18/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ResultsView:View
{
    var results: String
   
    var body: some View{
        VStack(alignment:.center)
        {
            HStack(alignment:.center){
                //return home button
                //share button
                //view other result button
            }
            Text("Test Results: \(results)")
        }
    }
}

struct ContentView: View
{
    //Display Strings
    let configTitle: String = "Transport config directory:"
    let configSearchPrompt = "Please select the directory where your config files are located."
    let browseButtonTitle = "Browse"
    let numberOfRunsPrompt = "How many times do you want to run the test?"
    let runButtonTitle = "Run Test"
    let logTitle = "Run Log"
    let runTimes = " Time(s)"
    let step = 1
    let numberOfRunsRange = 1...10

    @State private var numberOfRuns = 1
    @State private var runLogs = ""
    @State private var insideResultsView = false
    @State var configDirectory: URL = FileManager.default.temporaryDirectory
    @State var showDirectoryPicker = false
    
    
    var body: some View
    {
    NavigationView
        {
            VStack(alignment: .center)
            {
                VStack(alignment: .center, spacing: 10) // Config Directory UI
                {
                    Text(configTitle)
                    Text(configDirectory.lastPathComponent).padding()
                        .foregroundColor(.gray)

                    Button(action: { self.showDirectoryPicker.toggle() })
                    {
                        Text(browseButtonTitle)
                    }
                        .sheet(isPresented: self.$showDirectoryPicker)
                        {
                            DirectoryPickerView(directoryURL: $configDirectory)
                        }
                }
                .padding(10)
                
                Divider()
                Spacer()
                
                VStack(alignment: .center) // Run Tests UI
                {
                    Text(numberOfRunsPrompt)
                    Stepper(value: $numberOfRuns, in: numberOfRunsRange, step: step)
                    {
                        Text(String(numberOfRuns)+runTimes)
                    }
                        .padding(10)
                    HStack(alignment: .center){
                        Button(runButtonTitle)
                        {
                            //Run functionality
                            let canaryController = CanaryController()
                            
                            do
                            {
                                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)

                                if directoryContents.isEmpty
                                {
                                    // TODO: For test purposes only, this is not a valid config.
                                    let testFileURL = documentDirectory.appendingPathComponent("emptyShadowConfig.json")
                                    let testFileContents = "{\"password\": \"abc123\", \"cipherName\": \"DarkStar\", \"serverIP\": \"0.0.0.0\", \"port\": 0000}"

                                    try testFileContents.write(to: testFileURL, atomically: true, encoding: .utf8)
                                }
                                
                                canaryController.runCanary(configDirectory: configDirectory, numberOfTimesToRun: numberOfRuns)
                                }
                                catch
                                {
                                    // print("")
                                }
                            NavigationLink(destination: Text("secondView"), isActive: $insideResultsView) {EmptyView()}
                            self.insideResultsView = true
                        }
                        NavigationLink(destination: ResultsView( results: "results"))
                        {
                            Text("View Results")
                        }
                        .padding(10)
                    }
                   
                }
                Divider()
                Spacer()
                
                VStack(alignment: .center) // Logs UI
                {
                    Text(logTitle)
                    ScrollView
                    {
                       VStack
                        {
                            Text(runLogs)
                                .lineLimit(nil)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                
            } // Main VStack
        } // body
    }//NavigationView
} // ContentView

struct DirectoryPickerView: UIViewControllerRepresentable
{
    @Binding var directoryURL: URL
    
    func makeCoordinator() -> DocumentPickerCoordinator
    {
        return DocumentPickerCoordinator(directoryURL: $directoryURL)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DirectoryPickerView>) -> UIDocumentPickerViewController
    {
        let controller: UIDocumentPickerViewController
        
        if #available(iOS 14, *)
        {
            controller = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        }
        else
        {
            controller = UIDocumentPickerViewController(documentTypes: [UTType.folder.identifier], in: .import)
        }
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DirectoryPickerView>) {
        // Not used currently
    }
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate
{
    @Binding var directoryURL: URL
    
    init(directoryURL: Binding<URL>)
    {
        _directoryURL = directoryURL
    }
    
    // This is called when the user makes a selection
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        print(">> Document Picker didPickDocumentsAt called.")
        if let selectedURL = urls.first
        {
            directoryURL = selectedURL
            print("Selected url: \(selectedURL)")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(configDirectory: FileManager.default.temporaryDirectory)
    }
}
