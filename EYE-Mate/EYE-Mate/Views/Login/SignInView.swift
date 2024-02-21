//
//  SignInView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @Binding var signUpFlag: Bool
    @FocusState private var keyFocused: Bool
    @State var openOTPView: Bool = false
    @State var countryCode : String = "+82"
    @State var mobPhoneNumber = ""
    
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
                PhoneNumberView(openOTPView: $openOTPView, signUpFlag: $signUpFlag, keyFocused: $keyFocused, countryCode: $countryCode, mobPhoneNumber: $mobPhoneNumber)
                
                // MARK: - OTP View
                if openOTPView {
                    OTPVerificationView(loginViewModel: loginViewModel, signUpFlag: $signUpFlag, keyFocused: $keyFocused, mobileNumber: "\(countryCode)\(mobPhoneNumber)")
                }
                
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
        .background(Color.white)
        .onTapGesture {
            keyFocused = false
        }
    }
}

//#Preview {
//    SignInView(signUpFlag: .constant(false), isFocused: .constant(false))
//}

