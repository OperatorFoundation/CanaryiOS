//
//  ContentView.swift
//  CanaryiOS
//
//  Created by Robert on 5/18/22.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation
import TabularData

var configFileName: String = "blank"
var results = ["1","2"]


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
            let configNameList: [ConfigIdentifier] = [ConfigIdentifier(name: "test1"), ConfigIdentifier(name: "test2")]
            List {
                ForEach(configNameList) {name in
                    ConfigCardView(configName: "test")
                }
            }
        }
    }
}

struct ConfigCardView: View{
    let configName: String
    var body: some View {
        let buttontext = "test"
        Button(buttontext){
            //go to results view
        }
    }
}


struct ResultsCardView: View {
    let result: ResultLine
    var body: some View {
        
        HStack{
            VStack{
                Text("Test Date")
                Text(result.datestamp)
                Text("Server IP")
                Text(result.serverIP)
            }
            Spacer()
            VStack{
                Text("Success")
                Text(result.success)
                Text("Transport")
                Text(result.transportType)
            }
        }
    }
}

struct ResultsView:View
{
    var body: some View{
        let shareResultsButtonText = "Share Results csv"
        VStack(alignment:.center)
        {
            HStack(alignment:.center){
                Spacer()
                Spacer()
                Button(shareResultsButtonText){
                }
            }
            let results: [ResultLine] = formatResults()
            List {
                ForEach(results) {result in
                    ResultsCardView(result: result)
                }
            }
        }
    }
    
    func formatResults() -> [ResultLine]{
        //get file location
        var results: [ResultLine] = []
        let badResult = [ResultLine(datestamp: "a time", transportType: "not one", success: "Impossible", serverIP: "Not an IP"), ResultLine(datestamp: "a time", transportType: "not one", success: "Impossible", serverIP: "Not an IP")]
        let AppDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let resultsFile = AppDirectory.appendingPathComponent("CanaryResults.csv")
        //open CSV
        let data = try! DataFrame.init(contentsOfCSVFile: resultsFile)
        for row in data.rows.reversed() {
            print(row)
            guard let dateStamp = row[row.startIndex] as? String else {
                print("\n failed to read datestamp from CanaryResults.csv")
                return badResult
             }
            
            guard let serverIP = row[row.startIndex + 1] as? String else {
                print("\n failed to read IP from CanaryResults.csv")
                return badResult
            }
            
            guard let transport = row[row.startIndex + 2] as? String else {
                print("\n failed to read transport from CanaryResults.csv")
                return badResult
            }
            
            guard let success = row[row.startIndex + 3] as? Bool else {
                print("\n failed to read success from CanaryResults.csv")
                return badResult
            }
           
            let trial = ResultLine(datestamp: dateStamp, transportType: transport, success: String(success), serverIP: serverIP)
            results.append(trial)
        }
        
        return results
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
                            let sampleConfigReference = hotConfigDirectory.appendingPathComponent("sampleShadowSocksConfig.json")
                            let sampleConfigContents = ##" {"serverIP":"137.184.77.191","port":5678,"password":"9caa4132c724f137c67928e9338c72cfe37e0dd28b298d14d5b5981effa038c9","cipherName":"DarkStar","cipherMode":"DarkStar"}"##

                            
                            
                            try sampleConfigContents.write(to: sampleConfigReference, atomically: true, encoding: .utf8)
                            //let checkWork = try String(contentsOf: sampleConfigReference)
                            //print(checkWork)
                            }
                            catch{
                            print("sampleConfig failed to write")
                            print(error)
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
                            do{
                                let canaryController = CanaryController()
                                //make paths
                                let AppDirectory = getDocumentsDirectory()
                                let hotConfigDirectory = AppDirectory.appendingPathComponent("configsToUseInTest")
                                let resultsDirectory = AppDirectory.appendingPathComponent("results")
                            //check to see if resultsDirectory exists, if not, make one.
                                if !FileManager.default.fileExists(atPath: resultsDirectory.absoluteString){
                                    try! FileManager.default.createDirectory(at: resultsDirectory, withIntermediateDirectories: true, attributes: nil)
                                }
  
                            //get current results list
                                results = try FileManager.default.contentsOfDirectory(atPath: resultsDirectory.path)
                                //do the test
                                canaryController.runCanary(configDirectory: hotConfigDirectory, numberOfTimesToRun: numberOfRuns)
                                //before we leave the screen, save the result with time of use.
                                //format a name that is unique.
                                let date = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd/MM/yy"
                                let dateComponent: String = dateFormatter.string(from: date)
                                var mutatingDate: String  = dateComponent
                                var iteration = 99
                                var EndComponent: String = "_test_" + String(iteration) + ".csv"
                                var trialName: String = mutatingDate + EndComponent
                                var success = false
                                while( success == false) {
                                    if !results.contains(trialName){
                                        //copy and delete the csv in hotConfigDirectory to results
                                        let source = hotConfigDirectory.appendingPathComponent("results.csv")
                                        let dest = resultsDirectory.appendingPathComponent(trialName).path
                                        try  FileManager.default.copyItem(atPath: source.path, toPath: dest)
                                        if FileManager.default.fileExists(atPath: source.path) {
                                            try FileManager.default.removeItem(atPath: source.path)
                                        }
                                        
                                        success = true
                                    } else {
                                        iteration += 1
                                        
                                        trialName = mutatingDate + "_" + String(iteration) + ".csv"
                                    }
                                }
                            }
                            catch let error as NSError {
                                print(error)
                            }
                                
                            NavigationLink(destination: Text("secondView"), isActive: $insideResultsView) {EmptyView()}
                            self.insideResultsView = true
                        }//Button(runButtonTitle)
                        
                        NavigationLink(destination: ResultsView())
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
    
