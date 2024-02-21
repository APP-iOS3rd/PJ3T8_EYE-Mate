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
    @State var isSearching = false
    
    @ObservedObject private var profileViewModel = ProfileViewModel.shared
    
    var body: some View {
        // MARK: NavigationStack 추후에 지워주기
        VStack(spacing: 0) {
            // 상단 TabView
            communityTopTabView()
            
            // 선택된 상단 Tab의 View Switching
            switch selectedPicker {
            case .faq:
                FAQView() { isSearching in
                    withAnimation {
                        self.isSearching = isSearching
                    }
                }
            case .freeboard:
                FreeBoardView(){ isSearching in
                    withAnimation() {
                        self.isSearching = isSearching
                    }
                }
            }
            
            Spacer()
                .frame(height: 85)
        }
        .navigationDestination(isPresented: $profileViewModel.isPresentedProfileView) {
            ProfileView()
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
                        hideKeyboard()
                        self.selectedPicker = item
                        self.isSearching = false
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
