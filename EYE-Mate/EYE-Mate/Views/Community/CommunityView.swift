//
//  Community.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("EYE-Mate")
                    //.font(.pretendardBold_22)
                    .font(.system(size: 22, weight: .heavy))
                
                HStack{
                    Text("게시판")
                    //.font(.pretendardBold_32)
                        .font(.system(size: 32, weight: .heavy))
                    Spacer()
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding(8)
        }
    }
}

#Preview {
    CommunityView()
}
