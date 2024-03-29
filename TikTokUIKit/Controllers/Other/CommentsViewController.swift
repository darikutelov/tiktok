//
//  CommentViewController.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 18.02.24.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {
    
    // MARK: - Props
    
    private let post: PostModel
    private var comments = [PostComment]()
    weak var delegate: CommentsViewControllerDelegate?
    
    // MARK: - UI Elements
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .darkGray
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Init
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        fetchPostComments()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        closeButton.frame = CGRect(x: view.width - 35, y: 10, width: 25, height: 25)
        
        tableView.frame = CGRect(x: 0,
                                 y: closeButton.bottom,
                                 width: view.width,
                                 height: view.height - closeButton.bottom)
    }
    
    // MARK: - Private methods
    
    private func fetchPostComments() {
        self.comments = PostComment.mockComments()
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
}

// MARK: - Table View delegate

extension CommentsViewController: UITableViewDelegate {
    
}

// MARK: - Table View data source

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configire(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
