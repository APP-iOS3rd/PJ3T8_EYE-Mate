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

    case normal = "정상적인 색채 지각"
    case minor = "경미한 색채 지각 이상"
    case severe = "중증도의 색채 지각 이상"
    case serious = "심각한 색채 지각 이상"
}

struct CustomMenuButton: View {
    @State private var isMenuVisible = false
    @Binding var selectedOption: RecordStatus

    let label: String?
    let isColorVision: Bool

    init(
        label: String?,
        isColorVision: Bool,
        selectedOption: Binding<RecordStatus>
    ) {
        self.label = label;
        self.isColorVision = isColorVision;
        self._selectedOption = selectedOption;
    }

    private func textColor() -> Color {
        switch selectedOption {
        case .nothing:
            return Color.gray
        case .bad, .fine, .good, .normal, .minor, .severe, .serious:
            return Color.white
        }
    }

    private func backgroundColor() -> Color {
        switch selectedOption {
        case .nothing:
            return Color.white
        case .bad, .serious:
            return Color.lightRed
        case .fine, .minor, .severe:
            return Color.lightYellow
        case .good, .normal:
            return Color.customGreen
        }
    }

    private func strokeColor() -> Color {
        switch selectedOption {
        case .nothing:
            return Color.buttonGray
        case .bad, .serious:
            return Color.lightRed
        case .fine, .minor, .severe:
            return Color.lightYellow
        case .good, .normal:
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
                        .frame(width: isColorVision ? 200 : 80)
                        .background(backgroundColor())
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(strokeColor(), lineWidth: 2)
                        }
                }
                if isMenuVisible {
                    if isColorVision {
                        CustomMenu {
                            Group {
                                Button(action: {
                                    selectedOption = RecordStatus.normal
                                    isMenuVisible = false
                                }) {
                                    Text(RecordStatus.normal.rawValue)
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.customGreen))
                                HorizontalDivider(color: Color.buttonGray, height: 2).padding(.horizontal, 12)
                                Button(action: {
                                    selectedOption = RecordStatus.minor
                                    isMenuVisible = false
                                }) {
                                    Text(RecordStatus.minor.rawValue)
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.lightYellow))
                                HorizontalDivider(color: Color.buttonGray, height: 2).padding(.horizontal, 12)
                                Button(action: {
                                    selectedOption = RecordStatus.severe
                                    isMenuVisible = false
                                }) {
                                    Text(RecordStatus.severe.rawValue)
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.lightYellow))
                                HorizontalDivider(color: Color.buttonGray, height: 2).padding(.horizontal, 12)
                                Button(action: {
                                    selectedOption = RecordStatus.serious
                                    isMenuVisible = false
                                }) {
                                    Text(RecordStatus.serious.rawValue)
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.customRed))
                            }
                        }
                        .frame(width: 220)
                        .offset(y: -116)
                        .transition(.asymmetric(insertion: AnyTransition.move(edge: .bottom).combined(with: .scale).animation(.easeInOut), removal: AnyTransition.opacity.animation(.easeInOut)))
                    } else {
                        CustomMenu {
                            Group {
                                Button(action: {
                                    selectedOption = RecordStatus.good
                                    isMenuVisible = false
                                }) {
                                    Text("좋음")
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.customGreen))
                                HorizontalDivider(color: Color.buttonGray, height: 2).padding(.horizontal, 12)
                                Button(action: {
                                    selectedOption = RecordStatus.fine
                                    isMenuVisible = false
                                }) {
                                    Text("양호")
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.lightYellow))
                                HorizontalDivider(color: Color.buttonGray, height: 2).padding(.horizontal, 12)
                                Button(action: {
                                    selectedOption = RecordStatus.bad
                                    isMenuVisible = false
                                }) {
                                    Text("나쁨")
                                }
                                .buttonStyle(CustomMenuButtonStyle(color: Color.customRed))
                            }
                        }
                        .frame(width: 108)
                        .offset(y: -92)
                        .transition(.asymmetric(insertion: AnyTransition.move(edge: .bottom).combined(with: .scale).animation(.easeInOut), removal: AnyTransition.opacity.animation(.easeInOut)))
                    }
                }
            }.frame(width: 80, height: 40)
        }
    }
}

#Preview {
    @State var leftColorVisionStatus = RecordStatus.nothing

    return CustomMenuButton(label: nil, isColorVision: true, selectedOption: $leftColorVisionStatus)
}
