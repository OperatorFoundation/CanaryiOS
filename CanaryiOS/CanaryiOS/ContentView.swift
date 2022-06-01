//
//  ContentView.swift
//  CanaryiOS
//
//  Created by Robert on 5/18/22.
//

import SwiftUI

struct ContentView: View {
    //Display Strings
    let configTitle: String = "Transport load Config"
    let configSearchPrompt = "Please enter the location of your Transport load Config"
    let browseButton = "Browse"
    let runTimePrompt = "How many times do you want to run the test?"
    let runButton = "Run Test"
    let logTitle = "Run Log"
    let runTimes = " Time(s)"
    //Constants
    let step = 1
    let range = 1...10
    //vars
    @State private var configLocation = "No Config Loaded"
    @State private var numberOfRuns = 1
    @State private var runLogs = ["demo","data","replace","with","actual","logs"] //fixme, demo data
    
    
    
    var body: some View {
        VStack(alignment: .center){
                Text(configTitle)
            TextField("test", text: $configLocation){}
                .multilineTextAlignment(.center)
                .foregroundColor(Color.red)

            Button(browseButton)
            {
                // FIXME: fileBrowser
                // let fileBrowser = FileBrowser()
                // present(fileBrowser, animated: true, completion: nil)
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            }
        VStack(alignment: .center){
                Text(runTimePrompt)
            ZStack(alignment: .center){
                //Spacer(minLength:25)
                Text(String(numberOfRuns)+runTimes)
                Stepper(value: $numberOfRuns,
                                in: range,
                                step: step){}
                Spacer(minLength:25)
            }
            Button(runButton)
            {
                //Run functionality
                let canaryController = CanaryController()
                
                do
                {
                    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    
                    canaryController.runCanary(configDirectory: documentDirectory, numberOfTimesToRun: numberOfRuns)
                }
                catch
                {
                    // print("")
                }
                
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .center){
                Text(logTitle)
                Text("")
                Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
