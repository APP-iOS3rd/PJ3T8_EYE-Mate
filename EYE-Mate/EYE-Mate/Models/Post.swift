//
//  Post.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/30/24.
//

import SwiftUI
import FirebaseFirestore

struct Post: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var postTitle: String // 게시물 제목
    var postContent: String // 게시물 내용
    var postImageURLs: [URL]? // Image 받아올 URL
    var imageReferenceID: String = "" // Image 삭제, 수정 할 때 사용
    var publishedDate: Date = Date() // 게시 Date
    var likedIDs: [String] = [] // 좋아요 누른 userID Array
    
    // MARK: 유저 정보
    var userName: String
    var userUID: String
    var userImageURL: URL?  // 사용자 ProfileImage
    
    var comments: [Comment] = []
}

// MARK: 댓글
struct Comment: Codable, Equatable, Hashable {
    // MARK: 유저정보
    var userName: String
    var userUID: String
    var userImageURL: URL?  // 사용자 ProfileImage
    
    var comment: String
    var publishedDate: Date = Date() // 게시 Date
    var replyComments: [ReplyComment]?
}

// MARK: 대댓글
struct ReplyComment: Codable, Equatable, Hashable {
    // MARK: 유저정보
    var userName: String
    var userUID: String
    var userImageURL: URL?  // 사용자 ProfileImage

    var comment: String
    var publishedDate: Date = Date() // 게시 Date
}
