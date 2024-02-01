//
//  PostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/26/24.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    @State var post: Post
    
    @State private var commentText: String = ""
    @State private var commentPlaceHolder: String = "댓글을 남겨보세요..."
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HorizontalDivider(color: .btnGray, height: 2)
            ScrollView{
                // 게시물 내용
                PostContent(post: post)
                    .padding(.top)
                
                HorizontalDivider(color: .btnGray, height: 2)
                
                // 댓글
                if !post.comments.isEmpty {
                    CommentView(comments: post.comments)
                } else {
                    Spacer()
                }
            }
            .scrollIndicators(.never)
            
            // 댓글 입력
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 44)
                .foregroundStyle(Color.btnGray)
                .overlay{
                    ZStack {
                        if commentText.isEmpty {
                            TextEditor(text: $commentPlaceHolder)
                                .foregroundStyle(.gray)
                                .font(.pretendardRegular_14)
                                .disabled(true)
                                .scrollContentBackground(.hidden)
                                .background(.clear)
                        }
                        
                        TextEditor(text: $commentText)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .font(.pretendardRegular_14)
                            .opacity(commentText.isEmpty ? 0.8 : 1)
                            .onChange(of: commentText) { newValue in
                                if newValue.count > 1000 {
                                    commentText.removeLast()
                                }
                            }
                    }
                    .padding(.top, 5)
                    .padding(.leading, 5)
                }
        }
        .padding(.horizontal, 10)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            // Back Button
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
            
            // Navigation Title
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "leaf")
                        .foregroundStyle(Color(hex: "#28CD41"))
                    Text("자유 게시판")
                        .font(.pretendardSemiBold_24)
                }
            }
        })
    }
}







#Preview {
    PostView(post: FreeBoardViewModel().posts[0])
}
