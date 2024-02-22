//
//  SignOutView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

struct AccountDeleteView: View {
    @ObservedObject var accountDeleteViewModel = AccountDeleteViewModel.shared
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 30) {
            SettingNavigationTitle(isDisplayTitle: false, leftButtonAction: {presentationMode.wrappedValue.dismiss()}, leftButtonType: .close)
            
            Text("탈퇴하기")
                .font(.pretendardSemiBold_32)
            
            Text("잠깐! EYE-Mate를 탈퇴하기 전에\n아래 정보를 확인해주세요")
                .multilineTextAlignment(.center)
                .font(.pretendardSemiBold_18)
                .foregroundColor(Color.warningGray)
            
            AccountDeleteContents(accountDeleteViewModel: accountDeleteViewModel)
            
            Spacer()
            
            HStack {
                Button {
                    // TODO: - 탈퇴창 닫기
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("취소")
                        .font(.pretendardBold_18)
                        .foregroundStyle(Color.white)
                        .frame(height: 65)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10.0)
                                .foregroundStyle(Color.buttonGray)
                        }
                }
                
                
                Button {
                    // TODO: - 탈퇴하기(유저 정보 삭제)
                    // storage, store, auth, appstorage 삭제
                    accountDeleteViewModel.deleteUserImageFromStorage()
                    accountDeleteViewModel.deleteUserInfoFromStore()
                    accountDeleteViewModel.deleteUserDefaults()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("탈퇴")
                        .font(.pretendardBold_18)
                        .foregroundStyle(Color.white)
                        .frame(height: 65)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10.0)
                                .foregroundStyle(Color.customRed)
                        }
                }
                

            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AccountDeleteContents: View {
    @ObservedObject var accountDeleteViewModel: AccountDeleteViewModel
    
    var body: some View {
        VStack {
            ForEach(accountDeleteViewModel.signoutContents, id: \.self) { content in
                VStack(alignment: .leading) {
                    HStack {
                        Text(content.icon)
                            .font(.pretendardSemiBold_24)
                        Text(content.title)
                            .font(.pretendardSemiBold_18)
                        Spacer()
                    }
                    Text(content.subTitle)
                        .font(.pretendardSemiBold_14)
                        .foregroundStyle(Color.warningGray)
                        .lineSpacing(3)
                }
                .padding(.leading, 20)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(height: 100)
                        .foregroundStyle(Color.tabGray.opacity(0.2))
                }
                .frame(height: 100)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            
        }
    }
}

#Preview {
    AccountDeleteView()
}
