//
//  SettingModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import Foundation

struct SettingModel: Hashable {
    var title: String
    var destination: String
    
    init(title: String, destination: String) {
        self.title = title
        self.destination = destination
    }
    
}
