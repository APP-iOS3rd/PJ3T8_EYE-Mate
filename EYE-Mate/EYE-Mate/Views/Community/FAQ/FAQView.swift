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
    var body: some View {
        VStack {
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
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    FAQView()
}
