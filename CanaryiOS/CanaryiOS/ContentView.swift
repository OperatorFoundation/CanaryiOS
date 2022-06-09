//
//  ContentView.swift
//  CanaryiOS
//
//  Created by Robert on 5/18/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    //Display Strings
    let configTitle: String = "Transport load Config"
    let configSearchPrompt = "Please enter the location of your Transport load Config"
    let browseButtonTitle = "Browse"
    let runTimePrompt = "How many times do you want to run the test?"
    let runButtonTitle = "Run Test"
    let logTitle = "Run Log"
    let runTimes = " Time(s)"
    //Constants
    let step = 1
    let range = 1...10
    //vars
    @State private var configLocation = "No Config Loaded"
    @State private var numberOfRuns = 1
    @State private var runLogs = " Lorem ipsum "
    @State var shows = false
    
    
    var body: some View
    {
        VStack(alignment: .center)
        {
            Text(configTitle)
            TextField("test", text: $configLocation) {}
                .multilineTextAlignment(.center)
                .foregroundColor(Color.red)

            Button(action: { self.shows.toggle() })
            {
                Text("Select File")
            }
                .sheet(isPresented: self.$shows)
                {
                    DirectoryPickerView()
                }

            Spacer()
                .frame(height: 55)
        }
        
        VStack(alignment: .center)
        {
                Text(runTimePrompt)
            ZStack(alignment: .center)
            {
                //Spacer(minLength:25)
                Text(String(numberOfRuns)+runTimes)
                Stepper(value: $numberOfRuns,
                                in: range,
                                step: step){}
                Spacer(minLength:25)
            }
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
                    
                    canaryController.runCanary(configDirectory: documentDirectory, numberOfTimesToRun: numberOfRuns)
                }
                catch
                {
                    // print("")
                }
            }
            .buttonStyle(.bordered)
        }
        Spacer()
            .frame(height: 40)
        VStack(alignment: .center){
            Text(logTitle)
            ScrollView {
                           VStack {
                                Text(runLogs)
                                     .lineLimit(nil)
                           }.frame(maxWidth: .infinity)
            }
        }
    }
}

struct DirectoryPickerView: UIViewControllerRepresentable
{
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        //
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController
    {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder])
        
            return documentPicker
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
