//
//  AllRecordList.swift
//  EYE-Mate
//
//  Created by seongjun on 2/15/24.
//

import SwiftUI

struct AllRecordList: View {
    @Binding var isDeleteMode: Bool

    let recordType: TestType

    @Binding var visionItems: [VisionRecordModel]
    @Binding var colorVisionItems: [ColorVisionRecordModel]
    @Binding var astigmatismItems: [AstigmatismRecordModel]
    @Binding var eyesightItems: [EyesightRecordModel]

    @Binding var selectedVisionItems: [UUID]
    @Binding var selectedColorVisionItems: [UUID]
    @Binding var selectedAstigmatismItems: [UUID]
    @Binding var selectedEyesightVisionItems: [UUID]

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy.MM.dd (EEEEE)"

        return formatter
    }()

    private func deleteItem(at offsets: IndexSet) {
        switch recordType {
        case .vision:
            visionItems.remove(atOffsets: offsets)
        case .colorVision:
            colorVisionItems.remove(atOffsets: offsets)
        case .astigmatism:
            astigmatismItems.remove(atOffsets: offsets)
        case .eyesight:
            eyesightItems.remove(atOffsets: offsets)
        }
    }

    var body: some View {
        if recordType == .vision {
            List {
                ForEach(visionItems, id: \.self) { item in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedVisionItems.firstIndex(of: item.id) {
                                    selectedVisionItems.remove(at: index)
                                } else {
                                    selectedVisionItems.append(item.id)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedVisionItems.contains(item.id) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordList.dateFormat.string(from: item.date))")
                                    .font(.pretendardRegular_18)
                                Text(item.place)
                                    .font(.pretendardRegular_16)
                                    .foregroundStyle(.gray)
                            }

                            Spacer().frame(width: 32)
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: "\(String(format: "%.1f", item.left))", font: .pretendardBold_28)
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: "\(String(format: "%.1f", item.right))", font: .pretendardBold_28)
                            }
                            Spacer()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
                .onDelete(perform: isDeleteMode ? nil : deleteItem)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)

            }
            .listStyle(.plain)
        } else if recordType == .colorVision {
            List {
                ForEach(colorVisionItems, id: \.self) { item in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedColorVisionItems.firstIndex(of: item.id) {
                                    selectedColorVisionItems.remove(at: index)
                                } else {
                                    selectedColorVisionItems.append(item.id)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedColorVisionItems.contains(item.id) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordList.dateFormat.string(from: item.date))")
                                    .font(.pretendardRegular_18)
                                Text(item.place)
                                    .font(.pretendardRegular_16)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            ColoredText(receivedText: item.status.rawValue, font: .pretendardBold_20)
                            Spacer()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
                .onDelete(perform: isDeleteMode ? nil : deleteItem)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .listStyle(.plain)
        } else if recordType == .astigmatism {
            List {
                ForEach(astigmatismItems, id: \.self) { item in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedAstigmatismItems.firstIndex(of: item.id) {
                                    selectedAstigmatismItems.remove(at: index)
                                } else {
                                    selectedAstigmatismItems.append(item.id)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedAstigmatismItems.contains(item.id) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordList.dateFormat.string(from: item.date))")
                                    .font(.pretendardRegular_18)
                                Text(item.place)
                                    .font(.pretendardRegular_16)
                                    .foregroundStyle(.gray)
                            }
                            Spacer().frame(width: 32)
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: item.left.rawValue, font: .pretendardBold_28)
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: item.right.rawValue, font: .pretendardBold_28)
                            }
                            Spacer()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
                .onDelete(perform: isDeleteMode ? nil : deleteItem)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .listStyle(.plain)
        } else if recordType == .eyesight {
            List {
                ForEach(eyesightItems, id: \.self) { item in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedEyesightVisionItems.firstIndex(of: item.id) {
                                    selectedEyesightVisionItems.remove(at: index)
                                } else {
                                    selectedEyesightVisionItems.append(item.id)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedEyesightVisionItems.contains(item.id) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordList.dateFormat.string(from: item.date))")
                                    .font(.pretendardRegular_18)
                                Text(item.place)
                                    .font(.pretendardRegular_16)
                                    .foregroundStyle(.gray)
                            }
                            Spacer().frame(width: 32)
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: item.left.rawValue, font: .pretendardBold_28)
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: item.right.rawValue, font: .pretendardBold_28)
                            }
                            Spacer()
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
                .onDelete(perform: isDeleteMode ? nil : deleteItem)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .listStyle(.plain)
        }
    }
}
