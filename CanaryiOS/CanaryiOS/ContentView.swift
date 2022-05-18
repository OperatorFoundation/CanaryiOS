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
    let logTitle = "run log"
    
    @State private var configLocation = ""
    @State private var numberOfRuns = 1
    let step = 1
    let range = 1...10
    
    var body: some View {
            VStack{
                Spacer()
                Text(configTitle)
                TextField(configLocation, text: $configLocation)
                Button(browseButton)
                {
                    //Browse for file functionality
                }
                Spacer()
            }
            VStack{
                Text(runTimePrompt)
                Stepper(value: $numberOfRuns,
                                in: range,
                                step: step) {}
                Button(runButton)
                {
                    //Run functionality
                }
                Spacer()
            }
            VStack{
                Text(logTitle)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
