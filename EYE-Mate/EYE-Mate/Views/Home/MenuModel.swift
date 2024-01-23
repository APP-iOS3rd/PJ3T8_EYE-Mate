//
//  MenuModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct MenuModel {
    var isAction: Bool
    var img: Image
    var title: String
    var subTitle: String
    
    init(isAction: Bool, img: Image, title: String, subTitle: String) {
        self.isAction = isAction
        self.img = img
        self.title = title
        self.subTitle = subTitle
    }
}
