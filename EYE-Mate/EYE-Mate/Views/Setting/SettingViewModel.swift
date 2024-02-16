//
//  SettingViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    @Published var profileList: [SettingListModel]
    @Published var communityList: [SettingListModel]
    @Published var appList: [SettingListModel]
    @Published var accountList: [SettingListModel]
    
    
    init(
        profileList: [SettingListModel] = [
            .init(title: "프로필 사진 변경", icon: "chevron.forward"),
            .init(title: "닉네임 변경", icon: "chevron.forward"),
        ],
        communityList: [SettingListModel] = [
            .init(title: "작성한 게시글", icon: "chevron.forward"),
            .init(title: "작성한 댓글", icon: "chevron.forward"),
            .init(title: "저장한 게시글", icon: "chevron.forward"),
        ],
        appList: [SettingListModel] = [
            .init(title: "앱 버전", icon: ""),
            .init(title: "고객센터", icon: "chevron.forward"),
            .init(title: "오픈소스 라이선스", icon: "chevron.forward"),
            .init(title: "개인정보 처리방침", icon: "chevron.forward"),
        ],
        accountList: [SettingListModel] = [
            .init(title: "로그아웃", icon: "chevron.forward"),
            .init(title: "회원탈퇴", icon: "chevron.forward"),
        ]
        
    ) {
        self.profileList = profileList
        self.communityList = communityList
        self.appList = appList
        self.accountList = accountList
    }
    
}
