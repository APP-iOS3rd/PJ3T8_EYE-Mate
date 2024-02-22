//
//  AllRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordView: View {
    let recordType: TestType
    @ObservedObject private var recordViewModel = RecordViewModel()

    @State private var isDeleteMode = false

    @State private var selectedVisionItems: [String] = []
    @State private var selectedColorVisionItems: [String] = []
    @State private var selectedAstigmatismItems: [String] = []
    @State private var selectedEyesightVisionItems: [String] = []

    var body: some View {

        // FIXME: 전역으로 상태 관리하는 방법이 있을 것 같음
        VStack {
            AllRecordHeader(isDeleteMode: $isDeleteMode, selectedVisionItems: $selectedVisionItems, selectedColorVisionItems: $selectedColorVisionItems, selectedAstigmatismItems: $selectedAstigmatismItems, selectedEyesightVisionItems: $selectedEyesightVisionItems, recordType: recordType )
            RecordList()
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .task {
            switch recordType {
            case .vision:
                do {
                    try await recordViewModel.fetchVisionRecord()
                } catch {
                    print("Error fetching vision records: \(error)")
                }
            case .colorVision:
                do {
                    try await recordViewModel.fetchColorVisionRecord()
                } catch {
                    print("Error fetching colorVision records: \(error)")
                }
            case .astigmatism:
                do {
                    try await recordViewModel.fetchAstigmatismRecord()
                } catch {
                    print("Error fetching astigmatism records: \(error)")
                }
            case .eyesight:
                do {
                    try await recordViewModel.fetchEyesightRecord()
                } catch {
                    print("Error fetching eyesight records: \(error)")
                }
            }
        }
    }

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
            for index in offsets {
                let record = recordViewModel.visionRecords[index]
                recordViewModel.deleteVisionRecord(record: record)
            }
        case .colorVision: 
            for index in offsets {
                let record = recordViewModel.colorVisionRecords[index]
                recordViewModel.deleteColorVisionRecord(record: record)
            }
        case .astigmatism: 
            for index in offsets {
                let record = recordViewModel.astigmatismRecords[index]
                recordViewModel.deleteAstigmatismVisionRecord(record: record)
            }
        case .eyesight:
            for index in offsets {
                let record = recordViewModel.eyesightRecords[index]
                recordViewModel.deleteEyesightVisionRecord(record: record)
            }
        }
    }

    @ViewBuilder
    func RecordList() -> some View {
        if recordType == .vision {
            List {
                ForEach(recordViewModel.visionRecords, id: \.id) { data in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedVisionItems.firstIndex(of: data.id!) {
                                    selectedVisionItems.remove(at: index)
                                } else {
                                    selectedVisionItems.append(data.id!)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedVisionItems.contains(data.id!) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordView.dateFormat.string(from: data.publishedDate))")
                                    .font(.pretendardRegular_18)
                                //                                Text(data.place)
                                //                                    .font(.pretendardRegular_16)
                                //                                    .foregroundStyle(.gray)
                            }

                            Spacer().frame(width: 32)
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: "\(data.left)", font: .custom("Noto Sans-Bold", size: 28))
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: "\(data.right)", font: .custom("Noto Sans-Bold", size: 28))
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
                ForEach(recordViewModel.colorVisionRecords, id: \.self) { data in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedColorVisionItems.firstIndex(of: data.id!) {
                                    selectedColorVisionItems.remove(at: index)
                                } else {
                                    selectedColorVisionItems.append(data.id!)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedColorVisionItems.contains(data.id!) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordView.dateFormat.string(from: data.publishedDate))")
                                    .font(.pretendardRegular_18)
                                //                                Text(item.place)
                                //                                    .font(.pretendardRegular_16)
                                //                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            ColoredText(receivedText: data.status, font: .pretendardBold_20)
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
                ForEach(recordViewModel.astigmatismRecords, id: \.self) { data in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedAstigmatismItems.firstIndex(of: data.id!) {
                                    selectedAstigmatismItems.remove(at: index)
                                } else {
                                    selectedAstigmatismItems.append(data.id!)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedAstigmatismItems.contains(data.id!) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordView.dateFormat.string(from: data.publishedDate))")
                                    .font(.pretendardRegular_18)
                                //                                Text(item.place)
                                //                                    .font(.pretendardRegular_16)
                                //                                    .foregroundStyle(.gray)
                            }
                            Spacer().frame(width: 32)
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: data.left, font: .pretendardBold_28)
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: data.right, font: .pretendardBold_28)
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
                ForEach(recordViewModel.eyesightRecords, id: \.self) { data in
                    HStack {
                        if isDeleteMode {
                            Button {
                                if let index = selectedEyesightVisionItems.firstIndex(of: data.id!) {
                                    selectedEyesightVisionItems.remove(at: index)
                                } else {
                                    selectedEyesightVisionItems.append(data.id!)
                                }
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(selectedEyesightVisionItems.contains(data.id!) ? .blue : .gray)
                                    .font(.system(size: 24))
                            }
                        }
                        HStack {
                            VStack(spacing: 6) {
                                Text("\(AllRecordView.dateFormat.string(from: data.publishedDate))")
                                    .font(.pretendardRegular_18)
                                //                                Text(item.place)
                                //                                    .font(.pretendardRegular_16)
                                //                                    .foregroundStyle(.gray)
                            }
                            Spacer().frame(width: 32)
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: data.left, font: .pretendardBold_28)
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: data.right, font: .pretendardBold_28)
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

#Preview {
    AllRecordView(recordType: TestType.eyesight)
}
