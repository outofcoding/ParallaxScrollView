//
//  TestView.swift
//  ParallaxScrollView_Example
//
//  Created by Donghyuk on 2021/02/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

final class TestView: UIView {
    
    var onClick: ((StringButton) -> Void)?
    
    private let items: [String]
    private var maxHeight: CGFloat = 0
    private var width: CGFloat = 0
    
    private let leftMargin: CGFloat = 5
    private let rightMargin: CGFloat = 5
    
    init(items: [String]) {
        self.items = items
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        items.forEach { text in
            let margin: CGFloat
            let anchor: NSLayoutXAxisAnchor
            if let last = subviews.last {
                margin = 10
                anchor = last.rightAnchor
            } else {
                margin = leftMargin
                anchor = leftAnchor
            }
            
            let button = StringButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(text, for: .normal)
            button.backgroundColor = .gray
            button.onClick = { [weak self] button in
                self?.onClick?(button)
            }
            addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: topAnchor),
                button.leftAnchor.constraint(equalTo: anchor, constant: margin)
            ])
            
            let size = button.intrinsicContentSize
            maxHeight = max(maxHeight, size.height)
            width += (size.width + margin)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width + leftMargin + rightMargin, height: maxHeight)
    }
}
