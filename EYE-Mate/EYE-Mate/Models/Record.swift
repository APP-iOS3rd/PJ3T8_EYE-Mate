//
//  Record.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/06.
//

import Foundation
import FirebaseFirestore

//MARK: - 사용자 기록 모델
struct Record {
    @DocumentID var id: String?
}
