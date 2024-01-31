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
            }
            
            
            VStack(alignment: .leading) {
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("아직 EYE-Mate 회원이 아니신가요?")
                            .font(.pretendardMedium_16)
                        
                        Button {
                            signUpFlag = true
                        } label: {
                            Text("회원가입")
                                .foregroundStyle(Color.customGreen)
                                .underline()
                                .font(.pretendardSemiBold_20)
                        }
                    }
                    Spacer()
                }
            }
            .padding(50)
        }
        
    }
}

#Preview {
    SignInView(signUpFlag: .constant(false))
}

