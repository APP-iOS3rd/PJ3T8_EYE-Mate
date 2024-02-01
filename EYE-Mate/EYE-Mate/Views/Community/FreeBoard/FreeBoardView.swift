//
//  FreeBoard.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FreeBoardView: View {
    // MARK: recentsPosts 추후에 Firebase 연동
    @StateObject var freeboardVM: FreeBoardViewModel = FreeBoardViewModel()

    var body: some View {
        ReusablePostsView(freeboardVM: freeboardVM)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .bottomTrailing){
                NavigationLink(destination: CreateNewPostView()) {
                    Circle()
                        .foregroundStyle(Color.customGreen)
                        .frame(maxHeight: 60)
                        .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 0, x: 2, y: 2)
                        .overlay{
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(.white)
                        }
                }
                .padding()
            }
    }
}

#Preview {
    FreeBoardView()
}
