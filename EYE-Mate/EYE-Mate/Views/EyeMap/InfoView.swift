//
//  InfoView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI


struct InfoView: View {
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(coordinator.placeInfo[Key.name.rawValue] ?? "이름")")
                .font(.pretendardSemiBold_22)
            // status, openhour
            HStack {
                Text("\(coordinator.placeInfo[Key.status.rawValue] ?? "현재 상태")")
                    .font(.pretendardBold_14)
                Text("\(coordinator.placeInfo[Key.statusDetail.rawValue] ?? "진행 시간")")
                    .font(.pretendardRegular_14)
            }
            // review count
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.lightRed)
                
                Text("방문자리뷰 \(coordinator.placeInfo[Key.reviewCount.rawValue] ?? "0")")
                    .font(.pretendardRegular_14)
                Text("블로그리뷰 \(coordinator.placeInfo[Key.placeReviewCount.rawValue] ?? "0")")
                    .font(.pretendardRegular_14)
            }
            // address, tel
            VStack(alignment: .leading, spacing: 3) {
                Text("\(coordinator.placeInfo[Key.address.rawValue] ?? "주소")")
                    .font(.pretendardRegular_14)
                Text("\(coordinator.placeInfo[Key.tel.rawValue] ?? "전화번호")")
                    .font(.pretendardBold_14)
            }
        }
    }
}
