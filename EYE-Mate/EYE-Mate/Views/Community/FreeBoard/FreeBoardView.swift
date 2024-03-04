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

    @AppStorage("Login") var loggedIn: Bool = false
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 검색 Bar
                SearchBar()
                    .padding()
                
                // 게시물 List
                ReusablePostsView(freeboardVM: freeboardVM, fetchCase: .freeboard)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .overlay(alignment: .bottomTrailing){
                        Button {
                            if loggedIn {
                                freeboardVM.isShowCreateView = true
                            } else {
                                showAlert = true
                            }
                        } label: {
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
            if showAlert {                
                CustomAlertView(
                    title: "저희 아직 친구가 아니네요.",
                    message: "비회원의 경우 게시물을 작성할 수 없어요!",
                    leftButtonTitle: "취소",
                    leftButtonAction: { showAlert = false },
                    rightButtonTitle: "로그인",
                    rightButtonAction: {
                        loginViewModel.showFullScreenCover.toggle()
                        showAlert = false
                    })
            }
        }
        .navigationDestination(isPresented: $freeboardVM.isShowCreateView) {
            CreateNewPostView(isEditingPost: false){_,_,_,_,_ in
            } onPost: { post in
                /// 사용자가 새롭게 작성한 게시물 insert
                if let post = post {
                    freeboardVM.posts.insert(post, at: 0)
                    print("post insert Success")
                }
            }
        }
        .fullScreenCover(isPresented: $loginViewModel.showFullScreenCover, content: {
            LoginView(isAlertView: true)
        })
        .animation(.easeInOut(duration: 0.1), value: showAlert)
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
