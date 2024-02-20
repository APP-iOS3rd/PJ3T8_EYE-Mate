//
//  ProfileListView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/06.
//

import SwiftUI
import PhotosUI

struct ProfileListView: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @State var isPresented = false
    
    var body: some View {
        ImageActionSheetView()
        
        SettingCellView(title: "닉네임 변경", destination: ChangeUserNameView())
    }
}

fileprivate struct ProfileCellView: View {
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text("닉네임 변경")
                    .font(.pretendardRegular_18)
                    .padding(.leading, 30)
                    .foregroundStyle(Color.black)
                
                Spacer()
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 10)
                    .foregroundStyle(Color.gray)
            }
            .frame(width: 330, height: 50)
            
            SettingListDivider()
        }
        
    }
}


#Preview {
    ProfileListView()
}
