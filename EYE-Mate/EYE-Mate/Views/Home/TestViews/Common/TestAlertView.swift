//
//  TestAlertView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/20.
//

import SwiftUI

struct TestAlertView: View {
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    @Binding var showAlert: Bool
    
    var body: some View {
        if showAlert {
            ZStack{
                // 배경화면
                Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                
                CustomAlertView(
                    title: "저희 아직 친구가 아니네요.",
                    message: "비회원의 경우 검사 결과가 저장되지 않아요!",
                    leftButtonTitle: "홈으로",
                    leftButtonAction: {
                        dismiss()
                    },
                    rightButtonTitle: "로그인",
                    rightButtonAction: {
                        // MARK: - 로그인 화면으로 이동
                        loginViewModel.showFullScreenCover.toggle()
                        showAlert = false
                    })
            }
        }
    }
}

#Preview {
    TestAlertView(showAlert: .constant(true))
}
