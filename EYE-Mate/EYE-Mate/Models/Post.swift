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
    var postImageURLs: [URL]? // 게시물에 첨부된 이미지들
    var imageReferenceIDs: [String]? // Image 삭제, 수정 할 때 사용
    var publishedDate: Date = Date() // 게시 Date
    var likedIDs: [String] = [] // 좋아요 누른 userID Array
    
    // MARK: 유저 정보
    var userName: String // 사용자 닉네임
    var userUID: String // 사용자 UID
    var userImageURL: URL?  // 사용자 ProfileImage
    
    var comments: [Comment] = [] // 댓글 Array
}

// MARK: 댓글
struct Comment: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    
    // MARK: 유저정보
    var userName: String // 댓글 유저 닉네임
    var userUID: String // 댓글 유저 UID
    var userImageURL: URL?  // 댓글 유저 프로필 이미지
    
    var likedIDs: [String] = [] // 좋아요 누른 userID Array
    
    var comment: String // 댓글 내용
    var publishedDate: Date = Date() // 게시 Date
//    var replyComments: [ReplyComment] = [] // 대댓글 Array
    var replyComments: [ReplyComment] = [] // 대댓글 Array
}

// MARK: 대댓글
struct ReplyComment: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?

    // MARK: 유저정보
    var userName: String // 대댓글 유저 닉네임
    var userUID: String // 대댓글 유저 UID
    var userImageURL: URL?  // 대댓글 유저 프로필 이미지

    var likedIDs: [String] = [] // 좋아요 누른 userID Array
    
    var comment: String // 대댓글 내용
    var publishedDate: Date = Date() // 게시 Date
}
