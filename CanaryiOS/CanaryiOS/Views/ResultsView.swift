//
//  ResultsView.swift
//  CanaryiOS
//
//  Created by Mafalda on 10/24/22.
//

import SwiftUI

struct ResultsView:View
{
    @State var results: [Results]
    @State var canaryResult: CanaryResult
    
    var body: some View
    {
        List(results)
        {
            result in
            
            VStack(alignment: .leading){
                Text("Transport Name: \(result.transport)")
                Text("Test Result: \(result.success == "true" ? "Success" : "Failed")")
                Text("Server Address: \(result.serverIP)")
                Text("Test Date: \(result.dateStamp)")
            }
            
        }
        .navigationTitle(canaryResult.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ShareLink(item: canaryResult.document, preview: SharePreview(canaryResult.name))
        }
    }
}

// TODO: 
//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView(results: <#[Results]#>, canaryResult: <#CanaryResult#>)
//    }
//}
