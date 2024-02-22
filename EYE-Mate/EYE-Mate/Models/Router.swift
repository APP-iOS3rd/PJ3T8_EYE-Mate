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
        case checkVision
        case checkColor
        case checkAstigmatism
        case checkSight
        case distanceTest(title: String, testType: TestType)
        case visionTest
        case colorTest
        case astigmatismTest
        case sightTest
        case profile
        case signUpProfile
    }

    @Published var navigationPath = NavigationPath()

    func navigate(to destination: Destination) {
        navigationPath.append(destination)
    }

    func navigateBack() {
        navigationPath.removeLast()
    }

    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
