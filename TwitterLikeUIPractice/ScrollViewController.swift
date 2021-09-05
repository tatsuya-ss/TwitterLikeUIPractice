//
//  ScrollViewController.swift
//  TwitterLikeUIPractice
//
//  Created by 坂本龍哉 on 2021/09/04.
//

import UIKit

protocol TwitterLikeVCDelegate: AnyObject {
    func moveSelectedMarkView(contentOffset: CGFloat)
    func checkNowPage(widthPerPage: CGFloat)
}

final class ScrollViewController: UIViewController {

    @IBOutlet private weak var horizontalScrollView: UIScrollView!
    @IBOutlet private weak var tableView1: UITableView!
    @IBOutlet private weak var tableView2: UITableView!
    @IBOutlet private weak var tableView3: UITableView!
    
    weak var delegate: TwitterLikeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    private func setupScrollView() {
        horizontalScrollView.delegate = self
    }
    
    func scrollToPage(state: PageState, animated: Bool) {
        let horizontalScrollViewWidth = horizontalScrollView.frame.width
        let horizontalScrollViewHeight = horizontalScrollView.frame.height
        let frame = CGRect(x: horizontalScrollViewWidth * CGFloat(state.page),
                           y: 0,
                           width: horizontalScrollViewWidth,
                           height: horizontalScrollViewHeight)
        horizontalScrollView.scrollRectToVisible(frame,
                                                 animated: animated)
    }
    
}

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.horizontalScrollView) {
            let pageCount = PageState.allCases.count
            let scrollPoint = scrollView.contentOffset.x / CGFloat(pageCount)
            delegate?.moveSelectedMarkView(contentOffset: scrollPoint)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            let pageCounts = PageState.allCases.count
            let widthPerPage = scrollView.bounds.width / CGFloat(pageCounts)
            delegate?.checkNowPage(widthPerPage: widthPerPage)
        }
    }
}
