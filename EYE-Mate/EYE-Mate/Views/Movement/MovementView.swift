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
    @State private var toast: Toast? = nil
    @State private var showToast = false
    @State private var movementList: [String] = ["Line", "Circle", "Eight"]
    @State private var isPresentedProfileView = false

    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                CustomNavigationTitle(title: "눈운동",
                                      isDisplayLeftButton: false, profileButtonAction: {
                    isPresentedProfileView.toggle()
                })
                HorizontalDivider(color: Color.customGreen, height: 4)
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("어디로 가야 하오 님!")
                            .font(.pretendardSemiBold_22)
                        Text("오늘도 눈 건강 챙기셨나요? 👀")
                            .font(.pretendardRegular_22)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("#오늘의 눈 운동")
                            .font(.pretendardRegular_16)
                        Text("0회")
                            .font(.pretendardSemiBold_20)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    ForEach($movementList, id: \.self) { movement in
                        StartMovementRow(showToast: $showToast, movementType: movement)
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
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                .background(Color.textFieldGray)
                Spacer()
                    .frame(height: 70)
            }.toastView(toast: $toast)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if showToast {
                            toast = Toast()
                            showToast.toggle()
                        }
                    }
                }
        }
        .navigationDestination(isPresented: $isPresentedProfileView) {
            ProfileView()
        }
    }
}

#Preview {
    MovementView()
}
