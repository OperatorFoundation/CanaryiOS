//
//  CanaryController.swift
//  CanaryiOS
//
//  Created by Joseph Bragel on 6/1/22.
//

import Foundation
import Logging

import CanaryLibraryiOS

class CanaryController
{
    func runCanary(configDirectory: URL, resultsDirectory: URL, numberOfTimesToRun: Int)
    {
        let savePath = resultsDirectory.path
        let logger = Logger(label: "CanaryLibraryiOSExample")
        let canary = Canary(configDirectoryURL: configDirectory, savePath: savePath, logger: logger, timesToRun: numberOfTimesToRun)
        canary.runTest()//runAsync: true)
        print("***********CONFIG DIR**********")
        print(configDirectory)
    }
}
