//
//  StartMovementRow.swift
//  EYE-Mate
//
//  Created by seongjun on 1/26/24.
//

import SwiftUI

struct StartMovementRow: View {
    @Binding var showToast: Bool
    @Binding var movementType: String

    @State var isNavigateEightLottieView : Bool = false

    var body: some View {
        HStack {
            Image("\(movementType)Movement")
                .resizable()
                .frame(width: 64, height: 64)
            VStack(alignment: .leading, spacing: 12){
                switch movementType {
                case "Line":
                    Text("1자 운동")
                        .font(.pretendardSemiBold_20)
                case "Circle":
                    Text("원 운동")
                        .font(.pretendardSemiBold_20)
                case "Eight":
                    Text("8자 운동")
                        .font(.pretendardSemiBold_20)
                default:
                    EmptyView()
                }
                Text("점을 따라 눈을 움직이세요!")
                    .font(.pretendardSemiBold_12)
            }.padding(.leading, 12)
            Spacer()
            Button {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                isNavigateEightLottieView = true
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }.navigationDestination(isPresented: $isNavigateEightLottieView) {
                MovementLottieView(showToast: $showToast, movementType: $movementType)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .background(Color.customGreen)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .frame(width: 44, height: 44)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.25), radius: 4, x: 2, y: 2)
    }
}

#Preview {
    @State var showToast: Bool = false
    @State var movementType: String = "Line"

    return StartMovementRow(showToast: $showToast, movementType: $movementType)
}
