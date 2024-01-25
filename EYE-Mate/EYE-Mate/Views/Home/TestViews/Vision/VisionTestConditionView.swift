//
//  VisionTestConditionView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import SwiftUI

struct VisionTestConditionView: View {
    @ObservedObject var distance = DistanceModel()
    
    var body: some View {
        ZStack {
            DistanceFaceAndDevice(distance: distance)
            Text("\(distance.distance)")
        }
    }
}

#Preview {
    VisionTestConditionView()
}
