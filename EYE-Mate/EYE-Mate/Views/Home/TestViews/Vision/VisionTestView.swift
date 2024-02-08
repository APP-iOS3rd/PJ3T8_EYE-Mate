//
//  VisionTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct VisionTestView: View {
    @ObservedObject var distance = DistanceConditionViewModel.shared
    
    var body: some View {
        Text("VisionTestView")
    }
}

#Preview {
    VisionTestView()
}
