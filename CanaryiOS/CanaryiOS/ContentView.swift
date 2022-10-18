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

// Combination of tutorial and OG code:
//struct Results: Identifiable {
//    let id: Int
//    let dateStamp: String
//    let serverIP: String
//    let transport: String
//    //let success: String
//
//    init?(csv: String) {
//        let fields = csv.components(separatedBy: ",")
//        guard fields.count == 4 else { return nil }
//
//        self.id = Int(fields[0]) ?? 0
//        self.dateStamp = fields[1]
//        self.serverIP = fields[2]
//        self.transport = fields[3]
//        //self.success = fields[3]
//    }
//}
//
//struct ResultsView:View {
//    @State private var results = [Results]()    // Stores the array of results
//    var body: some View {
//        List(results) { results in
//            VStack(alignment: .leading) {
//                Text("\(results.dateStamp) \(results.serverIP)")
//                    .font(.headline)
//                Text("\(results.transport)")        // TODO: add \(results.success)/
//            }
//        }
//        .task {
//            do {
//                let url = URL(string: "CanaryResults.csv")!
//                let resultsData = url.lines.compactMap(Results.init)
//
//                for try await result in resultsData {
//                    results.append(result)
//                }
//            } catch {
//                // Stop adding user when an error is thrown
//            }
//        }
//    }
//}

// SWIFT Tutorial code:
struct User: Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let country: String

    init?(csv: String) {
        let fields = csv.components(separatedBy: ",")
        guard fields.count == 4 else { return nil }

        self.id = Int(fields[0]) ?? 0
        self.firstName = fields[1]
        self.lastName = fields[2]
        self.country = fields[3]
    }
}
// SWIFT Tutorial code:
struct ResultsView: View {
    @State private var users = [User]()
    
    var body: some View {
        List(users) { user in
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.headline)

                Text(user.country)
            }
        }
        .task {
            do {
                let url = URL(string: "https://hws.dev/users.csv")!
                let userData = url.lines.compactMap(User.init)

                for try await user in userData {
                    users.append(user)
                }
            } catch {
                // Stop adding user when an error is thrown
            }
        }
    }
}

// OG code:
//struct ResultsView:View
//{
//    var body: some View{
//        let shareResultsButtonText = "Share Results csv"
//        VStack(alignment:.center)
//        {
//            HStack(alignment:.center){
//                Spacer()
//                Spacer()
//                Button(shareResultsButtonText){
//                }
//            }
//            let results: [ResultLine] = formatResults()
//            List {
//                ForEach(results) {result in
//                    ResultsCardView(result: result)
//                }
//            }
//        }
//    }
//
//    func formatResults() -> [ResultLine]{
//        //get file location
//        var results: [ResultLine] = []
//        let badResult = [ResultLine(datestamp: "a time", transportType: "not one", success: "Impossible", serverIP: "Not an IP"), ResultLine(datestamp: "a time", transportType: "not one", success: "Impossible", serverIP: "Not an IP")]
//        let AppDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let resultsFile = AppDirectory.appendingPathComponent("CanaryResults.csv")
//        //open CSV
//        let data = try! DataFrame.init(contentsOfCSVFile: resultsFile)
//        for row in data.rows.reversed() {
//            print(row)
//            guard let dateStamp = row[row.startIndex] as? String else {
//                print("\n failed to read datestamp from CanaryResults.csv")
//                return badResult
//             }
//
//            guard let serverIP = row[row.startIndex + 1] as? String else {
//                print("\n failed to read IP from CanaryResults.csv")
//                return badResult
//            }
//
//            guard let transport = row[row.startIndex + 2] as? String else {
//                print("\n failed to read transport from CanaryResults.csv")
//                return badResult
//            }
//
//            guard let success = row[row.startIndex + 3] as? Bool else {
//                print("\n failed to read success from CanaryResults.csv")
//                return badResult
//            }
//
//            let trial = ResultLine(datestamp: dateStamp, transportType: transport, success: String(success), serverIP: serverIP)
//            results.append(trial)
//        }
//
//        return results
//    }
//}

