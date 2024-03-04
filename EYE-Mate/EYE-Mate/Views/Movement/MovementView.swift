//
//  Movement.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

struct MovementView: View {
    @AppStorage("user_name") private var userName: String = "EYE-Mate"

    @ObservedObject private var profileViewModel = ProfileViewModel.shared
    @ObservedObject private var movementViewModel = MovementViewModel.shared

    @State private var toast: Toast? = nil

    let movementList: [String] = ["Line", "Circle", "Eight"]

    var body: some View {
        VStack(spacing: 0) {
            HorizontalDivider(color: Color.customGreen, height: 4)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer().frame(height: 12)
                    VStack(alignment: .leading) {
                        Text("\(userName) 님!")
                            .font(.pretendardSemiBold_22)
                        Text("오늘도 눈 건강 챙기셨나요? 👀")
                            .font(.pretendardRegular_22)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(height: 24)
                    ForEach(movementList, id: \.self) { movement in
                        StartMovementRow(movementType: movement)
                    }
                    .padding(.horizontal, -10)
                    .padding(.vertical, 0)
                    .listStyle(PlainListStyle())
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("추후 다른 운동 업데이트 예정입니다.")
                            .font(.pretendardMedium_18)
                            .foregroundColor(Color.warningGray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
            }
        }
        .background(Color.textFieldGray)
        .toastView(toast: $toast)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if movementViewModel.showToast {
                    toast = Toast()
                    movementViewModel.showToast.toggle()
                }
            }
        }
    }
}

#Preview {
    MovementView()
}
