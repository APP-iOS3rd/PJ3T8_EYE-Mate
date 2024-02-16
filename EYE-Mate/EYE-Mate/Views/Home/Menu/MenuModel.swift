//
//  MenuModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct MenuModel {
    var img: Image
    var title: String
    var subTitle: String
    
    init(img: Image, title: String, subTitle: String) {
        self.img = img
        self.title = title
        self.subTitle = subTitle
    }
}
