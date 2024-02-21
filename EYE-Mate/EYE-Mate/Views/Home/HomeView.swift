//
//  Home.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var profileViewModel = ProfileViewModel.shared
    @ObservedObject var eyeSenseOnBoardingViewModel: EyeSenseOnBoardingViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                CustomNavigationTitle(isDisplayLeftButton: false)
                
                Spacer()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HomeViewTextView(user: viewModel.user)
                        
                        EyeSenseOnboardingView(onboardingViewModel: eyeSenseOnBoardingViewModel)
                            .padding(.horizontal, 20)
                        
                        HomeViewCellListView(viewModel: viewModel)
                        
                        Spacer()
                    }
                }
                Spacer()
                    .frame(height: 85)
            }
        }
        
        .navigationDestination(isPresented: $profileViewModel.isPresentedProfileView) {
            ProfileView()
        }
        .navigationDestination(isPresented: $viewModel.isPresentedRecordView) {
            RecordView(viewModel: viewModel)
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
    @EnvironmentObject var tabManager: TabManager
    
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
                tabManager.selection = .movement
            }, label: {
                HomeViewCellView(item: .init(img: Image("Movement"), title: "눈 운동", subTitle: "눈 피로감 줄이기"))
                    .padding(.trailing, 10)
                    .foregroundColor(.black)
            })
        }
        .padding(.bottom, 5)
        
        VStack(spacing: 15) {
            Button(action: {
                viewModel.isPresentedVisionView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest1"), title: "시력 검사", subTitle: "나의 시력을 확인해보세요."))
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
            })
            Button(action: {
                viewModel.isPresentedColorView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest2"), title: "색채 검사", subTitle: "색상을 선명하게 구별할 수 있나요?"))
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
            })
            Button(action: {
                viewModel.isPresentedAstigmatismView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest3"), title: "난시 검사", subTitle: "난시의 징후가 있는지 검사하세요."))
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
            })
            Button(action: {
                viewModel.isPresentedSightView = true
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest4"), title: "시야 검사", subTitle: "시야의 문제 여부를 파악해보세요."))
                    .padding(.horizontal, 10)
                    .foregroundColor(.black)
            })
        }
    }
}

#Preview {
    HomeView(eyeSenseOnBoardingViewModel: EyeSenseOnBoardingViewModel())
}
