//
//  Community.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

struct CommunityView: View {
    
    @State private var selectedPicker: CommunityTopTapViewItem = .faq
    @Namespace private var animation
    
    var body: some View {
        // MARK: NavigationStack 추후에 지워주기
        VStack(spacing: 0) {
            // 상단 Title
            HStack(alignment: .bottom) {
                VStack {
                    Text("EYE-Mate")
                        .font(.pretendardBold_22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("게시판")
                        .font(.pretendardBold_32)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // MARK: profileImage 추후에 Firebase에서 Image 받아오기
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical)
            
            // 상단 TabView
            communityTopTabView()
            
            // 선택된 상단 Tab의 View Switching
            
            switch selectedPicker {
            case .faq:
                FAQView()
            case .freeboard:
                FreeBoardView()
            }
            
            Spacer()
        }
    }
    
    // 상단 TabView(FAQ, 자유)
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


// MARK: - 상단 탭뷰 Item Enum

enum CommunityTopTapViewItem : String, CaseIterable {
    case faq = "FAQ"
    case freeboard = "자유"
}

#Preview {
    CommunityView()
}
