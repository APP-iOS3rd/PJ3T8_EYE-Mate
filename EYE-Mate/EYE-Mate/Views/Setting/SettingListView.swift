//
//  SettingListView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI

struct SettingListView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            // MARK: - 프로필
            VStack(alignment: .leading, spacing: 0) {
                SettingTitleView(title: "프로필")
                
                ImageActionButtonView(profileViewModel: profileViewModel, isPresented: false)
                SettingCellView(title: "닉네임 변경")
            }
            // MARK: - 커뮤니티
            VStack(alignment: .leading, spacing: 0) {
                SettingTitleView(title: "커뮤니티")
                
                SettingCellView(title: "작성한 게시글")
                SettingCellView(title: "작성한 댓글")
                SettingCellView(title: "저장한 게시글")
            }
            
            // MARK: - 앱
            VStack(alignment: .leading, spacing: 0) {
                SettingTitleView(title: "앱")
                
                VStack(spacing: 0) {
                    HStack{
                        Text("앱 버전")
                            .padding(.leading, 30)
                        Spacer()
                        Text("1.0.2.1")
                            .padding(.trailing, 10)
                    }
                    .frame(width: 330, height: 50)
                    
                    SettingListDivider()
                }
                SettingCellView(title: "고객센터")
                SettingCellView(title: "오픈소스 라이선스")
                SettingCellView(title: "개인정보 처리방침")
            }
            
            
            // MARK: - 계정
            VStack(alignment: .leading, spacing: 0) {
                SettingTitleView(title: "계정")
                
                SettingCellView(title: "로그아웃")
                SettingCellView(title: "탈퇴")
            }
        }
    }
}

struct SettingCellView: View{
    var title: String
    // TODO: destination 도 추가해서 그쪽으로 이동하도록 추가
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text(title)
                    .padding(.leading, 30)
                Spacer()
                
                Button {
                    // Destination으로 이동
                } label: {
                    Image(systemName: "chevron.forward")
                        .padding(.trailing, 10)
                        .foregroundStyle(Color.gray)
                }
                
            }
            .frame(width: 330, height: 50)
            
            SettingListDivider()
            
        }
    }
}

struct SettingTitleView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 30)
                .font(.pretendardSemiBold_20)
                .foregroundStyle(Color.customGreen)
            Spacer()
        }
        .modifier(SettingTitleModifier())
    }
}

#Preview {
    SettingListView(profileViewModel: ProfileViewModel())
}
