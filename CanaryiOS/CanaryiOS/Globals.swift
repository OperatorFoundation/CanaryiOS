//
//  Globals.swift
//  CanaryiOS
//
//  Created by Joseph Bragel on 6/9/22.
//

import Foundation
import Logging

let serverIPKey = "ServerIP"
let configPathKey = "ConfigPath"

var uiLog = Logger(label: "CanaryiOS", factory: CanaryLogHandler.init)
var globalRunningLog = RunningLog()

class RunningLog: ObservableObject
{
    @Published var logString: String = ""
}

let resultDirectoryName = "results"
let resultFileName = "CanaryResults"
let resultExtension = ".csv"

let configDirectoryName = "CanaryConfigs"
