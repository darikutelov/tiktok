//
//  ProfileViewController.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 17.02.24.
//

import UIKit

class ProfileViewController: UIViewController {
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
    }
}
