//
//  PageControl.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/20.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    
    var totalPages: Int
    var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = totalPages
        control.currentPage = currentPage
        control.backgroundStyle = .minimal
        control.allowsContinuousInteraction = false
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.white)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.white).withAlphaComponent(0.3)
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = totalPages
        uiView.currentPage = currentPage
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.white)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.white).withAlphaComponent(0.3)
        
    }
}
