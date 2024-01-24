//
//  FAQ.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FAQView: View {
    @State private var searchText: String = ""
    @State private var fetchFAQ: [String] = ["갑자기 눈이 안 보입니다.","갑자기 눈이 안 보입니다.","갑자기 눈이 안 보입니다."]
    @State private var expandedFAQIndex: Int?
    var body: some View {
        VStack {
            // FAQ 검색바
            SearchBar()
            
            // FAQ 목록
            ScrollView {
                LazyVStack {
                    FAQs()
                }
            }
        }
        .padding(.top, 15)
        .padding(.horizontal, 20)
        .onAppear{
            // MARK: FAQ목록 추후에 Firebase에서 받아오기
            // 처음에 화면 나타났을 때는 키워드가 없으므로 모든 FAQ 받아옴(Pagination 필요)
        }
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        HStack{
            TextField("어떤 질문을 찾으시나요?", text: $searchText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
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
        .onSubmit {
            // MARK: Firebase에서 검색 키워드에 따라 FAQ목록 받아오기(Pagination 필요)
        }
    }
    
    @ViewBuilder
    func FAQs() -> some View {
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
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.customGreen)
        }
    }
}

#Preview {
    FAQView()
}
