//
//  SettingListView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI

struct SettingListView: View {
    @Binding var isLogoutAlert:Bool
    @Binding var isSignoutAlert:Bool
    let listWidthSize = UIScreen.main.bounds.width - 70
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            // MARK: - 프로필
            VStack(alignment: .center, spacing: 0) {
                SettingTitleView(title: "프로필")
                
                ProfileListView()
            }
        }
        // MARK: - 커뮤니티
        VStack(alignment: .center, spacing: 0) {
            SettingTitleView(title: "커뮤니티")
            SettingCellView(title: "작성한 게시글", destination: Text("작성한 게시글"))
            SettingCellView(title: "작성한 댓글", destination: Text("작성한 댓글"))
            SettingCellView(title: "저장한 게시글", destination: Text("저장한 게시글"))
        }
        
        // MARK: - 앱
        VStack(alignment: .center, spacing: 0) {
            SettingTitleView(title: "앱")
            VStack(spacing: 0) {
                HStack{
                    Text("앱 버전")
                        .font(.pretendardRegular_18)
                        .padding(.leading, 20)
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    Text("1.0.0")
                        .font(.pretendardMedium_18)
                        .padding(.trailing, 20)
                        .foregroundStyle(Color.gray)
                }
                .frame(width: listWidthSize, height: 50)
                
                SettingListDivider()
            }
            
            SettingCellView(title: "고객센터", destination: CustomerInfoView())
            SettingCellView(title: "오픈소스 라이선스", destination: LicenseView())
        }
        
        // MARK: - 계정
        VStack(alignment: .center, spacing: 0) {
            SettingTitleView(title: "계정")
            
            SettingCellView<Text>(title: "로그아웃")
                .background(Color.white)
                .onTapGesture {
                    isLogoutAlert = true
                }

            SettingCellView<Text>(title: "회원 탈퇴")
                .background(Color.white)
                .onTapGesture {
                    isSignoutAlert = true
                }
        }
        
    }
}

struct SettingCellView<Destination: View>: View {
    var title: String
    var destination: Destination? = nil
    let listWidthSize = UIScreen.main.bounds.width - 70

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
                    .padding(.leading,20)
                    .foregroundStyle(Color.black)
                
                Spacer()
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 20)
                    .foregroundStyle(Color.gray)
            }
            .frame(width: listWidthSize, height: 50)
            
            SettingListDivider()
        }
    }
}

struct SettingTitleView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 20)
                .font(.pretendardSemiBold_20)
                .foregroundStyle(Color.customGreen)
            Spacer()
        }
        .modifier(SettingTitleModifier())
    }
}

#Preview {
    SettingListView(isLogoutAlert: .constant(false), isSignoutAlert: .constant(false))
}
