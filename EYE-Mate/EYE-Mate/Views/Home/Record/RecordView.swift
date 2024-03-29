//
//  Record.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var router: Router
    @AppStorage("user_UID") private var userUID: String = ""

    @ObservedObject private var recordViewModel = RecordViewModel.shared
    @ObservedObject private var viewModel = HomeViewModel.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared

    @State var showLoginAlert: Bool = false

    private func goBack() {
        router.navigateBack()
    }

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy.MM.dd (EEEEE)"

        return formatter
    }()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationTitle(title: "기록",
                                      isDisplayLeftButton: true)

                Spacer()

                HorizontalDivider(color: Color.customGreen, height: 4)
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Spacer()
                            Button {
                                if userUID == "" {
                                    showLoginAlert = true
                                } else {
                                    router.navigate(to: .addRecord)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 132, height: 32)
                                    .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                                    .foregroundStyle(Color.white)
                                    .overlay{
                                        HStack {
                                            Image(systemName: "plus")
                                                .foregroundStyle(Color.customGreen)
                                                .font(.system(size: 20))
                                            Text("기록 추가하기")
                                                .font(.pretendardRegular_16)
                                                .foregroundColor(.black)
                                        }
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.lightGray)
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            .navigationBarBackButtonHidden()
            .task {
                if userUID != "" {
                    do {
                        try await recordViewModel.fetchVisionRecord(uid: userUID)
                    } catch {
                        print("Error fetching vision records: \(error)")
                    }
                    do {
                        try await recordViewModel.fetchColorVisionRecord(uid: userUID)
                    } catch {
                        print("Error fetching colorVision records: \(error)")
                    }
                    do {
                        try await recordViewModel.fetchAstigmatismRecord(uid: userUID)
                    } catch {
                        print("Error fetching astigmatism records: \(error)")
                    }
                    do {
                        try await recordViewModel.fetchEyesightRecord(uid: userUID)
                    } catch {
                        print("Error fetching eyesight records: \(error)")
                    }
                }
            }
            if showLoginAlert {
                CustomAlertView(
                    title: "저희 아직 친구가 아니네요.",
                    message: "로그인이 필요해요!",
                    leftButtonTitle: "취소",
                    leftButtonAction: { showLoginAlert = false },
                    rightButtonTitle: "로그인",
                    rightButtonAction: {
                        loginViewModel.showFullScreenCover.toggle()
                        showLoginAlert = false
                    })
            }
        }
        .fullScreenCover(isPresented: $loginViewModel.showFullScreenCover, content: {
            LoginView(isAlertView: true)
        })
        .animation(.easeInOut(duration: 0.1), value: showLoginAlert)
    }


    @ViewBuilder
    func RecordDataBox(recordType: TestType) -> some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text(recordType.rawValue)
                        .font(.pretendardBold_20)
                    Spacer()
                    Button {
                        if userUID == "" {
                            showLoginAlert = true
                        } else {
                            router.navigate(to: .allRecord(recordType: recordType))
                        }
                    } label: {
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
                                            .font(.custom("NotoSansKR-Regular", size: 16))
                                            .frame(alignment: .leading)
                                        Spacer()
                                        HStack(spacing: 32) {
                                            HStack{
                                                Text("좌")
                                                    .font(.pretendardBold_18)
                                                Spacer().frame(width: 12)
                                                ColoredText(receivedText: "\(data.left)", font: .custom("NotoSansKR-Bold", size: 28))
                                            }.frame(width: 80)
                                            HStack{
                                                Text("우")
                                                    .font(.pretendardBold_18)
                                                Spacer().frame(width: 12)
                                                ColoredText(receivedText: "\(data.right)", font: .custom("NotoSansKR-Bold", size: 28))
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
                                            .font(.custom("NotoSansKR-Regular", size: 16))
                                            .frame(alignment: .leading)
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
                                            .font(.custom("NotoSansKR-Regular", size: 16))
                                            .frame(alignment: .leading)
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
                                            .font(.custom("NotoSansKR-Regular", size: 16))
                                            .frame(alignment: .leading)
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
