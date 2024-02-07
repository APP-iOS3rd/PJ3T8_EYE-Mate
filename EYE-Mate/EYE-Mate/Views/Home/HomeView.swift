//
//  Home.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Binding var index: Int
    
    var body: some View {
        NavigationStack {
            GeometryReader { g in
                VStack(alignment: .leading) {
                    CustomNavigationTitle(isDisplayLeftButton: false,
                                          profileButtonAction: {
                        viewModel.isPresentedProfileView.toggle()
                    })
                    
                    Spacer()
                        .frame(height: 5)
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            HomeViewTextView(user: viewModel.user)
                            
                            EyeSenseOnboardingView(onboardingViewModel: viewModel.onboardingModel)
                                .frame(height: 120)
                                .padding(.top, -30)
                            
                            HomeViewCellListView(viewModel: viewModel, index: $index)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.isPresentedProfileView) {
            ProfileView()
        }
        .navigationDestination(isPresented: $viewModel.isPresentedRecordView) {
            RecordView()
        }
        .navigationDestination(isPresented: $viewModel.isPresentedVisionView) {
            VisionView()
        }
        .navigationDestination(isPresented: $viewModel.isPresentedColorView) {
            ColorView()
        }
        .navigationDestination(isPresented: $viewModel.isPresentedAstigmatismView) {
            AstigmatismView()
        }
        .navigationDestination(isPresented: $viewModel.isPresentedSightView) {
            SightView()
        }
    }
}

//MARK: - 상단 텍스트 뷰
private struct HomeViewTextView: View {
    var user : UserModel
    
    fileprivate init(user: UserModel) {
        self.user = user
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text(user.name + " 님!")
                    .font(.pretendardBold_22)
                Text("오늘도 눈 건강 챙기셨나요? 👀")
                    .font(.pretendardRegular_22)
            }
            .padding(.bottom, 10)
            VStack(alignment: .leading){
                Text("#오늘의 눈 운동 \(user.movement)회")
                    .font(.pretendardSemiBold_14)
                Text("#최근 시력 좌 \(user.leftEyeSight) 우 \(user.rightEyeSight)")
                    .font(.pretendardSemiBold_14)
            }
        }
        .padding(.leading, 20)
    }
}

//MARK: - 셀 리스트 뷰
private struct HomeViewCellListView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var index: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                viewModel.isPresentedRecordView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("Record"), title: "눈 기록", subTitle: "꼼꼼한 기록 관리"))
                    .padding(.leading, 10)
                    .foregroundColor(.black)
            })
            
            Button(action: {
                index = 1
            }, label: {
                HomeViewCellView(item: .init(img: Image("Movement"), title: "눈 운동", subTitle: "슉슉 무브무브"))
                    .padding(.trailing, 10)
                    .foregroundColor(.black)
            })
        }
        
        VStack {
            Button(action: {
                viewModel.isPresentedVisionView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest1"), title: "시력 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            })
            Button(action: {
                viewModel.isPresentedColorView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest2"), title: "색채 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            })
            Button(action: {
                viewModel.isPresentedAstigmatismView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest3"), title: "난시 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            })
            Button(action: {
                viewModel.isPresentedSightView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest4"), title: "시야 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            })
        }
    }
}

//#Preview {
//    HomeView()
//}
