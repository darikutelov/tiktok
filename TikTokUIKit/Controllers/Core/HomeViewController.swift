//
//  ViewController.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 17.02.24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Views and VCs
    
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    // MARK: Props and computed props
    
    private var forYouPosts: [PostModel] = PostModel.mockModels()
    private var followingPosts: [PostModel] = PostModel.mockModels()
    
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            return followingPosts
        }
        
        return forYouPosts
    }
    
    // Segmented control
    let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        return control
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.delegate = self
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeaderButtons()
    }
    
    // Called when subviews are laid out
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    // MARK: - Private methods
    
    private func setUpFeed() {
        horizontalScrollView.contentSize = CGSize(
            width: view.width * 2, height: view.height)
        
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    private func setUpFollowingFeed() {
        guard let model = followingPosts.first else {
            return
        }
        
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        
        followingPageViewController.setViewControllers(
            [postVC],
            direction: .forward,
            animated: false,
            completion: nil
        )
        
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setUpForYouFeed() {
        guard let model = forYouPosts.first else {
            return
        }
        
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        
        forYouPageViewController.setViewControllers(
            [postVC],
            direction: .forward,
            animated: false,
            completion: nil
        )
        
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width,
                                                     y: 0,
                                                     width: horizontalScrollView.width,
                                                     height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }
    
    private func setUpHeaderButtons() {
        control.addTarget(self, action: #selector(didChageSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    
    @objc private func didChageSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
    }
}

// MARK: - PageViewController data source

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else { return nil }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.indentifier == fromPost.indentifier
        }) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else { return nil }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.indentifier == fromPost.indentifier
        }) else {
            return nil
        }
        
        if index == currentPosts.count - 1 {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
}

// MARK: - ScrollView delegate

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width / 2) {
            control.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > (view.width / 2) {
            control.selectedSegmentIndex = 1
        }
    }
}

// MARK: - PostViewController delegate

extension HomeViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        
        if horizontalScrollView.contentOffset.x == 0 {
            followingPageViewController.dataSource = nil
        } else {
            forYouPageViewController.dataSource = nil
        }
        
        
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame = CGRect(x: 0,
                           y: view.height,
                           width: view.width,
                           height: view.height * 0.75)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.4) {
            vc.view.frame = CGRect(x: 0,
                                   y: self.view.height - frame.height,
                                   width: frame.width,
                                   height: frame.height)
        }
    }
}

// MARK: - CommentsViewController delegate

extension HomeViewController: CommentsViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        // close comments with animation
        let frame = viewController.view.frame
        
        UIView.animate(withDuration: 0.4) {
            viewController.view.frame = CGRect(x: 0,
                                   y: self.view.height,
                                   width: frame.width,
                                   height: frame.height)
        } completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    // remove comment vc as child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    
                    // allow horizontal and verticle scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.followingPageViewController.dataSource = self
                    self?.forYouPageViewController.dataSource = self
                }
            }
        }
    }
}
