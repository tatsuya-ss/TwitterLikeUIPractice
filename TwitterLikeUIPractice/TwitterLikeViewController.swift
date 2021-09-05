//
//  TwitterLikeViewController.swift
//  TwitterLikeUIPractice
//
//  Created by 坂本龍哉 on 2021/09/04.
//

import UIKit

enum PageState: CaseIterable {
    case all
    case following
    case news
    
    var page: Int {
        switch self {
        case .all: return 0
        case .following: return 1
        case .news: return 2
        }
    }
    
    func isDifferentPage(pageState: PageState) -> Bool {
        switch pageState {
        case .all: return self != .all
        case .following: return self != .following
        case .news: return self != .news
        }
    }
    
    mutating func changeState(pageState: PageState) {
        self = pageState
    }
    
    mutating func checkNowPage(widthPerPage: CGFloat,
                               selectedConstraint: CGFloat) {
        let page = Int(selectedConstraint / widthPerPage)
        for postsPage in PageState.allCases
        where postsPage.page == page {
            self = postsPage
            return
        }
        self = .all
    }
    
}

final class TwitterLikeViewController: UIViewController {
    
    @IBOutlet private weak var selectedMarkView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var barLeftConstraint: NSLayoutConstraint!
    
    private var nowPostsPage: PageState = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }
    
    private func setupContainerView() {
        guard let homeContainerPostsVC = children.first
                as? ScrollViewController else { return }
        homeContainerPostsVC.delegate = self
    }
    
    @IBAction private func allPostButtonDidTapped(_ sender: Any) {
        guard let homeContainerPostsVC = children.first
                as? ScrollViewController else { return }
        if nowPostsPage.isDifferentPage(pageState: .all) {
            homeContainerPostsVC.scrollToPage(state: .all,
                                              animated: true)
        }
        nowPostsPage.changeState(pageState: .all)
    }
    
    @IBAction private func followingButtonDidTapped(_ sender: Any) {
        guard let homeContainerPostsVC = children.first
                as? ScrollViewController else { return }
        if nowPostsPage.isDifferentPage(pageState: .following) {
            homeContainerPostsVC.scrollToPage(state: .following,
                                              animated: true)
        }
        nowPostsPage.changeState(pageState: .following)
    }
    
    @IBAction private func newsButtonDidTapped(_ sender: Any) {
        guard let homeContainerPostsVC = children.first
                as? ScrollViewController else { return }
        if nowPostsPage.isDifferentPage(pageState: .news) {
            homeContainerPostsVC.scrollToPage(state: .news,
                                              animated: true)
        }
        nowPostsPage.changeState(pageState: .news)
    }
}

extension TwitterLikeViewController: TwitterLikeVCDelegate {
    
    func moveSelectedMarkView(contentOffset: CGFloat) {
        barLeftConstraint.constant = contentOffset
    }
    
    func checkNowPage(widthPerPage: CGFloat) {
        nowPostsPage.checkNowPage(widthPerPage: widthPerPage,
                                  selectedConstraint: barLeftConstraint.constant)
    }
}
