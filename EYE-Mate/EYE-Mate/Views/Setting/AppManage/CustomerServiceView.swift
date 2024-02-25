//
//  CustomerInfoView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/22.
//

import SwiftUI

struct CustomerServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var CSViewModel = CustomerServiceViewModel()
    @State var content: String = ""
    var dropDownList = [CustomerServiceMenu.Name.report, CustomerServiceMenu.Name.error, CustomerServiceMenu.Name.inquiry]
    @State var selectedItem: CustomerServiceMenu.Name = .report
    @State var menuText: String = "카테고리"
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
                                self.menuText = item.rawValue
                                // 선택한 메뉴에 대한 item 선택
                                selectedItem = item
                            } label: {
                                Text(item.rawValue)
                            }
                            
                        }
                    } label: {
                        HStack{
                            Text(menuText)
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

                    CustomButton(title: "제출", background: Color.customGreen, fontStyle: .pretendardSemiBold_16, action: {
                        CSViewModel.sendMessage(menu: selectedItem, text: content)
                    })
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
