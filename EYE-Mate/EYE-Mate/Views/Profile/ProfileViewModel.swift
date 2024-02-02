//
//  profileViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject {
    
    enum ImageState {
        case empty, loading(Progress), success(Image), failure(Error)
    }
    
    @Published var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                switch result {
                case let .success(data?):
                    guard let uiImage = UIImage(data: data) else {
                        self.imageState = .empty
                        return
                    }
                    self.imageState = .success(Image(uiImage: uiImage))
                    
                case .success(.none):
                    self.imageState = .empty
                case let .failure(error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    func isValidName(_ name: String) -> String {
        let regex = #"^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣_-]{2,20}$"#
        
        // 문자열 길이 체크
        if name.count < 2 || name.count > 20 {
            return "2에서 20자 사이여야 합니다."
        }
        
        // 정규 표현식 체크
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: name) {
            return "한글, 영어, 숫자, -, _ 문자만 사용해야 합니다."
        }
        return "true"
    }
}
