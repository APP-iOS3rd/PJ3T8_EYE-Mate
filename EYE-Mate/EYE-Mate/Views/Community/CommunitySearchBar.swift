//
//  CommunitySearchBar.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/18/24.
//

import SwiftUI

enum CommunityType {
    case faq
    case freeboard
}

struct CommunitySearchBar: View {
    var communityType: CommunityType
    private var placeholderText: String
    
    @State private var searchText: String = ""
    
    var startSearchData: (String) -> ()
    
    init(communityType: CommunityType, startSearchData: @escaping (String) -> ()) {
        self.communityType = communityType
        
        self.startSearchData = startSearchData
        
        switch communityType {
        case .faq: placeholderText = "어떤 질문을 찾으시나요?"
        case .freeboard: placeholderText = "어떤 게시물을 찾으시나요?"
        }
    }
    
    var body: some View {
        HStack{
            TextField(placeholderText, text: $searchText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .overlay(alignment: .trailing){
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                        .foregroundStyle(Color.customGreen)
                        .onTapGesture {
                            /// search 시작
                            hideKeyboard()
                            startSearchData(searchText)
                        }
                }
        }
        .padding(.horizontal, 15)
        .overlay{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.customGreen)
        }
        .onSubmit {
            // MARK: Firebase에서 검색 키워드에 따라 FAQ목록 받아오기(Pagination 필요)
            /// search 시작
            startSearchData(searchText)
        }
    }
}

//#Preview {
//    CommunitySearchBar(communityType: .faq)
//}
