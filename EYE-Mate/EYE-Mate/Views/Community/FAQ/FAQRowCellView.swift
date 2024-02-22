//
//  FAQRowCellView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//

import SwiftUI

struct FAQRowCellView: View {
    var isExpanded: Bool
    var faqTitle: String
    var faqAnswer: String
    
    var body: some View {
        VStack {
            // FAQ Title
            HStack {
                Circle()
                    .frame(height: 25)
                    .foregroundStyle(Color.customGreen)
                    .overlay{
                        Text("Q")
                            .font(.pretendardSemiBold_18)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 8)


                // MARK: faqTitle 추후에 Firebase에서 받아온걸로 교체
                // 자주 묻는 질문 제목
                Text("\(faqTitle)")
                    .font(.pretendardRegular_16)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.title3)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0)) 
            }
            .padding(15)
            .background(isExpanded ? Color.btnGray : .white)

            // FAQ Answer
            if isExpanded{
                HStack(alignment: .top){
                    Circle()
                        .frame(height: 25)
                        .foregroundStyle(Color.tabGray)
                        .overlay{
                            Text("A")
                                .font(.pretendardSemiBold_18)
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 8)


                    // MARK: faqAnswer 추후에 Firebase에서 받아온걸로 교체
                    // 자주 묻는 질문 답변
                    Text("\(faqAnswer)")
                        .font(.pretendardRegular_14)

                    Spacer()
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    FAQRowCellView(isExpanded: true ,faqTitle: "갑자기 눈이 안 보입니다.", faqAnswer: "외상 없이도 여러 가지 원인으로 눈이 갑자기 안 보이는 경우가 있습니다. 치료를 빨리 시작할수록 시력 회복에 도움이 되는 경우가 많으므로 즉시 안과를 찾아 검사를 받으십시오.")
}
