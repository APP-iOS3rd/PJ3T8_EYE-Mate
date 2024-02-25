//
//  CustomerInfoView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/22.
//

import SwiftUI

struct CustomerServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var content: String = ""
    var dropDownList = ["신고", "장애/버그", "문의", "기타"]
    @State var selectedItem = "고객센터 카테고리"
    @State var placeholder = "무엇을 도와드릴까요?"

    var body: some View {
        VStack {
            SettingNavigationTitle(isDisplayTitle: true, leftButtonAction: {
                presentationMode.wrappedValue.dismiss()
            }, leftButtonType: .back, title:"고객센터")

            ScrollView {
                VStack(spacing: 10){
                    Menu {
                        ForEach(dropDownList, id: \.self) { item in
                            Button {
                                self.selectedItem = item
                            } label: {
                                Text(item)
                            }
                        }

                    } label: {
                        HStack{
                            Text(selectedItem)
                                .font(.pretendardRegular_18)
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.leading)

                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.black)
                        }
                        .padding(20)
                        .frame(width: UIScreen.main.bounds.width - 40 ,height: 40)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "EEEEEE").opacity(0.8))

                        }
                    }
                    .menuStyle(.button)
                    .padding(.bottom, 10)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.8), lineWidth: 3)
                            .cornerRadius(10)
                            .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)

                        if content == "" {
                            TextEditor(text: $placeholder)
                                .font(.pretendardMedium_16)
                                .foregroundStyle(Color.black)
                                .disabled(true)
                                .padding(10)
                        }

                        TextEditor(text: $content)
                            .foregroundStyle(Color.black)
                            .opacity(content.isEmpty ? 0.5 : 1)
                            .padding(10)
                            .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)

                    CustomButton(title: "제출", background: Color.customGreen, fontStyle: .pretendardSemiBold_16, action: {})
                        .frame(width: UIScreen.main.bounds.width - 10, height: 80)
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CustomerServiceView()
}
