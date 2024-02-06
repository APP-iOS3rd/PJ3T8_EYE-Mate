//
//  SettingListView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI

struct SettingListView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject var settingViewModel = SettingViewModel()
    @State var isPresented: Bool = false
    @Binding var showAlert:Bool
    
    var body: some View {
        VStack(spacing: 30) {
            // MARK: - 프로필
            VStack(alignment: .leading, spacing: 0) {
                SettingTitleView(title: "프로필")
                
                ProfileListView(profileViewModel: profileViewModel)
            }
        }
        // MARK: - 커뮤니티
        VStack(alignment: .leading, spacing: 0) {
            SettingTitleView(title: "커뮤니티")
            SettingCellView(title: "작성한 게시글", destination: Text("작성한 게시글"))
            SettingCellView(title: "작성한 댓글", destination: Text("작성한 댓글"))
            SettingCellView(title: "저장한 게시글", destination: Text("저장한 게시글"))
        }
        
        // MARK: - 앱
        VStack(alignment: .leading, spacing: 0) {
            SettingTitleView(title: "앱")
            HStack{
                Text("앱 버전")
                    .font(.pretendardRegular_18)
                    .padding(.leading, 30)
                Spacer()
                Text("1.0.2.1")
                    .font(.pretendardMedium_18)
                    .padding(.trailing, 10)
                    .foregroundStyle(Color.gray)
            }
            .frame(width: 330, height: 50)
            
            SettingListDivider()
            
            SettingCellView(title: "고객센터", destination: Text("고객센터"))
            SettingCellView(title: "오픈소스 라이선스", destination: Text("고객센터"))
            SettingCellView(title: "개인정보 처리방침", destination: Text("고객센터"))
        }
        
        // MARK: - 계정
        VStack(alignment: .leading, spacing: 0) {
            SettingTitleView(title: "계정")
            
            SettingCellView<Text>(title: "로그아웃")
                .onTapGesture {
                    showAlert = true
                }
            
            SettingCellView(title: "회원 탈퇴", destination: SignOutView())
        }
        
    }
}

struct SettingCellView<Destination: View>: View {
    var title: String
    var destination: Destination? = nil

    var body: some View {
        if let destinationView = destination {
            NavigationLink(destination: destinationView) {
                content
            }
        } else {
            content
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            HStack{
                Text(title)
                    .font(.pretendardRegular_18)
                    .padding(.leading, 30)
                    .foregroundStyle(Color.black)
                
                Spacer()
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 10)
                    .foregroundStyle(Color.gray)
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
    SettingListView(profileViewModel: ProfileViewModel(), showAlert: .constant(false))
}
