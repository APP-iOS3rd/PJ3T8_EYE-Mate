//
//  MapModalView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/24.
//

import SwiftUI

struct MapModalView: View {
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.shadow(.drop(color:.gray, radius: 10, x: 2, y: 2)))
                .stroke(Color.customGreen, lineWidth: 2)
            
            HStack{
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(coordinator.placeInfo["name"] ?? "name")")
                            .font(.pretendardSemiBold_22)
                        
                        HStack {
                            Text("\(coordinator.placeInfo["status"] ?? "status")")
                                .font(.pretendardBold_14)
                            Text("\(coordinator.placeInfo["statusDetail"] ?? "statusDetail")")
                                .font(.pretendardRegular_14)
                        }
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.lightRed)
                            
                            Text("방문자리뷰 \(coordinator.placeInfo["reviewCount"] ?? "0")")
                                .font(.pretendardRegular_14)
                            Text("블로그리뷰 \(coordinator.placeInfo["placeReviewCount"] ?? "0")")
                                .font(.pretendardRegular_14)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("\(coordinator.placeInfo["address"] ?? "address")")
                                .font(.pretendardRegular_14)
                            Text("\(coordinator.placeInfo["tel"] ?? "tel")")
                                .font(.pretendardBold_14)
                        }
                    }
                }
                
                Spacer()
                if coordinator.placeInfo["thumUrls"] != "none"{
                    AsyncImage (
                        url: URL(string: coordinator.placeInfo["thumUrls"] ?? ""),
                        content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .cornerRadius(10)
                        },
                        placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 90, height: 90)
                        }
                    )
                    .padding(.bottom, 20)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity, maxHeight: 160)
        .padding(.horizontal, 20)
        
        
    }
}

#Preview {
    MapModalView()
}
