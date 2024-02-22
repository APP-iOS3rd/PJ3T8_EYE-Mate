//
//  SignOutView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

struct AccountDeleteView: View {
    @ObservedObject var accountDeleteViewModel = AccountDeleteViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var isCheckAlert: Bool = false
    @Binding var isSignoutAlert: Bool
    
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
                    // MARK: - 탈퇴 확인 Alert
                    isCheckAlert = true
                    
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
        .fullScreenCover(isPresented: $isCheckAlert) {
            ZStack{
                Color.gray.opacity(0.8).edgesIgnoringSafeArea(.all)
                
                CustomAlertView(
                    title: "회원 탈퇴",
                    message: "회원님의 모든 정보가 삭제됩니다.\n탈퇴하시겠습니까?",
                    leftButtonTitle: "취소",
                    leftButtonAction: {
                        isCheckAlert = false
                        isSignoutAlert = false
                    },
                    rightButtonTitle: "확인",
                    rightButtonAction: {
                        // MARK: - 탈퇴하기(유저 정보 삭제)
                        // storage, store, auth, appstorage 삭제
                        accountDeleteViewModel.deleteUserImageFromStorage()
                        accountDeleteViewModel.deleteUserInfoFromStore()
                        accountDeleteViewModel.deleteUserDefaults()
                        presentationMode.wrappedValue.dismiss()
                        isSignoutAlert = false
                    })
            }
        }
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
                        .padding(.trailing, 10)
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
    AccountDeleteView(isSignoutAlert: .constant(true))
}
