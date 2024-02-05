//
//  SettingViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    @Published var settingModels: [SettingModel]
    
    init(settingModels: [SettingModel] = [
        .init(title: "", destination: "")
    ]
    
    ) {
        self.settingModels = settingModels
    }
}
