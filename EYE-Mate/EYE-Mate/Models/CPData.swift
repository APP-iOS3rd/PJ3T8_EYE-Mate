//
//  CData.swift
//  NaverMapDemo
//
//  Created by 이민영 on 2024/01/29.
//

import Foundation

struct CPData: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    static let allCountries:[CPData] = Bundle.main.decode("CountryNumbers.json")

}
