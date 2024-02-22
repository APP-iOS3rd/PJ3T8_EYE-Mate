//
//  TestResultTitleView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/22.
//

import SwiftUI

struct TestResultTitleView: View {
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    let type: TestType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Text(userName)
                    .font(.pretendardBold_32)
                Text("님!")
                    .font(.pretendardBold_32)
            }
            switch type {
            case .vision:
                Text("시력 측정 결과가 나왔어요.")
                    .font(.pretendardBold_28)
            case .colorVision:
                Text("색각 검사 결과가 나왔어요.")
                    .font(.pretendardBold_28)
            case .astigmatism:
                Text("난시 검사 결과가 나왔어요.")
                    .font(.pretendardBold_28)
            case .eyesight:
                Text("시야 검사 결과가 나왔어요.")
                    .font(.pretendardBold_28)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
    }
}

#Preview {
    TestResultTitleView(type: .vision)
}
