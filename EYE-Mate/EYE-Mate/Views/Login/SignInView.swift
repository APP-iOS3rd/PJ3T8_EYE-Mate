//
//  SignInView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI

struct SignInView: View {
    @Binding var signUpFlag: Bool
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                    .frame(height: 100)
                Text("EYE-Mate")
                    .font(.pretendardBold_28)
                    .foregroundStyle(Color.customGreen)
                    .padding(.bottom, 40)
                
                VStack(spacing: 20) {
                    Text("로그인")
                        .font(.pretendardBold_20)
                        .foregroundStyle(Color.customGreen)
                    PhoneNumberView(signUpFlag: $signUpFlag)
                        .frame(height: 150)
                    
                    // MARK: - 로그인 버튼
                    VStack(alignment: .leading, spacing: 20) {
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(Color.customGreen)
                                    .frame(width: 300, height: 50)
                                Text("로그인")
                                    .foregroundStyle(.white)
                                    .font(.pretendardSemiBold_18)
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("아직 EYE-Mate 회원이 아니신가요?")
                                .font(.pretendardMedium_14)
                            
                            
                            Button {
                                signUpFlag = true
                            } label: {
                                Text("회원가입")
                                    .foregroundStyle(Color.customGreen)
                                    .underline()
                                    .font(.pretendardSemiBold_18)
                            }
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                    }

                }
            }
        }
    }
}

#Preview {
    SignInView(signUpFlag: .constant(false))
}
