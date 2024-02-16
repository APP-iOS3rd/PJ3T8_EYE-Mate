//
//  CustomBackButton.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/16.
//

import SwiftUI

struct CustomBackButton: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
                profileViewModel.isPresentedProfileView.toggle()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(.top, 10)
        .padding(.leading, 20)
    }
}

#Preview {
    CustomBackButton()
}
