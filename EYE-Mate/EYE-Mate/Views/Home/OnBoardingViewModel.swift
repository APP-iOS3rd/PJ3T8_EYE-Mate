//
//  onBoardingViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import Foundation

struct OnBoardingViewModel: Hashable {
    var title: String
    var subTitle: String
    
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
}
