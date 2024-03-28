//
//  SettingListView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI
import AcknowList
import UIKit

struct SettingListView: View {
    @Binding var isLogoutAlert: Bool
    @Binding var isSignoutAlert: Bool
    
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
            SettingCellView(title: "작성한 게시글", destination: MyPostsView())
            SettingCellView(title: "저장한 게시글", destination: ScrapPostsView())
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
                        .padding(.trailing, 10)
                        .foregroundStyle(Color.gray)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                SettingListDivider()
            }
            VStack(spacing: 0) {
                Button(action: {
                    NotificationManager.instance.openAppSettings()
                }, label: {
                    HStack(alignment: .bottom){
                        Text("알림 설정")
                            .padding(.leading, 20)
                            .font(.pretendardRegular_18)
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .padding(.trailing, 10)
                            .foregroundStyle(Color.gray)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                })
                SettingListDivider()
                
            }
            SettingCellView(title: "고객센터", destination: CustomerServiceView())
            SettingCellView(title: "오픈소스 라이선스", destination: AcknowListViewControllerView())
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
            HStack(alignment: .bottom){
                Text(title)
                    .padding(.leading, 20)
                    .font(.pretendardRegular_18)
                    .foregroundStyle(Color.black)
                
                Spacer()
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 10)
                    .foregroundStyle(Color.gray)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            SettingListDivider()
            
        }
    }
}

struct SettingTitleView: View {
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .padding(.leading, 20)
                    .font(.pretendardSemiBold_18)
                    .foregroundStyle(Color.customGreen)
                
                Spacer()
            }
            .modifier(SettingTitleModifier())
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .padding(.horizontal, 20)
    }
}

struct AcknowListViewControllerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AcknowListViewController {
        // Create AcknowListViewController instance
        let acknowList = AcknowListViewController(fileNamed: "Pods-EYE-Mate-acknowledgements")
        
//        acknowList.navigationItem.leftBarButtonItem = nil
//        let navigationController = UINavigationController(rootViewController: acknowList)
//        navigationController.navigationBar.topItem?.hidesBackButton = true
//        
//        // Customize back button
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        backButton.tintColor = UIColor.black // Set the color to black
//        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
//        
        
        return acknowList
    }
    func updateUIViewController(_ uiViewController: AcknowListViewController, context: Context) {
        // Update the view controller if needed
        
    }
}


#Preview {
    SettingListView(isLogoutAlert: .constant(false), isSignoutAlert: .constant(false))
}
