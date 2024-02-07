//
//  CustomMenuButton.swift
//  EYE-Mate
//
//  Created by seongjun on 2/7/24.
//

import SwiftUI

enum RecordStatus: String, CaseIterable, Identifiable {
    var id: Self { self }

    case nothing = "선택"
    case bad = "나쁨"
    case fine = "양호"
    case good = "좋음"
}

struct CustomMenuButton: View {
    @State private var isMenuVisible = false
    @Binding var selectedOption: RecordStatus

    let label: String?

    init(
        label: String?,
        selectedOption: Binding<RecordStatus>
    ) {
        self.label = label;
        self._selectedOption = selectedOption;
    }

    private func textColor() -> Color {
        switch selectedOption {
        case .nothing:
            return Color.btnGray
        case .bad:
            return Color.customRed
        case .fine:
            return Color.lightYellow
        case .good:
            return Color.customGreen
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            if let text = label {
                Text("\(text)").font(.pretendardRegular_14)
            }
            ZStack {
                Button {
                    isMenuVisible.toggle()
                } label: {
                    Text("\(selectedOption.rawValue)")
                        .font(.pretendardRegular_16)
                        .foregroundStyle(textColor())
                        .padding(24)
                        .frame(height: 32)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                }
                if isMenuVisible {
                    CustomMenu {
                        Group {
                            Button(action: {
                                selectedOption = RecordStatus.good
                                isMenuVisible = false
                            }) {
                                Text("좋음")
                            }
                            .buttonStyle(CustomMenuButtonStyle(color: Color.customGreen))
                            HorizontalDivider(color: Color.btnGray, height: 2).padding(.horizontal, 12)
                            Button(action: {
                                selectedOption = RecordStatus.fine
                                isMenuVisible = false
                            }) {
                                Text("양호")
                            }
                            .buttonStyle(CustomMenuButtonStyle(color: Color.lightYellow))
                            HorizontalDivider(color: Color.btnGray, height: 2).padding(.horizontal, 12)
                            Button(action: {
                                selectedOption = RecordStatus.bad
                                isMenuVisible = false
                            }) {
                                Text("나쁨")
                            }
                            .buttonStyle(CustomMenuButtonStyle(color: Color.customRed))
                        }
                    }
                    .offset(y: -92)
                    .transition(.asymmetric(insertion: AnyTransition.move(edge: .bottom).combined(with: .scale).animation(.easeInOut), removal: AnyTransition.opacity.animation(.easeInOut)))
                    
                }
            }.frame(width: 80, height: 40)
        }
    }
}

#Preview {
    @State var leftColorVisionStatus = RecordStatus.nothing

    return CustomMenuButton(label: "좌", selectedOption: $leftColorVisionStatus)
}
