//
//  ProfileName.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/15.
//

import SwiftUI

enum ErrorTextType: String {
    case syntax = "사용할 수 없는 닉네임입니다."
    case duplicate = "이미 사용 중인 닉네임입니다."
}

struct ProfileNameTextField: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Binding var textName: String
    @Binding var isButtonEnabled: Bool
    @State var isSyntaxErrorText: Bool = false
    @State var isDupliatedErrorText: Bool = false
    @State var errorText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack (alignment: .center, spacing: 10){
                TextField("닉네임을 입력해주세요", text: $textName)
                    .multilineTextAlignment(.center)
                    .font(.pretendardRegular_18)
                    .frame(height: 50)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 4, x: 2, y: 2)
                            )
                    }
                    .onChange(of: textName) { newValue in
                        Task {
                            let result = try await profileViewModel.isValidName(textName)
                            
                            if result != (false, false) {
                                (isSyntaxErrorText, isDupliatedErrorText) = result
                                isButtonEnabled = false
                                errorText = isSyntaxErrorText ? ErrorTextType.syntax.rawValue : ErrorTextType.duplicate.rawValue
                            } else {
                                (isSyntaxErrorText, isDupliatedErrorText) = result
                                isButtonEnabled = true
                                errorText = ""
                            }
                        }
                    }
                
                
                if isSyntaxErrorText || isDupliatedErrorText {
                    Text(errorText)
                        .font(.pretendardRegular_16)
                        .foregroundStyle(Color.red)
                        .frame(width: 330, height: 30)
                        
                } else {
                    Text("")
                        .frame(height: 30)
                }
            }
            
            VStack(alignment: .leading) {
                Text("\u{2022} 2~20자의 영문, 숫자, 한글, -, _ 만 사용 가능합니다")
                    .monospacedDigit()
                    .font(.pretendardRegular_16)
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
            }
            
        }
    }
    
}

#Preview {
    ProfileNameTextField(textName: .constant("EYE-Mate"), isButtonEnabled: .constant(false))
}
