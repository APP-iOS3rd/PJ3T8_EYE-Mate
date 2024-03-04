//
//  FAQ.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FAQView: View {
    @StateObject var faqViewModel: FAQViewModel = FAQViewModel()
    
    @State private var expandedFAQIndex: Int?
    
    @FocusState var searchBarFocused: Bool
    
    var searchSignal: (Bool) -> ()
    
    var body: some View {
        VStack {
            SearchBar()
            
            // FAQ 목록
            ScrollView {
                LazyVStack {
                    if faqViewModel.isFetching {
                        ProgressView()
                    } else {
                        if faqViewModel.FAQs.isEmpty {
                            Text("No FAQ's Found")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        } else {
                            FAQs()
                        }
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .padding(.top, 15)
        .padding(.horizontal, 20)
        .onChange(of: searchBarFocused) { isSearching in
            searchSignal(searchBarFocused)
        }
        .task {
            guard faqViewModel.FAQs.isEmpty else { return }
            await faqViewModel.fetchFAQ()
        }
    }
}

extension FAQView {
    // MARK: FAQ 검색바
    @ViewBuilder
    func SearchBar() -> some View {
        HStack{
            TextField("어떤 질문을 찾으시나요?", text: $faqViewModel.searchText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .focused($searchBarFocused)
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundStyle(Color.customGreen)
                .onTapGesture {
                    searchBarFocused = false
                    if faqViewModel.searchText.isEmpty && faqViewModel.isSearching {
                        faqViewModel.isSearching = false
                        faqViewModel.FAQs = []
                        Task {
                            await faqViewModel.fetchFAQ()
                        }
                    } else if !faqViewModel.searchText.isEmpty {
                        faqViewModel.FAQs = []
                        faqViewModel.paginationDoc = nil
                        faqViewModel.isFetching = true
                        faqViewModel.isSearching = true
                        Task {
                            await faqViewModel.fetchFAQ(searchText: faqViewModel.searchText)
                        }
                    }
                }
        }
        .padding(.horizontal, 15)
        .overlay{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.customGreen)
        }
        .onSubmit {
            if faqViewModel.searchText.isEmpty && faqViewModel.isSearching {
                faqViewModel.isSearching = false
                faqViewModel.FAQs = []
                Task {
                    await faqViewModel.fetchFAQ()
                }
            } else if !faqViewModel.searchText.isEmpty {
                faqViewModel.FAQs = []
                faqViewModel.paginationDoc = nil
                faqViewModel.isFetching = true
                faqViewModel.isSearching = true
                Task {
                    await faqViewModel.fetchFAQ(searchText: faqViewModel.searchText)
                }
            }
        }
    }
    
    // MARK: FAQ 목록
    @ViewBuilder
    func FAQs() -> some View {
        ForEach(faqViewModel.FAQs.indices, id: \.self) { index in
            FAQRowCellView(
                isExpanded: index == expandedFAQIndex,
                question: faqViewModel.FAQs[index].question,
                answer: faqViewModel.FAQs[index].answer
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

//#Preview {
//    FAQView()
//}
