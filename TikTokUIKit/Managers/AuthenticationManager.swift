//
//  AuthenticationManager.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 17.02.24.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    public static let shared = AuthenticationManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case google
    }
    
    public func singIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}
