//
//  FreeBoardViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/30/24.
//

import Foundation

class FreeBoardViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        self.posts = [
            Post(
                id: "q1",
                postTitle: "흡연이 눈건강에 미치는 영향",
                postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.",
                postImageURLs: [
                    URL(string: "https://health.chosun.com/site/data/img_dir/2022/09/28/2022092802113_0.jpg")!,
                    URL(string: "https://health.chosun.com/site/data/img_dir/2022/09/28/2022092802113_0.jpg")!,
                    URL(string: "https://health.chosun.com/site/data/img_dir/2022/09/28/2022092802113_0.jpg")!,
                    URL(string: "https://health.chosun.com/site/data/img_dir/2022/09/28/2022092802113_0.jpg")!,
                    URL(string: "https://health.chosun.com/site/data/img_dir/2022/09/28/2022092802113_0.jpg")!
                ],
                 likedIDs: ["q","q","q","q","q","q","q","q","q","q","q","q","q","q","q","q","q"],
                 userName: "어디로 가야 하오",
                 userUID: "testUserUID",
                 userImageURL: URL(string: "https://health.chosun.com/site/data/img_dir/2020/02/21/2020022102899_0.jpg"),
                 comments: [
                    Comment(userName: "iOS", userUID: "commentUserId", userImageURL: URL(string:"https://cdn.fneyefocus.com/news/photo/202006/14093_17390_4826.jpg"), comment: "노력없이 성과를 이루고싶다.."),
                Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다.."),
                Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다.."), 
                Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다.."),
                Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다.."),
                Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다.."),
                Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다..")
                 ]),
            Post(id: "q2", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: [Comment(userName: "iOS", userUID: "commentUserId", comment: "노력없이 성과를 이루고싶다..")]),
            Post(id: "q21", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q3", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q4", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q5", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q6", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q7", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q8", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q9", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q10", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: []),
            Post(id: "q11", postTitle: "흡연이 눈건강에 미치는 영향", postContent: "우리나라는 담배 사용으로 인한 건강 폐해를 알리는 담뱃갑의 경고그림·경고문구, 건강경고 효과를 높이기 위해 2년마다 교체하고 있다. 2020년 12월 23일부터 새롭게 바뀐 담뱃갑에는 다음과 같이 표기되어 있다.경고: 흡연은 폐암 등 각종 질병의 원인! 그래도 피우시겠습니까?담배 연기에는 발암성 물질인 나프틸아민, 니켈, 벤젠, 비닐 크롤라이드, 비소, 카드뮴이 들어있습니다.", likedIDs: ["q","q","q","q","q"], userName: "어디로 가야 하오", userUID: "testUserUID", comments: [])
        ]
    }
    
    // MARK: Posts Fetch Function
    func fetchPosts() async {

    }
}
