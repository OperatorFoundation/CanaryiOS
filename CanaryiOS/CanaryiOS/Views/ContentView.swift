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


struct ContentView: View
{
    let resultDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(resultDirectoryName)
    let numberOfRunsRange = 1...10
    
    //Display Strings
    let configDirectoryLabel = "Transport config directory"
    let testCyclesLabel = "Test Cycles"
    let browseButtonTitle = "Choose Config Directory"
    let runButtonTitle = "Run Tests"
    let viewResultsButtonTitle = "View Results"
    
    @ObservedObject var runningLog = globalRunningLog
    @State private var runLogs = ""
    
    @State private var numberOfRuns = 1
    @State var configDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(configDirectoryName)
    @State var showDirectoryPicker = false
    
    init()
    {
        self.makeConfigDirectory()
    }
    
    var body: some View
    {
        NavigationView
        {
            VStack(alignment: .leading)
            {
                GroupBox(configDirectoryLabel)
                {
                    HStack
                    {
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
                }
                
                GroupBox(testCyclesLabel) {
                    Stepper(numberOfRuns == 1 ? "Run tests 1 time" : "Run tests \(numberOfRuns) times", value: $numberOfRuns, in: numberOfRunsRange, step: 1)
                        .padding(20)
                }
                

                

                HStack
                {
                    Button(runButtonTitle)
                    {
                        do
                        {
                            let canaryController = CanaryController()

                            //check to see if resultsDirectory exists, if not, make one.
                            if !FileManager.default.fileExists(atPath: resultDirectory.absoluteString)
                            {
                                try FileManager.default.createDirectory(at: resultDirectory, withIntermediateDirectories: true, attributes: nil)
                            }

                            canaryController.runCanary(configDirectory: configDirectory, resultsDirectory: resultDirectory,  numberOfTimesToRun: numberOfRuns)
                        }
                        catch
                        {
                            print("Error preparing directories: \(error)")
                        }
                    }
                    .padding()

                    Spacer()

                    NavigationLink(destination: ResultListView())
                    {
                        Text(viewResultsButtonTitle)
                    }
                    .navigationTitle("Canary")
                    .padding()
                }

                Spacer()
            } // Outer Vstack
        }
        
    }//body
    
    func makeConfigDirectory()
    {
        let configReadMeURL = configDirectory.appendingPathComponent("ReadMe", isDirectory: false)
        
        do
        {
            // Create the config directory if it doesn't already exist
            if !FileManager.default.fileExists(atPath: configDirectory.path)
            {
                try FileManager.default.createDirectory(at: configDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Create the readme if it doesn't already exist
            if !FileManager.default.fileExists(atPath: configReadMeURL.path)
            {
                let readMeContent = Data(string: "Place transport config files in this folder to have Canary test those transport connections.")
                FileManager.default.createFile(atPath: configReadMeURL.path, contents: readMeContent)
            }
        }
        catch
        {
            print("Error preparing the config directory: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    
