//
//  Record.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var recordViewModel = RecordViewModel()

    @State private var visions = []

    private func goBack() {
        presentationMode.wrappedValue.dismiss()
    }

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy.MM.dd (EEEEE)"

        return formatter
    }()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(alignment: .bottom) {
                    HStack(alignment: .bottom, spacing: 8) {
                        Button {
                            goBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 32))
                                .padding(.bottom, 2)
                        }
                        VStack(alignment: .leading, spacing: 12) {
                            Text("EYE-Mate")
                                .font(.pretendardSemiBold_22)
                            Text("기록")
                                .font(.pretendardSemiBold_32)
                        }
                    }
                    Spacer()
                    Circle()
                        .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50)
                }
                .frame(height: 80)
                .padding(.leading, 12)
                .padding(.trailing, 36)
                .padding(.bottom, 24)
                HorizontalDivider(color: Color.customGreen, height: 4)
                ScrollView {
                    LazyVStack(spacing: 16) {
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(maxWidth: 320)
                                .frame(height: 32)
                                .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                                .foregroundStyle(Color.white)
                                .overlay{
                                    Text("23년 11월 21일(월) ~ 24년 01월 17일(수)")
                                        .font(.pretendardRegular_16)
                                }

                            NavigationLink(destination: AddRecordView()) {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(maxWidth: 40)
                                    .frame(height: 32)
                                    .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                                    .foregroundStyle(Color.white)
                                    .overlay{
                                        Image(systemName: "plus")
                                            .foregroundStyle(Color.customGreen)
                                            .font(.system(size: 20))
                                    }
                            }
                        }
                        RecordDataBox(recordType: .vision)
                        if recordViewModel.recentVisionRecords.isEmpty {
                            EmptyVisionChart()
                        } else {
                            VisionChart(visionRecords: recordViewModel.recentVisionRecords)
                        }
                        RecordDataBox(recordType: .colorVision)
                        RecordDataBox(recordType: .astigmatism)
                        RecordDataBox(recordType: .eyesight)
                    }.padding(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.lightGray)
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
            }
            .navigationBarBackButtonHidden()
            .task {
                do {
                    try await recordViewModel.fetchVisionRecord()
                } catch {
                    print("Error fetching vision records: \(error)")
                }
                do {
                    try await recordViewModel.fetchColorVisionRecord()
                } catch {
                    print("Error fetching colorVision records: \(error)")
                }
                do {
                    try await recordViewModel.fetchAstigmatismRecord()
                } catch {
                    print("Error fetching astigmatism records: \(error)")
                }
                do {
                    try await recordViewModel.fetchEyesightRecord()
                } catch {
                    print("Error fetching eyesight records: \(error)")
                }
            }
        }
    }

    @ViewBuilder
    func RecordDataBox(recordType: TestType) -> some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text(recordType.rawValue)
                        .font(.pretendardBold_20)
                    Spacer()
                    NavigationLink(destination: AllRecordView(recordType: recordType)) {
                        Text("모두보기")
                            .font(.pretendardRegular_14)
                            .foregroundStyle(.black)
                    }
                }
                HorizontalDivider(color: Color.lightGray, height: 3)
                VStack(alignment: .leading, spacing: 0) {
                    switch recordType {
                    case .vision:
                        if recordViewModel.recentVisionRecords.isEmpty {
                            Text("검사 이력이 없습니다")
                                .font(.pretendardBold_20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(recordViewModel.recentVisionRecords, id: \.id) { data in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("\(RecordView.dateFormat.string(from: data.publishedDate))")
                                            .font(.custom("Noto Sans-Regular", size: 16))
                                            .frame(width: 120, alignment: .leading)
                                        Spacer()
                                        HStack(spacing: 32) {
                                            HStack{
                                                Text("좌")
                                                    .font(.pretendardBold_18)
                                                Spacer().frame(width: 12)
                                                ColoredText(receivedText: "\(data.left)", font: .custom("Noto Sans-Bold", size: 28))
                                            }.frame(width: 80)
                                            HStack{
                                                Text("우")
                                                    .font(.pretendardBold_18)
                                                Spacer().frame(width: 12)
                                                ColoredText(receivedText: "\(data.right)", font: .custom("Noto Sans-Bold", size: 28))
                                            }.frame(width: 80)
                                        }
                                    }.frame(height: 52)

                                    if data.id != recordViewModel.recentVisionRecords.last?.id {
                                        HorizontalDivider(color: Color.lightGray, height: 1)
                                    }
                                }
                            }

                        }
                    case .colorVision:
                        if recordViewModel.recentColorVisionRecords.isEmpty {
                            Text("검사 이력이 없습니다")
                                .font(.pretendardBold_20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(recordViewModel.recentColorVisionRecords, id: \.id) { data in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("\(RecordView.dateFormat.string(from: data.publishedDate))")
                                            .font(.custom("Noto Sans-Regular", size: 16))
                                            .frame(width: 120, alignment: .leading)
                                        Spacer()
                                        ColoredText(receivedText: "\(data.status)", font: .pretendardBold_20)
                                        Spacer()
                                    }.frame(height: 52)

                                    if data.id != recordViewModel.recentColorVisionRecords.last?.id {
                                        HorizontalDivider(color: Color.lightGray, height: 1)
                                    }
                                }
                            }
                        }
                    case .astigmatism:
                        if recordViewModel.recentAstigmatismRecords.isEmpty {
                            Text("검사 이력이 없습니다")
                                .font(.pretendardBold_20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(recordViewModel.recentAstigmatismRecords, id: \.id) { data in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("\(RecordView.dateFormat.string(from: data.publishedDate))")
                                            .font(.custom("Noto Sans-Regular", size: 16))
                                            .frame(width: 120, alignment: .leading)
                                        Spacer()
                                        HStack(spacing: 32) {
                                            HStack{
                                                Text("좌")
                                                    .font(.pretendardBold_18)
                                                Spacer()
                                                ColoredText(receivedText: "\(data.left)", font: .pretendardBold_28)
                                            }.frame(width: 80)
                                            HStack{
                                                Text("우")
                                                    .font(.pretendardBold_18)
                                                Spacer()
                                                ColoredText(receivedText: "\(data.right)", font: .pretendardBold_28)
                                            }.frame(width: 80)
                                        }
                                    }.frame(height: 52)

                                    if data.id != recordViewModel.recentAstigmatismRecords.last?.id {
                                        HorizontalDivider(color: Color.lightGray, height: 1)
                                    }
                                }
                            }
                        }
                    case .eyesight:
                        if recordViewModel.recentEyesightRecords.isEmpty {
                            Text("검사 이력이 없습니다")
                                .font(.pretendardBold_20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(recordViewModel.recentEyesightRecords, id: \.id) { data in
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("\(RecordView.dateFormat.string(from: data.publishedDate))")
                                            .font(.custom("Noto Sans-Regular", size: 16))
                                            .frame(width: 120, alignment: .leading)
                                        Spacer()
                                        HStack(spacing: 32) {
                                            HStack{
                                                Text("좌")
                                                    .font(.pretendardBold_18)
                                                Spacer()
                                                ColoredText(receivedText: "\(data.left)", font: .pretendardBold_28)
                                            }.frame(width: 80)
                                            HStack{
                                                Text("우")
                                                    .font(.pretendardBold_18)
                                                Spacer()
                                                ColoredText(receivedText: "\(data.right)", font: .pretendardBold_28)
                                            }.frame(width: 80)
                                        }
                                    }.frame(height: 52)

                                    if data.id != recordViewModel.recentEyesightRecords.last?.id {
                                        HorizontalDivider(color: Color.lightGray, height: 1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
        }
    }
}

#Preview {
    RecordView()
}
