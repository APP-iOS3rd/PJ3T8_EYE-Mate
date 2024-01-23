//
//  FreeBoard.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FreeBoardView: View {
    @State private var recentsPosts: [String] = []
    @State private var createNewPost: Bool = false
    var body: some View {
        NavigationStack {
            ReusablePostsView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .overlay(alignment: .bottomTrailing){
                    Button {
                        createNewPost.toggle()
                    } label: {
                        Circle()
                            .foregroundStyle(Color.customGreen)
                            .frame(maxHeight: 60)
                            .overlay{
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(15)
        }
    }
}

#Preview {
    FreeBoardView()
}
