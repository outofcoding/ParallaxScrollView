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
    
    private let itemInset: UIEdgeInsets
    
    init(itemInset: UIEdgeInsets, items: [UIView]) {
        self.items = items
        self.itemInset = itemInset
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        items.forEach { view in
            let margin: CGFloat
            let anchor: NSLayoutXAxisAnchor
            if let last = subviews.last {
                margin = 10
                anchor = last.rightAnchor
            } else {
                margin = itemInset.left
                anchor = leftAnchor
            }
            
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor, constant: itemInset.top),
                view.leftAnchor.constraint(equalTo: anchor, constant: itemInset.left)
            ])
            
            let size = view.intrinsicContentSize
            maxHeight = max(maxHeight, size.height)
            width += (size.width + margin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width + itemInset.right,
                      height: itemInset.top + maxHeight + itemInset.bottom)
    }
}


