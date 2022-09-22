//
//  ContentView.swift
//  CanaryiOS
//
//  Created by Robert on 5/18/22.
//

import SwiftUI
import UniformTypeIdentifiers

var configFileName: String = "blank"

struct configSelectionView:View
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
            Text("configs: \(results)")
        }
    }
}

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
    let createSampleButtonTitle = "Create Sample Config"
    let step = 1
    let numberOfRunsRange = 1...10

    @State private var numberOfRuns = 1
    @State private var runLogs = ""
    @State private var insideResultsView = false
    @State var configDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("configDirectory")
    @State var showDirectoryPicker = false
    
    var justShared: some Scene{
        WindowGroup{
            ContentView().onOpenURL(perform: {url in
            })
        }
    }
    
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
                    
                   //browse for config button
                    HStack(alignment: .center){
                        Button(action: { self.showDirectoryPicker.toggle() })
                        {
                            Text(browseButtonTitle)
                        }
                            .sheet(isPresented: self.$showDirectoryPicker)
                            {
                                DirectoryPickerView(directoryURL: $configDirectory)
                            }
                        NavigationLink(destination: configSelectionView( results: "results"))
                        {
                            Text("Select Config")
                        }
                    }
                    
                        
                    //create sample config button
                    Button(createSampleButtonTitle)
                    {
                        do {
                            //make URLs
                            let AppDirectory = getDocumentsDirectory()
                            let hotConfigDirectory = AppDirectory.appendingPathComponent("configsToUseInTest")
                            
                            //check to see if anything at configDirectory exists, if not, make the directory
                            if !FileManager.default.fileExists(atPath: hotConfigDirectory.absoluteString){
                                try! FileManager.default.createDirectory(at: hotConfigDirectory, withIntermediateDirectories: true, attributes: nil)
                            }
                            //save sample config
                            let sampleConfigReference = configDirectory.appendingPathComponent("sampleShadowConfig.json")
                            let sampleConfigContents = ##" {"serverIP":"137.184.77.191","serverPort":5678,{"password":"9caa4132c724f137c67928e9338c72cfe37e0dd28b298d14d5b5981effa038c9","cipherName":"DarkStar","cipherMode":"DarkStar"}}"##
                            
                            
                            try sampleConfigContents.write(to: sampleConfigReference, atomically: true, encoding: .utf8)
                            let checkWork = try String(contentsOf: sampleConfigReference)
                            print(checkWork)
                            }
                            catch{
                            print("sampleConfig failed to write")
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
                        //run test button
                        Button(runButtonTitle)
                        {
                            //Run functionality
                            let canaryController = CanaryController()
                            //make URLs
                            let AppDirectory = getDocumentsDirectory()
                            let hotConfigDirectory = AppDirectory.appendingPathComponent("configsToUseInTest")
                            
                            do {
                                print("run button pressed")

                                
                                canaryController.runCanary(configDirectory: hotConfigDirectory, numberOfTimesToRun: numberOfRuns)
                                } //do

                            NavigationLink(destination: Text("secondView"), isActive: $insideResultsView) {EmptyView()}
                            self.insideResultsView = true
                        }//Button(runButtonTitle)
                        
                        NavigationLink(destination: ResultsView( results: "results"))
                        {
                            Text("View Results")
                        }
                        .padding(10)
                    }//HStack
                }//VStack
                    
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
                
                } // Inner VStack
            } // Outer Vstack
        }//NavigationView
    }//body
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
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
    
