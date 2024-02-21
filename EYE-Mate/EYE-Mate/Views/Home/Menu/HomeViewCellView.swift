//
//  HomeViewCellListView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct HomeViewCellView: View {
    let item: MenuModel
    var isArrowButton: Bool = true
    
    var body: some View {
            HStack {
                item.img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding(.leading, 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.pretendardSemiBold_20)
                    Text(item.subTitle)
                        .font(.pretendardSemiBold_12)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
                .padding(.leading, 5)
                
                Spacer()
                
                if isArrowButton {
                    Circle()
                        .frame(width: 45, height: 45)
                        .opacity(0.8)
                        .foregroundColor(.customGreen)
                        .overlay {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .scaleEffect(x: -1, y: 1)
                        }
                        .padding(.trailing, 20)
                }
            }
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(radius: 3, x: 1, y: 1)
            )
        }
}

#Preview {
    HomeViewCellView(item: .init(img: Image(systemName: "person.fill"), title: "눈 기록", subTitle: "꼼꼼하게"))
}
