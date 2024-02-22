//
//  Router.swift
//  EYE-Mate
//
//  Created by seongjun on 2/21/24.
//

import SwiftUI

final class Router: ObservableObject {
    public enum Destination: Hashable {
        case record
        case allRecord(recordType: TestType)
        case addRecord
        case movementLottie(movementType: String)
    }

    @Published var navPath = NavigationPath()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
