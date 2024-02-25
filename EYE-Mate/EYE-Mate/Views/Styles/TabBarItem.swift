//
//  TabBarItem.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/10.
//

import Foundation

enum TabBarItem: Hashable {
    case home, movement, community, eyeMap
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .movement:
            return "eyes"
        case .community:
            return "message.fill"
        case .eyeMap:
            return "map.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .movement:
            return "눈 운동"
        case .community:
            return "게시판"
        case .eyeMap:
            return "내주변"
        }
    }
}
