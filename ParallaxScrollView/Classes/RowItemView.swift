//
//  RowItemView.swift
//  ParallaxScrollView
//
//  Created by ipagong on 2021/02/25.
//

import UIKit

final class RowItemView: UIView {
    
    private let items: [UIView]
    
    private var maxHeight: CGFloat = 0
    private var width: CGFloat = 0
    
    private let horizontalSpacing: CGFloat
    
    init(items: [UIView], horizontalSpacing: CGFloat) {
        self.items = items
        self.horizontalSpacing = horizontalSpacing
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        items.forEach { view in
            let top = topAnchor
            let left = subviews.last?.rightAnchor ?? leftAnchor
            
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: top),
                view.leftAnchor.constraint(equalTo: left, constant: horizontalSpacing)
            ])
            
            let size = view.intrinsicContentSize
            
            maxHeight = max(maxHeight, size.height)
            width += (size.width + horizontalSpacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: width + horizontalSpacing + horizontalSpacing, height: maxHeight)
    }
}


