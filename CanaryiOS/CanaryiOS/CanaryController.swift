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
    // TODO: Add parameters to runCanary()
    // configDirectory to replace documentDirectory - URL
    // numberOfTimesToRun - Int
    
    func runCanary(configDirectory: URL, numberOfTimesToRun: Int)
    {
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let testFileURL = documentDirectory.appendingPathComponent("shadowSocksClient.json")
            
            if !FileManager.default.fileExists(atPath: testFileURL.path)
            {
                let testFileContents = "{\"password\": \"9caa4132c724f137c67928e9338c72cfe37e0dd28b298d14d5b5981effa038c9\", \"cipherName\": \"DarkStar\", \"serverIP\": \"164.92.71.230\", \"port\": 1234}"
                
                try testFileContents.write(to: testFileURL, atomically: true, encoding: .utf8)
            }
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            print("Printing contents of the document directory: ")
            for fileURL in directoryContents
            {
                print(fileURL.path)
            }
            
            let logger = Logger(label: "CanaryLibraryiOSExample")
            // TODO: replace documentDirectory with user provided directory
            let canary = Canary(configPath: configDirectory.path, logger: logger, timesToRun: numberOfTimesToRun)
            
            canary.runTest(runAsync: true)
        }
        catch
        {
            print("Failed to find the document directory.")
        }
    }
}
