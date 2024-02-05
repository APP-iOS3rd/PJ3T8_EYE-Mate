//
//  SignOutViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import Foundation

class SignOutViewModel: ObservableObject{
    @Published var signoutContents: [SignOutContent]
    
    init(signoutContents: [SignOutContent] = [
        .init(icon: "📊", title: "시력 검사 기록이 사라져요", subTitle: "EYE-Mate를 탈퇴하면 기록되어 관리되던 시력 검사 기록들이 모두 삭제되며, 복구할 수 없어요."),
        .init(icon: "📝", title: "게시판 정보가 사라져요", subTitle: "EYE-Mate를 탈퇴하면 작성한 게시판, 댓글, 저장한 게시글 등 관련 개인 기록이 삭제되며, 복구할 수 없어요."),
        .init(icon: "🔒", title: "시력 검사 기록이 사라져요", subTitle: "EYE-Mate를 탈퇴하면 기록, 게시판 기능 등 다시 회원가입을 해야 이용가능해요.")
    ]) {
        self.signoutContents = signoutContents
    }
}
