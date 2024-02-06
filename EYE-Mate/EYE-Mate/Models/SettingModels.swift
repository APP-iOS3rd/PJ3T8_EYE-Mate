//
//  SettingModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import Foundation

// MARK: - 설정 list 뷰 모델
struct SettingListModel: Hashable {
    var title: String
    var icon: String
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
    
}



//  MARK: - 탈퇴하기 뷰 모델
struct SignOutContent: Hashable {
    var icon: String
    var title: String
    var subTitle: String
    
    init(icon: String, title: String, subTitle: String) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        
    }
    
}
