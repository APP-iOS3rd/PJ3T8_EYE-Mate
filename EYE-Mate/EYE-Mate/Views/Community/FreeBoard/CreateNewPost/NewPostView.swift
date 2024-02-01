//
//  NewPostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI

struct NewPostView: View {
    @Binding var postTitle: String
    @Binding var postContent: String
    @State private var postContentPlaceHolder: String = "내용을 입력하세요."
    var postImageDatasCount: Int
    
    var body: some View {
        VStack {
            // 제목 입력
            TextField("제목", text: $postTitle)
                .font(.pretendardRegular_18)
            
            HorizontalDivider(color: Color.gray)
            
            // 내용 입력
            ZStack {
                // placeholder TextEditor
                if postContent.isEmpty {
                    TextEditor(text: $postContentPlaceHolder)
                        .font(.pretendardMedium_12)
                        .foregroundStyle(Color.black)
                        .disabled(true)
                }
                
                // 실제 입력될 TextEditor
                TextEditor(text: $postContent)
                    .overlay(alignment: .bottom){
                        HStack{
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                            
                            // 첨부 사진 수
                            Text("\(postImageDatasCount) / 10")
                                .font(.pretendardMedium_12)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            // 내용 글자 수
                            Text("\(postContent.count) / 1000")
                                .font(.pretendardMedium_12)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .font(.pretendardRegular_14)
                    .opacity(postContent.isEmpty ? 0.8 : 1)
                    .onChange(of: postContent) { newValue in
                        if newValue.count > 1000 {
                            postContent.removeLast()
                        }
                    }
            }
        }
        .padding(.horizontal, 30)
    }
}

//#Preview {
//    NewPostView()
//}
