//
//  FAQ.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FAQView: View {
    @State private var searchText: String = ""
    @State private var fetchFAQ: [String] = ["1","2","3"]
    @State private var expandedFAQIndex: Int?
    var body: some View {
        VStack {
            // FAQ 검색바
            HStack{
                TextField("어떤 질문을 찾으시나요?", text: $searchText)
                    .frame(width: .infinity, height: 40)
                    .padding(.vertical, 10)
                    .overlay(alignment: .trailing){
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundStyle(Color.customGreen)
                    }
            }
            .padding(.horizontal, 15)
            .overlay{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.customGreen)
            }
            
            // MARK: - FAQ목록 추후에 Firebase에서 받아오기
            // FAQ 목록
            ScrollView {
                ForEach(fetchFAQ.indices, id: \.self) { index in
                    FAQRowCellView(
                        isExpanded: index == expandedFAQIndex,
                        faqTitle: fetchFAQ[index],
                        faqAnswer: "외상 없이도 여러 가지 원인으로 눈이 갑자기 안 보이는 경우가 있습니다. 치료를 빨리 시작할수록 시력 회복에 도움이 되는 경우가 많으므로 즉시 안과를 찾아 검사를 받으십시오."
                    )
                    .onTapGesture {
                        withAnimation {
                            // FAQ를 탭할 때 확장/축소 상태 토글
                            expandedFAQIndex = expandedFAQIndex == index ? nil : index
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    FAQView()
}
