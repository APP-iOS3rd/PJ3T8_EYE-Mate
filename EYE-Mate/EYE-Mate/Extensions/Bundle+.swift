//
//  Extensions.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import Foundation

// APIKEY 를 가져오기 위한 Bundle extension
extension Bundle {
    var nmapClientId : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["NmapClientId"] as? String else { return nil }
        return key
    }
    
    var nmapSecret : String? {
        guard let file = self.path(forResource: "APIKEY-Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["NmapSecret"] as? String else { return nil }
        return key
    }
}
