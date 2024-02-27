//
//  AllRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordView: View {
    let recordType: TestType
    @ObservedObject private var recordViewModel = RecordViewModel.shared

    @AppStorage("user_UID") private var userUID: String = ""

    @State private var isDeleteMode = false
    @State var isDeleteAlert: Bool = false
    @State var isDeleteOneItemAlert: Bool = false
    @State var deleteRecord: (any Identifiable)? = nil

    @State private var selectedVisionItems: [String] = []
    @State private var selectedColorVisionItems: [String] = []
    @State private var selectedAstigmatismItems: [String] = []
    @State private var selectedEyesightVisionItems: [String] = []

    var body: some View {
        ZStack {
            VStack {
                AllRecordHeader(isDeleteMode: $isDeleteMode, isDeleteAlert: $isDeleteAlert, selectedVisionItems: $selectedVisionItems, selectedColorVisionItems: $selectedColorVisionItems, selectedAstigmatismItems: $selectedAstigmatismItems, selectedEyesightVisionItems: $selectedEyesightVisionItems, recordType: recordType )
                RecordList()
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .task {
                switch recordType {
                case .vision:
                    do {
                        try await recordViewModel.fetchVisionRecord(uid: userUID)
                    } catch {
                        print("Error fetching vision records: \(error)")
                    }
                case .colorVision:
                    do {
                        try await recordViewModel.fetchColorVisionRecord(uid: userUID)
                    } catch {
                        print("Error fetching colorVision records: \(error)")
                    }
                case .astigmatism:
                    do {
                        try await recordViewModel.fetchAstigmatismRecord(uid: userUID)
                    } catch {
                        print("Error fetching astigmatism records: \(error)")
                    }
                case .eyesight:
                    do {
                        try await recordViewModel.fetchEyesightRecord(uid: userUID)
                    } catch {
                        print("Error fetching eyesight records: \(error)")
                    }
                }
            }
            if isDeleteAlert {
                ZStack{
                    // 배경화면
                    Color.gray.opacity(0.4).edgesIgnoringSafeArea(.all)
                    CustomAlertView(
                        title: "정말 삭제하시겠습니까?",
                        message: "삭제한 기록은 되돌릴 수 없습니다.",
                        leftButtonTitle: "취소",
                        leftButtonAction: { isDeleteAlert = false },
                        rightButtonTitle: "삭제",
                        rightButtonAction: {
                            deleteSelectedItems()
                            isDeleteAlert = false
                        })
                }
                .animation(.easeInOut(duration: 0.1), value: isDeleteAlert)
            }
            if isDeleteOneItemAlert {
                ZStack{
                    // 배경화면
                    Color.gray.opacity(0.4).edgesIgnoringSafeArea(.all)
                    CustomAlertView(
                        title: "정말 삭제하시겠습니까?",
                        message: "삭제한 기록은 되돌릴 수 없습니다.",
                        leftButtonTitle: "취소",
                        leftButtonAction: { isDeleteOneItemAlert = false },
                        rightButtonTitle: "삭제",
                        rightButtonAction: {
                            withAnimation {
                                deleteItem(item: deleteRecord!)
                            }
                            isDeleteOneItemAlert = false
                        })
                }
                .animation(.easeInOut(duration: 0.1), value: isDeleteOneItemAlert)
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

    private func deleteItem<T: Identifiable>(item: T) {
        if let visionRecord = item as? VisionRecord {
            if let record = recordViewModel.visionRecords.first(where: { $0.id == visionRecord.id }) {
                recordViewModel.deleteVisionRecord(uid: userUID, record: record)
            }
        } else if let colorVisionRecord = item as? ColorVisionRecord {
            if let record = recordViewModel.colorVisionRecords.first(where: { $0.id == colorVisionRecord.id }) {
                recordViewModel.deleteColorVisionRecord(uid: userUID, record: record)
            }
        } else if let astigmatismRecord = item as? AstigmatismRecord {
            if let record = recordViewModel.astigmatismRecords.first(where: { $0.id == astigmatismRecord.id }) {
                recordViewModel.deleteAstigmatismVisionRecord(uid: userUID, record: record)
            }
        } else if let eyesightRecord = item as? EyesightRecord {
            if let record = recordViewModel.eyesightRecords.first(where: { $0.id == eyesightRecord.id }) {
                recordViewModel.deleteEyesightVisionRecord(uid: userUID, record: record)
            }
        }
        isDeleteOneItemAlert = true
    }

    private func deleteSelectedItems() {
        switch recordType {
        case .vision:
            selectedVisionItems.forEach { id in
                if let record = recordViewModel.visionRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteVisionRecord(uid: userUID, record: record)
                }
            }
        case .colorVision:
            selectedColorVisionItems.forEach { id in
                if let record = recordViewModel.colorVisionRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteColorVisionRecord(uid: userUID, record: record)
                }
            }
        case .astigmatism:
            selectedAstigmatismItems.forEach { id in
                if let record = recordViewModel.astigmatismRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteAstigmatismVisionRecord(uid: userUID, record: record)
                }
            }
        case .eyesight:
            selectedEyesightVisionItems.forEach { id in
                if let record = recordViewModel.eyesightRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteEyesightVisionRecord(uid: userUID, record: record)
                }
            }
        }

        switch recordType {
        case .vision:
            selectedVisionItems.removeAll()
        case .colorVision:
            selectedColorVisionItems.removeAll()
        case .astigmatism:
            selectedAstigmatismItems.removeAll()
        case .eyesight:
            selectedEyesightVisionItems.removeAll()
        }

        isDeleteMode = false
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
                            Spacer()
                            HStack(spacing: 16) {
                                Text("좌")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: "\(data.left)", font: .custom("NotoSansKR-Bold", size: 28))
                            }
                            Spacer().frame(width: 24)
                            HStack(spacing: 16) {
                                Text("우")
                                    .font(.pretendardSemiBold_18)
                                ColoredText(receivedText: "\(data.right)", font: .custom("NotoSansKR-Bold", size: 28))
                            }
                        }
                        .swipeActions {
                            if !isDeleteMode {
                                Button("Delete") {
                                    deleteRecord = data
                                    isDeleteOneItemAlert = true
                                }
                                .tint(.red)
                            }
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
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
                        .swipeActions {
                            if !isDeleteMode {
                                Button("Delete") {
                                    deleteRecord = data
                                    isDeleteOneItemAlert = true
                                }
                                .tint(.red)
                            }
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
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
                        .swipeActions {
                            if !isDeleteMode {
                                Button("Delete") {
                                    deleteRecord = data
                                    isDeleteOneItemAlert = true
                                }
                                .tint(.red)
                            }
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
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
                        .swipeActions {
                            if !isDeleteMode {
                                Button("Delete") {
                                    deleteRecord = data
                                    isDeleteOneItemAlert = true
                                }
                                .tint(.red)
                            }
                        }
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 24)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                }
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
