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
    private var _width: CGFloat = 0
    
    private let horizontalSpacing: CGFloat
    
    init(items: [UIView], horizontalSpacing: CGFloat) {
        self.items = items
        self.horizontalSpacing = horizontalSpacing
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        items.enumerated().forEach { (index, view) in
            let top = topAnchor
            let left = subviews.last?.rightAnchor ?? leftAnchor
            
            let size = view.intrinsicContentSize
            
            let spacing = (index > 0 ? horizontalSpacing : 0)
            
            view.frame = .init(x: _width + spacing,
                               y: 0,
                               width: size.width,
                               height: size.height)
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: top),
                view.leftAnchor.constraint(equalTo: left, constant: spacing),
            ])
            
            maxHeight = max(maxHeight, size.height)
            _width += (size.width + horizontalSpacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: _width + horizontalSpacing + horizontalSpacing, height: maxHeight)
    }
}

