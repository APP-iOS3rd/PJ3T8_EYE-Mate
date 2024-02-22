//
//  EyeSenseOnboardingView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/19.
//

import SwiftUI

struct EyeSenseOnboardingView: View {
    @ObservedObject var onboardingViewModel: EyeSenseOnBoardingViewModel
    
    init(onboardingViewModel: EyeSenseOnBoardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    @State var showModal: Bool = false
    // Tabview page 넘기기에 관련된 변수
    @State private var timer: Timer?
    @State private var currentPage: String = ""
    @State private var listOfPages: [Article] = []
    @State private var fakedPages: [Article] = []
    let sizeWidth = CGFloat(UIScreen.main.bounds.width - 50)
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage){
                ForEach(fakedPages) { Page in
                    NavigationLink(destination: EyeSenseView(url: Page.url)){
                        VStack(alignment: .leading, spacing: 10){
                            EyeSenseTitleView()
                                .padding(.top, 15)
                                .padding(.leading, 15)
                            
                            HStack(alignment: .center) {
                                Spacer()
                                Text("\"\(Page.title)\"")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .font(.pretendardSemiBold_18)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .tag(Page.id.uuidString)
                    // 무한 스크롤을 위한 Offset 계산
                    .offsetX(currentPage == Page.id.uuidString){ rect in
                        let minX = rect.minX
                        let pageOffset = minX - (sizeWidth * CGFloat(fakeIndex(Page))) - 20
                        let pageProgress = pageOffset / sizeWidth
                        
                        if -pageProgress < 1.0 {
                            
                            if fakedPages.indices.contains(fakedPages.count - 1) {
                                currentPage = fakedPages[fakedPages.count - 1].id.uuidString
                            }
                        }
                        
                        if -pageProgress > CGFloat(fakedPages.count - 1) {
                            if fakedPages.indices.contains(1) {
                                currentPage = fakedPages[1].id.uuidString
                            }
                        }
                    }
                }
            }
            .accentColor(.customGreen)
            .frame(height: 110)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "62D8C5"), Color(hex: "70A8D6")]), startPoint: .top, endPoint: .bottom)
                    )
            )
            
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                PageControl(totalPages: listOfPages.count, currentPage: originalIndex(currentPage))
                    .offset(y: -15)
            }
        }
        .onAppear {
            Task{
                listOfPages.removeAll()
                fakedPages.removeAll()
                listOfPages = await onboardingViewModel.fetchData()
                fakedPages.append(contentsOf: listOfPages)
                
                if var firstPage = listOfPages.first, var lastPage = listOfPages.last {
                    currentPage = firstPage.id.uuidString
                    
                    firstPage.id = .init()
                    lastPage.id = .init()
                    
                    fakedPages.append(firstPage)
                    fakedPages.insert(lastPage, at: 0)
                }
                // 페이지 변경 시 애니메이션 적용 - startTimer안에선 적용하면 X(이유 모름)
                withAnimation{
                    startTimer()
                }
            }

            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.white)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(.white).withAlphaComponent(0.3)
        }
        .onDisappear {
            // 뷰가 사라질 때 타이머 중지
            stopTimer()
        }
        
    }
    
    func fakeIndex(_ of: Article) -> Int {
        return fakedPages.firstIndex(of: of) ?? 0
    }
    
    func originalIndex(_ id: String) -> Int {
        return listOfPages.firstIndex { page in
            page.id.uuidString == id
        } ?? 0
    }
    
    // 타이머 시작
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            DispatchQueue.main.async {
                // 타이머의 핸들러에서 페이지 변경 로직
                if let currentPageIndex = fakedPages.firstIndex(where: { $0.id.uuidString == currentPage }) {
                    var nextPageIndex = currentPageIndex + 1
                    if nextPageIndex >= fakedPages.count - 1 {
                        nextPageIndex = 1 // 다음 페이지가 없으면 첫 페이지로 돌아감
                    }
                    currentPage = fakedPages[nextPageIndex].id.uuidString
                }
                
            }
        }
    }
    
    // 타이머 중지
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct EyeSenseTitleView: View {
    var body: some View {
        HStack (spacing: 10){
            Image("EyeSenseIcon")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("알고 계셨나요?")
                .font(.pretendardBold_16)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading, 0)
    }
}


#Preview {
    EyeSenseOnboardingView(onboardingViewModel: EyeSenseOnBoardingViewModel(title: "현대인의 눈 피로 원인, 컴퓨터시력증후군(CVS)"))
}
