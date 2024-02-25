//
//  CustomerServiceView.swift
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
    var subTitle = "이용 중 불편한 점이나 문의 사항을 보내주세요.\n확인 후 빠르고 정확하게 답변드리겠습니다.\n"
    @State var menuText: String = "카테고리"
    @State var placeholder = "무엇을 도와드릴까요?"
    
    var body: some View {
        VStack {
            SettingNavigationTitle(isDisplayTitle: true, leftButtonAction: {
                presentationMode.wrappedValue.dismiss()
            }, leftButtonType: .back, title:"고객센터")
            
            ScrollView {
                VStack(spacing: 10){
                    HStack {
                        Text(subTitle)
                            .font(.pretendardMedium_18)
                            .foregroundStyle(Color.darkGray)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("문의 유형")
                            .font(.pretendardSemiBold_18)
                            .foregroundStyle(Color.darkGray)
                        Spacer()
                    }
                    .modifier(CSViewModifier(height: 20))
                    
                    VStack {
                        Menu {
                            ForEach(dropDownList, id: \.self) { item in
                                Button {
                                    self.menuText = item.rawValue
                                    selectedItem = item
                                } label: {
                                    Text(item.rawValue)
                                }
                            }
                        } label: {
                            HStack{
                                Text(menuText)
                                    .font(.pretendardMedium_18)
                                    .foregroundStyle(menuText == "카테고리" ? Color.black.opacity(0.2) : Color.black)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.black)
                            }
                            .modifier(CSViewModifier(height: 20))
                        }
                        .menuStyle(.button)
                        
                        SettingListDivider()
                    }
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("문의 내용")
                            .font(.pretendardSemiBold_18)
                            .foregroundStyle(Color.darkGray)
                        Spacer()
                    }
                    .modifier(CSViewModifier(height: 20))
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.8), lineWidth: 3)
                            .cornerRadius(10)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                        
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
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    }
                    .modifier(CSViewModifier(height: 300))
                    
                    CustomButton(title: "문의하기", background: Color.customGreen, fontStyle: .pretendardSemiBold_18, action: {
                        CSViewModel.sendMessage(menu: selectedItem, text: content)
                        presentationMode.wrappedValue.dismiss()
                    })
                    .disableWithOpacity(content.isEmpty || menuText == "카테고리")
                    .disabled(content.isEmpty || menuText == "카테고리")
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct CSViewModifier: ViewModifier {
    var height: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .frame(height: self.height)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
    }
}

#Preview {
    CustomerServiceView()
}
