//
//  WarningText.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/24.
//

import SwiftUI

struct WarningText: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("• 간단한 셀프 테스트이므로 정확한 진단은 병원을 방문하여 검사하시길 바랍니다.")
                .font(.pretendardExtraLight_12)
                .foregroundColor(.warningGray)
            Spacer()
                .frame(height: 5)
            Text("• 주변환경 또는 기기에 따라 검사결과가 달라질 수 있습니다.")
                .font(.pretendardExtraLight_12)
                .foregroundColor(.warningGray)
        }
    }
}

#Preview {
    WarningText()
}
