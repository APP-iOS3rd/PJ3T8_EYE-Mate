//
//  Home.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    private var user = UserModel(name: "어디로 가야하오", movement: 3, leftEyeSight: "0.5", rightEyeSight: "0.8")
    private var onboardingModel = OnBoardingViewModel(title: "오늘의 눈 상식", subTitle: "전자기기를 보면 눈이 안좋아져요!")
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                CustomNavigationTitle(title: "홈", userImg: Image(systemName: "person.fill"))
                
                Spacer()
                    .frame(height: 5)
                
                HomeViewTextView(user: user)
                
                OnboardingView(onboardingViewModel: onboardingModel)
                    .frame(height: 120)
                    .padding(.top, -30)
                
                HomeViewCellListView()
                
            }
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
    var body: some View {
        HStack(spacing: 10) {
            NavigationLink(destination: RecordView()) {
                HomeViewCellView(item: .init(isAction: false, img: Image("Record"), title: "눈 기록", subTitle: "꼼꼼한 기록 관리"))
                    .padding(.leading, 10)
                    .foregroundColor(.black)
            }
            NavigationLink(destination: ColorTestView()) {
                HomeViewCellView(item: .init(isAction: false, img: Image("Movement"), title: "눈 운동", subTitle: "슉슉 무브무브"))
                    .padding(.trailing, 10)
                    .foregroundColor(.black)
            }
        }
        VStack {
            NavigationLink(destination: VisionTestView()) {
                HomeViewCellView(item: .init(isAction: true, img: Image("VisionTest1"), title: "시력 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            }
            NavigationLink(destination: ColorTestView()) {
                HomeViewCellView(item: .init(isAction: true, img: Image("VisionTest2"), title: "색채 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            }
            NavigationLink(destination: AstigmatismTestView()) {
                HomeViewCellView(item: .init(isAction: true, img: Image("VisionTest3"), title: "난시 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            }
            NavigationLink(destination: SightTestView()) {
                HomeViewCellView(item: .init(isAction: true, img: Image("VisionTest4"), title: "시야 검사", subTitle: "슉슉 무브무브"))
                    .padding([.leading, .trailing], 10)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    HomeView()
}
