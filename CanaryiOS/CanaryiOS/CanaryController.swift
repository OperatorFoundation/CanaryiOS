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
    func runCanary(configDirectory: URL, numberOfTimesToRun: Int)
    {
        let logger = Logger(label: "CanaryLibraryiOSExample")
        let canary = Canary(configURL: configDirectory, logger: logger, timesToRun: numberOfTimesToRun)
        
        canary.runTest(runAsync: true)
    }
}
