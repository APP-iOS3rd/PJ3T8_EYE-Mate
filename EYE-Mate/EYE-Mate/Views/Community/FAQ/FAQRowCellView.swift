//
//  FAQRowCellView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//

import SwiftUI

struct FAQRowCellView: View {
    var isExpanded: Bool
    var question: String
    var answer: String
    
    var body: some View {
        VStack {
            // FAQ Question
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

                // Question
                Text("\(question)")
                    .font(.pretendardRegular_16)
                   
                Spacer()

                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.title3)
                    .frame(width: 18)
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

                    // Answer
                    Text("\(answer)")
                        .font(.pretendardRegular_14)

                    Spacer()
                }
                .padding(15)
            }
        }
    }
}
