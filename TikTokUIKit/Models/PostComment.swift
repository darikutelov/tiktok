//
//  PostComment.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 18.02.24.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(identifier: UUID().uuidString, username: "kanyewest", profilePictureUrl: nil)
        
        return [
            PostComment(text: "This is an awesome post", user: user, date: Date()),
            PostComment(text: "This is cool", user: user, date: Date()),
            PostComment(text: "This is rad", user: user, date: Date()),
            PostComment(text: "This is another awesome post", user: user, date: Date()),
        ]
    }
}
