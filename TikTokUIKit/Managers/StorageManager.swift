//
//  StorageManager.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 17.02.24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    private init() {}
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
}
