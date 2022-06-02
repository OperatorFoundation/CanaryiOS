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
    @State private var runLogs = " Lorem ipsum dolor sit amet, consectetur adipiscing\n elit. Sed sed ante felis. Quisque nisl mauris, rutrum molestie ipsum quis,\n pellentesque molestie tellus. Donec commodo, justo non congue tristique, tortor\n felis posuere purus, sodales eleifend turpis diam in tellus. Vestibulum a scelerisque\n odio. Praesent eleifend lectus leo, eu pulvinar ligula eleifend id.\n Fusce ac mollis dolor. Donec at tempor nunc. Nam suscipit urna at neque iaculis,\n fermentum volutpat metus iaculis. In facilisis commodo lacus, eget rhoncus urna\n elementum ut. Ut id justo a quam convallis accumsan. Duis vehicula posuere felis,\n non faucibus ipsum commodo nec. Proin luctus urna augue, nec aliquam mauris\n suscipit sed.\n\nSuspendisse laoreet eu metus at tristique. Morbi nec lectus et massa ornare\n scelerisque sit amet et sapien. Fusce non hendrerit nibh. Sed ac mi ex. Cras\n suscipit justo nunc, et elementum leo aliquet ac. Nunc fringilla/n tempor mauris\n a rutrum. Maecenas purus nisl, tempor nec lobortis varius, laoreet at enim. Sed\n magna turpis, congue nec mi nec, imperdiet tempor urna. Proin vehicula risus/n id sem accumsan fermentum. Aenean porttitor elementum ultricies. Etiam/n pellentesque sollicitudin ante sit amet hendrerit."
    
    
    var body: some View {
        VStack(alignment: .center){
                Text(configTitle)
            TextField("test", text: $configLocation) {}
                .multilineTextAlignment(.center)
                .foregroundColor(Color.red)

            Button(browseButton) {
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
//                //Run functionality
//                let canaryController = CanaryController()
//                
//                do
//                {
//                    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                    
//                    canaryController.runCanary(configDirectory: documentDirectory, numberOfTimesToRun: numberOfRuns)
//                }
//                catch
//                {
//                    // print("")
//                }
            }
            .buttonStyle(.bordered)
        }
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
