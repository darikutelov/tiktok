//
//  ViewController.swift
//  TikTokUIKit
//
//  Created by Dariy Kutelov on 17.02.24.
//

import UIKit

class HomeViewController: UIViewController {

    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = .red
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
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(horizontalScrollView)
        setUpFeed()
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
        // Set Paging Controllers
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        followingPageViewController.setViewControllers(
            [vc],
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
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        forYouPageViewController.setViewControllers(
            [vc],
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
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = [UIColor.red, UIColor.gray, UIColor.green].randomElement()
        return vc
    }
    
    
}

