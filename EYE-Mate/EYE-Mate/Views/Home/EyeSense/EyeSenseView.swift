//
//  EyeSense.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI
import WebKit

struct EyeSenseView: View {
    var onboardingViewModel: EyeSenseOnBoardingViewModel
    var body: some View {
        VStack{
            ArticleView()
                .padding(.top, 30)
        }
    }
}

struct ArticleView: UIViewRepresentable {
    var urlToLoad: String = "https://www.bnviit.com/blog/health/%ED%98%84%EB%8C%80%EC%9D%B8%EC%9D%98-%EB%88%88-%ED%94%BC%EB%A1%9C-%EC%9B%90%EC%9D%B8-%EC%BB%B4%ED%93%A8%ED%84%B0%EC%8B%9C%EB%A0%A5%EC%A6%9D%ED%9B%84%EA%B5%B0cvs%EC%97%90-%EB%8C%80%ED%95%B4/"
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: urlToLoad) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // onChage마다 update?
    }
}


#Preview {
    EyeSenseView(onboardingViewModel: EyeSenseOnBoardingViewModel(title: "현대인의 눈 피로 원인, 컴퓨터시력증후군(CVS)"))
}
