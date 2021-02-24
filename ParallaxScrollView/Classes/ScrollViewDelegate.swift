//
//  ScrollViewDelegate.swift
//  ParallaxScrollView
//
//  Created by outofcoding on 2021/02/24.
//

import Foundation

final class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
    var didChangeOffset: ((CGFloat) -> Void)?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        didChangeOffset?(offset)
    }
}
