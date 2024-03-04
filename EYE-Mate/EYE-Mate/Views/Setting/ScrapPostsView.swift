//
//  ScrapPostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/22/24.
//

import SwiftUI

struct ScrapPostsView: View {
    @StateObject var freeboardViewModel: FreeBoardViewModel = FreeBoardViewModel()
    @Environment(\.presentationMode) var presentationMode

    @State var refreshView : Bool? = false
    
    var body: some View {
        ReusablePostsView(freeboardVM: freeboardViewModel, fetchCase: .scrapPost)
            .navigationBarBackButtonHidden()
            .toolbar(content: {
                // MARK: Back Button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        /// 현재 화면 dismiss
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                }
                
                // MARK: Navigation Title
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("저장한 게시글")
                            .font(.pretendardSemiBold_24)
                    }
                }
            })
    }
}

#Preview {
    ScrapPostsView()
}
