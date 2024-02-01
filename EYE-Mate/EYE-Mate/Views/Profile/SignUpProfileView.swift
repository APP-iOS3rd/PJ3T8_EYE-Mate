//
//  ProfileEditView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI


struct SignUpProfileView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    @State var selected: PhotosPickerItem?
    @State var nickname: String = ""
    @State var data: Data?
    
    @State var viewModel: ProfileViewModel = .init()
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
            VStack {
                Text("EYE-Mate")
                    .foregroundColor(Color.customGreen)
                    .font(.pretendardSemiBold_24)
                +
                Text("에서 사용할\n프로필을 입력해주세요!")
                    .font(.pretendardRegular_24)
                
            }

            EditableCircularProfileImage(viewModel: viewModel)
            
            TextField("닉네임을 입력해주세요", text: $nickname)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                        .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 4, x: 2, y: 2)
                            )
                }
                .padding()
            
            CustomBtn(title: "시작하기", background: Color.btnGray, fontStyle: .pretendardRegular_20, action: {
                
            })
            .frame(height: 88)
            
            Spacer()
        }
    
    }
    
    
    
}


struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfileViewModel
    var body: some View {
        
        PhotosPicker(selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
            CircularProfileImage(imageState: viewModel.imageState)
        }
            
    }
}


#Preview {
    SignUpProfileView()
}
