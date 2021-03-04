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
    
    private let spacing: ParallaxItemView.Spacing
    
    init(items: [UIView], spacing: ParallaxItemView.Spacing) {
        self.items = items
        self.spacing = spacing
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        items.enumerated().forEach { (index, view) in
            let top = topAnchor
            let left = subviews.last?.rightAnchor ?? leftAnchor
            
            let size = view.intrinsicContentSize
            
            let spacing = (index > 0 ? self.spacing.horizontal : 0)
            let leftMargin = (index == 0 ? self.spacing.leftMargin : 0.0)
            let rightMargin = (index + 1 == items.count ? self.spacing.rightMargin : 0.0)
            
            view.frame = .init(x: _width + leftMargin + spacing,
                               y: 0,
                               width: size.width,
                               height: size.height)
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: top),
                view.leftAnchor.constraint(equalTo: left, constant: leftMargin + spacing),
            ])
            
            maxHeight = max(maxHeight, size.height)
            _width += (size.width + leftMargin + spacing + rightMargin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: _width, height: maxHeight)
    }
}
