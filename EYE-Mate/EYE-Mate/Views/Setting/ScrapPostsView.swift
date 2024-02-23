//
//  ScrapPostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/22/24.
//

import SwiftUI

struct ScrapPostsView: View {
    @StateObject var freeboardViewModel: FreeBoardViewModel = FreeBoardViewModel()

    var body: some View {
        ReusablePostsView(freeboardVM: freeboardViewModel, fetchCase: .scrapPost)
    }
}

#Preview {
    ScrapPostsView()
}
