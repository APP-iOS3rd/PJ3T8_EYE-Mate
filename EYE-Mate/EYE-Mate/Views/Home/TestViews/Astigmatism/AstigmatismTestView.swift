//
//  AstigmatismTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct AstigmatismTestView: View {
    @StateObject var viewModel = AstigmatismTestViewModel()
    
    var body: some View {
        VStack {
            Text("AstigmatismTestView")
        }
    }
}

#Preview {
    AstigmatismTestView()
}
