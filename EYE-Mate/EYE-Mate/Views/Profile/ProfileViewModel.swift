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
    
    @Published private(set) var imageState: ImageState = .empty
    
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
    
}
