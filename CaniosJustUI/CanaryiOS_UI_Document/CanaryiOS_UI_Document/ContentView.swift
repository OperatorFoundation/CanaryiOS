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
                browser
//                DocumentGroup(newDocument: CanaryiOS_UI_DocumentDocument()) { file in
//                    ContentView(document: file.$configLocation)
//                    print("button pressed")
//                }
                
                //fix me
                //let fileBrowser = FileBrowser()
                //present(fileBrowser, animated: true, completion: nil)
            }
            
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
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .center){
                Text(logTitle)
                Text("")
                Spacer()
        }
    }
    
    var browser: some View{
        Text("Screen!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




