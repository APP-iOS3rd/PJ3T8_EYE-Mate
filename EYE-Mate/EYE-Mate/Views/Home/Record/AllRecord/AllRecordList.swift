//
//  AllRecordList.swift
//  EYE-Mate
//
//  Created by seongjun on 2/15/24.
//

import SwiftUI

struct VisionRecordModel: Hashable {
    var date: Date
    var place: String
    var left: Double
    var right: Double
}

struct ColorVisionRecordModel: Hashable {
    var date: Date
    var place: String
    var status: RecordStatus

}

struct AstigmatismRecordModel: Hashable {
    var date: Date
    var place: String
    var left: RecordStatus
    var right: RecordStatus
}

struct EyesightRecordModel: Hashable {
    var date: Date
    var place: String
    var left: RecordStatus
    var right: RecordStatus
}

struct AllRecordList: View {
    @State private var visionItems: [VisionRecordModel] =
    [
        VisionRecordModel(date: Date(), place: "EYE-Mate", left: 0.3, right: 0.7),
        VisionRecordModel(date: Date(), place: "EYE-Mate", left: 0.3, right: 0.7),
        VisionRecordModel(date: Date(), place: "EYE-Mate", left: 0.3, right: 0.7)
    ]

    @State private var colorVisionItems: [ColorVisionRecordModel] =
    [
        ColorVisionRecordModel(date: Date(), place: "EYE-Mate", status: .normal),
        ColorVisionRecordModel(date: Date(), place: "EYE-Mate", status: .serious),
        ColorVisionRecordModel(date: Date(), place: "EYE-Mate", status: .severe)
    ]

    @State private var astigmatismItems: [AstigmatismRecordModel] =
    [
        AstigmatismRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .good),
        AstigmatismRecordModel(date: Date(), place: "EYE-Mate", left: .fine, right: .fine),
        AstigmatismRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .fine)
    ]

    @State private var eyesightItems: [EyesightRecordModel] =
    [
        EyesightRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .good),
        EyesightRecordModel(date: Date(), place: "EYE-Mate", left: .fine, right: .fine),
        EyesightRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .fine)
    ]

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy.MM.dd (EEEEE)"

        return formatter
    }()

    let recordType: TestType

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
                .onDelete(perform: deleteItem)
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
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.25), radius: 4, x: 2, y: 2)
                }
                .onDelete(perform: deleteItem)
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
                .onDelete(perform: deleteItem)
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
                .onDelete(perform: deleteItem)
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

#Preview {
    AllRecordList(recordType: .colorVision)
}
