//
//  ResultListView.swift
//  CanaryiOS
//
//  Created by Mafalda on 10/24/22.
//

import SwiftUI

struct ResultListView: View
{
    @State var canaryResults: [CanaryResult]
    
    init()
    {
        if let results = ResultListView.getContentsOfResultsDirectory()
        {
            self.canaryResults = results
            print("Showing \(results.count) results.")
        }
        else
        {
            self.canaryResults = [CanaryResult]()
            print("There are no results to show")
        }
    }
    
    var body: some View
    {
        List(canaryResults)
        {
            result in
            
            NavigationLink(destination: ResultsView(results: getResultsData(canaryResult: result) ?? [Results](), canaryResult: result))
            {
                Text(result.name)
            }
            
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func getResultsData(canaryResult: CanaryResult) -> [Results]?
    {
        var results = [Results]()
        do
        {
            // Parse file content into TestResult objects
            let resultString = try String(contentsOf: canaryResult.url)
            var rows = resultString.components(separatedBy: "\n")
            
            guard rows.count > 1 else
            {
                print("Result file was empty")
                return nil
            }
            
            rows.removeFirst()
            
            for aRow in rows
            {
                if let newResult = Results(csvString: aRow)
                {
                    results.append(newResult)
                }
            }
            
            print("Found \(results.count) rows in \(canaryResult.name) results.")
            
            if results.isEmpty
            {
                return nil
            }
            else
            {
                print("Created results data:")
                print(results)
                return results
            }
            
        }
        catch
        {
            return nil
        }
        
    }
    
    static func getContentsOfResultsDirectory() -> [CanaryResult]?
    {
        let appHomeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let resultsDirectory = appHomeDirectory.appendingPathComponent(resultDirectoryName)

        do
        {
            let results = try FileManager.default.contentsOfDirectory(at: resultsDirectory, includingPropertiesForKeys: nil)
            var canaryResults = [CanaryResult]()
            
            if results.isEmpty
            {
                print("No result files were found in \(resultsDirectory.path)")
                return nil
            }
            
            for result in results
            {
                let name = result.deletingPathExtension().lastPathComponent
                let canaryResult = CanaryResult(name: name, url: result)
                canaryResults.append(canaryResult)
                print("Found result \(name)")
            }
            
            return canaryResults
        }
        catch
        {
            print("Failed to get the contents of \(resultsDirectory.path)")
            print("Error: \(error)")
            return nil
        }
    }
}

struct ResultListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultListView()
    }
}
