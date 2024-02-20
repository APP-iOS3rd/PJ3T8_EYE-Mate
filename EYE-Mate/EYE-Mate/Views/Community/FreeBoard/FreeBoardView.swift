//
//  FreeBoard.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

import FirebaseFirestore

struct FreeBoardView: View {
    @StateObject var freeboardVM: FreeBoardViewModel = FreeBoardViewModel()

    @FocusState var searchBarFocused: Bool
    var searchSignal: (Bool) -> ()
    
    var body: some View {
        // 검색 Bar
        SearchBar()
            .padding()
        
        // 게시물 List
        ReusablePostsView(freeboardVM: freeboardVM)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .bottomTrailing){
                NavigationLink(destination: CreateNewPostView(){ post in
                    /// 사용자가 새롭게 작성한 게시물 insert
                    if let post = post {
                        freeboardVM.posts.insert(post, at: 0)
                        print("post insert Success")
                    }
                }) {
                    Circle()
                        .foregroundStyle(Color.customGreen)
                        .frame(maxHeight: 60)
                        .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 0, x: 2, y: 2)
                        .overlay{
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .opacity(searchBarFocused ? 0 : 1)
                }
                .padding()
            }
            .onChange(of: searchBarFocused) { isSearching in
                searchSignal(searchBarFocused)
            }
            .onTapGesture {
                searchBarFocused = false
            }
    }
}

extension FreeBoardView {
    // MARK: 게시물 검색바
    @ViewBuilder
    func SearchBar() -> some View {
        HStack{
            TextField("어떤 게시물을 찾으시나요?", text: $freeboardVM.searchText)
                .frame(maxWidth: .infinity)
                .focused($searchBarFocused)
                .padding(.vertical, 15)
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundStyle(Color.customGreen)
                .onTapGesture {
                    searchBarFocused = false
                    /// 검색어에 따른 게시물 fetch
                    if freeboardVM.searchText.isEmpty && freeboardVM.isSearching {
                        Task {
                            freeboardVM.isSearching = false
                            await freeboardVM.refreshable()
                        }
                    } else if !freeboardVM.searchText.isEmpty{
                        freeboardVM.isFetching = true
                        freeboardVM.posts = []
                        freeboardVM.paginationDoc = nil
                        freeboardVM.isSearching = true
                        Task {
                            await freeboardVM.fetchPosts(searchText: freeboardVM.searchText)
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
            /// 검색어에 따른 게시물 fetch
            if freeboardVM.searchText.isEmpty && freeboardVM.isSearching {
                Task {
                    freeboardVM.isSearching = false
                    await freeboardVM.refreshable()
                }
            } else if !freeboardVM.searchText.isEmpty{
                freeboardVM.isFetching = true
                freeboardVM.posts = []
                freeboardVM.paginationDoc = nil
                freeboardVM.isSearching = true
                Task {
                    await freeboardVM.fetchPosts(searchText: freeboardVM.searchText)
                }
            }
        }
    }
}

//#Preview {
//    FreeBoardView()
//}
