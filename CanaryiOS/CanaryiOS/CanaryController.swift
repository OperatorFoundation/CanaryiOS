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
        let logger = Logger(label: "CanaryLibraryiOSExample")
        let canary = Canary(configDirectoryURL: configDirectory, resultsDirectoryURL: resultsDirectory, logger: logger, timesToRun: numberOfTimesToRun)
        canary.runTest()
        
        print("***********CONFIG DIR**********")
        print(configDirectory)
    }
}
