//
//  PostModel.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 18.02.24.
//

import Foundation


struct PostModel {
    let indentifier: String
    let user = User(identifier: UUID().uuidString, username: "kaneywest", profilePictureUrl: nil)
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        Array(0...100).compactMap { _ in
            PostModel(indentifier: UUID().uuidString)
        }
    }
}
