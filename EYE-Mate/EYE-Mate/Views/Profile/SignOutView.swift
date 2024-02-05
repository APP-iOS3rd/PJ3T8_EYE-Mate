//
//  SignOutView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

struct SignOutView: View {
    @StateObject var signOutViewModel = SignOutViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            SettingNavigationTitle(isDisplayTitle: false, leftBtnType: .close)
            
            Text("탈퇴하기")
                .font(.pretendardSemiBold_32)
            
            Text("잠깐! EYE-Mate를 탈퇴하기 전에\n아래 정보를 확인해주세요")
                .multilineTextAlignment(.center)
                .font(.pretendardSemiBold_18)
                .foregroundColor(Color.warningGray)
            
            SignOutContentList(signOutViewModel: signOutViewModel)
            
            Spacer()
            
            HStack {
                Button {
                    // TODO: - 탈퇴창 닫기
                } label: {
                    Text("취소")
                        .font(.pretendardBold_18)
                        .foregroundStyle(Color.white)
                }
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.btnGray)
                }
                
                Button {
                    // TODO: - 탈퇴하기(유저 정보 삭제)
                } label: {
                    Text("탈퇴")
                        .font(.pretendardBold_18)
                        .foregroundStyle(Color.white)
                }
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.customRed)
                }

            }
            .padding(.horizontal, 20)
        }
    }
}

struct SignOutContentList: View {
    @ObservedObject var signOutViewModel: SignOutViewModel
    
    var body: some View {
        VStack {
            ForEach(signOutViewModel.signoutContents, id: \.self) { content in
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

class SignOutViewModel: ObservableObject{
    @Published var signoutContents: [SignOutContent]
    
    init(signoutContents: [SignOutContent] = [
        .init(icon: "📊", title: "시력 검사 기록이 사라져요", subTitle: "EYE-Mate를 탈퇴하면 기록되어 관리되던 시력 검사 기록들이 모두 삭제되며, 복구할 수 없어요."),
        .init(icon: "📝", title: "게시판 정보가 사라져요", subTitle: "EYE-Mate를 탈퇴하면 작성한 게시판, 댓글, 저장한 게시글 등 관련 개인 기록이 삭제되며, 복구할 수 없어요."),
        .init(icon: "🔒", title: "시력 검사 기록이 사라져요", subTitle: "EYE-Mate를 탈퇴하면 기록, 게시판 기능 등 다시 회원가입을 해야 이용가능해요.")
    ]) {
        self.signoutContents = signoutContents
    }
}

#Preview {
    SignOutView()
}
