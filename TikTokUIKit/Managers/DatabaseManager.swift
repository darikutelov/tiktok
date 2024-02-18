//
//  DatabaseManager.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 17.02.24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let db = Firestore.firestore()

    private init() {}
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
