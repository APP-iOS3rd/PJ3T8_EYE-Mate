//
//  MyPostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/22/24.
//

import SwiftUI

struct MyPostsView: View {
    @StateObject var freeboardViewModel: FreeBoardViewModel = FreeBoardViewModel()
    
    var body: some View {
        ZStack {
            ReusablePostsView(freeboardVM: freeboardViewModel, fetchCase: .myPost)
        }
    }
}

enum FetchCase {
    case freeboard
    case myPost
    case scrapPost
}
