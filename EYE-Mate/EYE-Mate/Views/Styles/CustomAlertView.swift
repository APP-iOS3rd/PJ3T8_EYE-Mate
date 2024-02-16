//
//  CustomAlertView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/16.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var showAlert: Bool
    var title: String
    var message: String
    var leftButtonTitle: String
    var leftButtonAction: () -> Void
    var rightButtonTitle: String
    var rightButtonAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .font(.pretendardMedium_22)
                .padding(10)
            
            Text(message)
                .font(.pretendardMedium_16)
                .foregroundColor(Color.gray)
                .padding(.bottom, 10)
            
            HStack(spacing: 0) {
                Button {
                    leftButtonAction()
                } label: {
                    Text(leftButtonTitle)
                        .font(.pretendardMedium_18)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.btnGray)
                }
                
                Button {
                    rightButtonAction()
                } label: {
                    Text(rightButtonTitle)
                        .font(.pretendardMedium_18)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color.customGreen)
                        }
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        }
        .opacity(0.95)
        .frame(width: UIScreen.main.bounds.width-110, height: 150)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    CustomAlertView(showAlert: .constant(true), title: "title", message: "message", leftButtonTitle: "left", leftButtonAction: {}, rightButtonTitle: "right", rightButtonAction: {})
}
