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

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.6 : 0.8)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ResultsCardView: View {
    let result: ResultLine
    var body: some View {
        HStack{
            VStack{
                Text("Test Date")
                Text(result.datestamp)
            }
        }
    }
}

struct SelectAnotherDayView:View{
    @Binding var canaryResults: [CanaryResult]
    
    var body: some View{
        VStack{
            Text("Results")
            canaryResults = getContentsOfResultsDirectory()
            List(canaryResults)
            {
                
                   result in
                    
                //viewingResult = result.name
                Text(result.name)
                
            }
            
//            ForEach(canaryResults, id: \.self){result in
//                Button(result){
//                    viewingResult = result
//                    let removeCSV = result.replacingOccurrences(of: resultExtension, with: "")
//                    resultDate = removeCSV.replacingOccurrences(of: resultFileName, with: "")
//                }
//                .buttonStyle(BlueButton())
//                .padding()
//            }
        }
    }
    
    func getContentsOfResultsDirectory() -> [CanaryResult]{
        let appHomeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let resultsDirectory = appHomeDirectory.appendingPathComponent(resultDirectoryName)
    
        do
        {
            let results = try FileManager.default.contentsOfDirectory(atPath: resultsDirectory.path)
            var canaryResults = [CanaryResult]()
            
            for result in results {
                let name = result.replacingOccurrences(of: resultExtension, with: "")
                let canaryResult = CanaryResult(name: name, filename: result)
                canaryResults.append(canaryResult)
            }
            
            return canaryResults
        }
        catch
        {
            print("Failed to get the contents of \(resultsDirectory.path)")
            print("Error: \(error)")
            return []
        }
    }
    
    func getDate() ->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateString.replacingOccurrences(of: "/", with: "_", options: .literal, range: nil)
        return  formattedDate
    }
}

 //Results View
struct Results: Identifiable {
    let id: UUID
    let dateStamp: String
    let serverIP: String
    let transport: String
    let success: String

    init?(csv: String) {
        let fields = csv.components(separatedBy: ",")
        guard fields.count == 4 else { return nil }
        self.id = UUID() //Int(fields[0]) ?? 0
        self.dateStamp = fields[0]
        self.serverIP = fields[1]
        self.transport = fields[2]
        self.success = fields[3]
    }
}

struct ResultsView:View {
    @State private var results = [Results]()// Stores the array of results
    //@Binding var showSheetView: Bool
    @State private var isShare = false
    //@State var shareText: ShareText?
    var shareButtonTitle = "Share these Results"
    var AnotherDaysResultsTitle = "Select another Day"
    var body: some View {
        VStack{
            HStack{
                Button(shareButtonTitle){
                    
                    let resultsToShare = [getResultsURL()]
                    share(items: resultsToShare)
                    //print("pressed share results")
                }
                .buttonStyle(GrowingButton())
                
                NavigationLink(destination: SelectAnotherDayView())
                {
                    Text(AnotherDaysResultsTitle)
                }
                .buttonStyle(BlueButton())

            }
            Text(viewingResult)
            List(results.reversed()) { results in
                VStack(alignment: .leading) {
                    Text("\(results.dateStamp) \(results.serverIP)")
                        .font(.headline)
                    Text("\(results.transport)\(results.success)")
                }
            }
            .task {
                do {
                    if (resultDate == "today"){
                        resultDate = getDate()
                    }
                    let resultsFile = getResultsURL()
                    let resultsData = resultsFile.lines.compactMap(Results.init)

                    results = []
                    for try await result in resultsData {
                        results.append(result)
                    }
                } catch {
                    // Stop adding user when an error is thrown
                }
            }
        }
    }
    
    @discardableResult
    func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]? = nil
    ) -> Bool {
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
            return false
        }
        let vc = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        vc.excludedActivityTypes = excludedActivityTypes
        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
        return true
    }
    
    //function which gets the date in the right format to select today's result
    func getDate() ->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateString.replacingOccurrences(of: "/", with: "_", options: .literal, range: nil)
        return  formattedDate
    }
    
    //function which pulls the result of whatever day the global resultDate is pointed at. 
    func getResultsURL() -> URL{
        let fileName = resultFileName + resultDate + resultExtension
        let appHomeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let resultsDirectory = appHomeDirectory.appendingPathComponent(resultDirectoryName)
        let resultsFile = resultsDirectory.appendingPathComponent(fileName)
        return resultsFile
    }
}

