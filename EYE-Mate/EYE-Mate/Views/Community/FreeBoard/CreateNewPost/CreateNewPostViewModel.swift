//
//  CreateNewPostViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/26/24.
//

import SwiftUI
import PhotosUI

class CreateNewPostViewModel: ObservableObject {
    // 게시물 제목, 내용
    @Published var postTitle: String = ""
    @Published var postContent: String = ""
    
    // 선택된 사진
    @Published var postImageDatas: [Data] = []
    
    // PhotosPicker
    @Published var showImagePicker: Bool = false
    @Published var photoItem: [PhotosPickerItem] = []
    
    // 이미지 로딩 중임을 알리는 변수
    @Published var isLoading = false
    
    /// 작성하기 버튼 활성 조건 get
    /// - true =  버튼 활성, false = 버튼 비활성
    func postButtonActive() -> Bool {
        return !postTitle.isEmpty && !postContent.isEmpty
    }
    
    ///
    func addSelectedImages() {
        if !photoItem.isEmpty {
            Task {
                await MainActor.run {
                    isLoading = true
                }
                for item in photoItem {
                    if postImageDatas.count == 10 { break } // 사진 수 제한
                    if let imageData = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: imageData),
                       let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                        await MainActor.run {
//                            postImageDatas.append(ImageData(data: compressedImageData))
                            postImageDatas.append(compressedImageData)
                        }
                    }
                }
                await MainActor.run{
                    isLoading = false
                    photoItem = []
                }
            }
        }
    }
    
    /// 이미지 삭제 함수
    func removeImage(at index: Int) {
        postImageDatas.remove(at: index)
    }
    
    /// Firebase에 게시물 업로드
    func uploadPost() {
        // MARK: Firebase
    }
}

//struct ImageData: Identifiable, Equatable {
//    let id = UUID()
//    let data: Data
//}
