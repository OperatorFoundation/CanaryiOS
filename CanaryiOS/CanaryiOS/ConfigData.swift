//
//  ConfigData.swift
//  CanaryiOS
//
//  Created by Robert on 7/20/22.
//

import Foundation

struct ConfigData: Codable {
    var password: String
    var cipherName: String
    var serverIP: String
    var port: Int
    
}

//public class ConfigLoader{
//    var config = ConfigData()
//
//    func load(){
//        if let configLocation = Bundle.main.url.(forResource: "mydata", withExtension: "json)") {
//
//    }
//}