struct ContentView: View
{
    @State private var isValidConfigPath = false
    @State private var configPath = UserDefaults.standard.string(forKey: configPathKey) ?? "Config Directory Needed"
    
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
    
    @ObservedObject var runningLog = globalRunningLog
    @State private var numberOfRuns = 1
    @State private var runLogs = ""
    @State private var insideResultsView = false
    @State var appHomeDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    @State var configDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(configDirectoryName)
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
                            .buttonStyle(BlueButton())
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
                        //run test button
                        Button(runButtonTitle)
                        {
                            do{
                                let canaryController = CanaryController()
                                //make paths
                                let AppDirectory = getDocumentsDirectory()
                                let resultsDirectory = AppDirectory.appendingPathComponent(resultDirectoryName)
                                
                                //check to see if resultsDirectory exists, if not, make one.
                                if !FileManager.default.fileExists(atPath: resultsDirectory.absoluteString)
                                {
                                    try FileManager.default.createDirectory(at: resultsDirectory, withIntermediateDirectories: true, attributes: nil)
                                }
                                
                                //get today's date for the name of the results document
                                if !FileManager.default.fileExists(atPath: resultsDirectory.path)
                                {
                                    FileManager.default.createFile(atPath: resultsDirectory.path, contents: nil, attributes: nil)
                                }
                                
                                viewingResult = resultFileName + getDate() + resultExtension
                                canaryController.runCanary(configDirectory: configDirectory, resultsDirectory: resultsDirectory,  numberOfTimesToRun: numberOfRuns)
                            }
                            catch
                            {
                                print("Error preparing directories: \(error)")
                            }
                        }
                        .buttonStyle(BlueButton())
                        
                        NavigationLink(destination: ResultsView())
                        {
                            Text("View Results")
                        }
                        .buttonStyle(BlueButton())
                        .padding(10)
                    }
                }
                    
                Divider()
                Spacer()
                
                VStack(alignment: .center) // Logs UI
                    {
                        Text(logTitle)
                        
                        ScrollViewReader // Test Log with automatic scrolling
                        {
                            sp in
                            
                            ScrollView
                            {
                                // TODO: add .textSelection(.enabled) when appropriate to discontinue support of macOS 11 (only available on macOS 12+)
                                Text(runningLog.logString)
                                    .id(0)
                                    .onChange(of: runningLog.logString)
                                {
                                    Value in
                                    sp.scrollTo(0, anchor: .bottom)
                                }
                            }
                            .frame(maxHeight: 150)
                        }
                        .onAppear()
                        {
                            isValidConfigPath = validate(configURL: URL(string: configPath))
                        }
                        .padding(.vertical)
                    
//                    ScrollView
//                    {
//                       VStack
//                        {
//                            Text(runLogs)
//                                .lineLimit(nil)
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
                }
                .padding()
                
                } // Inner VStack
            } // Outer Vstack
        }//NavigationView
    }//body
    
    func validate(configURL: URL?) -> Bool
    {
        guard let isaURL = configURL
        else { return false }
        
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: isaURL.path, isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
    
    func getDate() ->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateString.replacingOccurrences(of: "/", with: "_", options: .literal, range: nil)
        return  formattedDate
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func makeConfigDirectory(){
        let readMeText = "place configs in this folder and CanaryiOS will read them"
        let readMeTitle = "ReadMe"
        
        do{
            let AppDirectory = getDocumentsDirectory()
            let hotConfigDirectory = AppDirectory.appendingPathComponent("CanaryConfigs")
            if !FileManager.default.fileExists(atPath: hotConfigDirectory.absoluteString){
                                            try! FileManager.default.createDirectory(at: hotConfigDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            
            let configReadMeURL = hotConfigDirectory.appendingPathComponent(readMeTitle, isDirectory: false)
            if !FileManager.default.fileExists(atPath: configReadMeURL.path){
                FileManager.default.createFile(atPath: configReadMeURL.path, contents: nil )
            }
            do{
                try readMeText.write(to: configReadMeURL, atomically: true, encoding: .utf8)
                print("refreshed readme")
            }
            catch{
                print("readme bad")
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

struct CanaryResult: Identifiable {
    let id = UUID()
    let name: String
    let filename: String
    
}
    
