//
//  Community.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

enum CommunityTopTapViewItem : String, CaseIterable {
    case faq = "FAQ"
    case freeboard = "자유"
}

struct CommunityView: View {
    
    @State private var selectedPicker: CommunityTopTapViewItem = .faq
    @Namespace private var animation
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("EYE-Mate")
                //.font(.pretendardBold_22)
                    .font(.system(size: 22, weight: .heavy))
                
                HStack{
                    Text("게시판")
                    //.font(.pretendardBold_32)
                        .font(.system(size: 32, weight: .heavy))
                    Spacer()
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding(8)
            
            communityTopTabView()
            
            switch selectedPicker {
            case .faq:
                FAQView()
            case .freeboard:
                FreeBoardView()
            }
        }
    }
    
    @ViewBuilder
    func communityTopTabView() -> some View {
        HStack {
            ForEach(CommunityTopTapViewItem.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity/2, minHeight: 30)
                        .font(.pretendardBold_24)
                        .foregroundStyle(selectedPicker == item ? .black : .gray)
                    
                    if selectedPicker == item {
                        Rectangle()
                            .foregroundStyle(Color.customGreen)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "item", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
}

#Preview {
    CommunityView()
}