struct ContentView: View
{
    //Display Strings
    let configTitle: String = "Transport config directory:"
    let configSearchPrompt = "Please select the directory where your config files are located."
    let browseButtonTitle = "Select Config Directory"
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
    @State var appHomeDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    @State var configDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CanaryConfigs")
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
                            let _ = self.makeConfigDirectory()
                            Text(browseButtonTitle)
                        }
                            .sheet(isPresented: self.$showDirectoryPicker)
                            {
                                DirectoryPickerView(directoryURL: $configDirectory)
                            }
                    }
                    
                    //create sample config button
//                   Button(createSampleButtonTitle)
//                    {
//                        do {
//                            //make URLs
//                            let AppDirectory = getDocumentsDirectory()
//                            let hotConfigDirectory = AppDirectory.appendingPathComponent("configsToUseInTest")
//
//                            //check to see if anything at configDirectory exists, if not, make the directory
//                            if !FileManager.default.fileExists(atPath: hotConfigDirectory.absoluteString){
//                                try! FileManager.default.createDirectory(at: hotConfigDirectory, withIntermediateDirectories: true, attributes: nil)
//                            }
//                            //save sample config
//                            let sampleConfigReference = hotConfigDirectory.appendingPathComponent("sampleShadowSocksConfig.json")
//                            let sampleConfigContents = ##" {"serverIP":"PII","port":PII,"password":"PII","cipherName":"DarkStar","cipherMode":"DarkStar"}"##
//
//
//
//                            try sampleConfigContents.write(to: sampleConfigReference, atomically: true, encoding: .utf8)
//                            //let checkWork = try String(contentsOf: sampleConfigReference)
//                            //print(checkWork)
//                            }
//                            catch{
//                            print("sampleConfig failed to write")
//                            print(error)
//                            }
//
//                }
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
                                let resultsDirectory = AppDirectory.appendingPathComponent("results")
                            //check to see if resultsDirectory exists, if not, make one.
                                if !FileManager.default.fileExists(atPath: resultsDirectory.absoluteString){
                                    try! FileManager.default.createDirectory(at: resultsDirectory, withIntermediateDirectories: true, attributes: nil)
                                }
                                //get today's date for the name of the results document
                                let dateComponent = getDate()
                                let resultsFileName = dateComponent+"_Results.csv"
                                let resultsFile = resultsDirectory.appendingPathComponent(resultsFileName)
                                if !FileManager.default.fileExists(atPath: resultsFile.path){
                                    try! FileManager.default.createFile(atPath: resultsFile.path, contents: nil, attributes: nil)
                                }

                                print("run button pressed")
                                canaryController.runCanary(configDirectory: configDirectory, resultsDirectory: resultsFile,  numberOfTimesToRun: numberOfRuns)
                                
//                                while( success == false) {
//                                    if !results.contains(trialName){
//                                        //copy and delete the csv in hotConfigDirectory to results
//                                        let source = appHomeDirectory.appendingPathComponent("results.csv")
//                                        let dest = resultsDirectory.appendingPathComponent(trialName).path
//                                        try  FileManager.default.copyItem(atPath: source.path, toPath: dest)
//                                        if FileManager.default.fileExists(atPath: source.path) {
//                                            try FileManager.default.removeItem(atPath: source.path)
//                                        }
//
//                                        success = true
//                                    } else {
//                                        iteration += 1
//
//                                        trialName = mutatingDate + "_" + String(iteration) + ".csv"
//                                    }
//                                }
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
    
    func getDate() ->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateString.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        return  formattedDate
    }
    
    func makeConfigDirectory(){
        do{
            let AppDirectory = getDocumentsDirectory()
            let hotConfigDirectory = AppDirectory.appendingPathComponent("CanaryConfigs")
            if !FileManager.default.fileExists(atPath: hotConfigDirectory.absoluteString){
                                            try! FileManager.default.createDirectory(at: hotConfigDirectory, withIntermediateDirectories: true, attributes: nil)
            }
        }
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
    
