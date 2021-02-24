//
//  ParallaxScrollView.swift
//  ParallaxScrollView
//
//  Created by outofcoding on 2021/02/24.
//

import Foundation

public final class ParallaxScrollView: UIView {
    
    private lazy var scrollView = ScrollView()
    
    public init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var spacing: CGFloat {
        get { scrollView.spacing }
        set { scrollView.spacing = newValue }
    }
    
    public var views: [UIView] {
        get { scrollView.views }
        set { scrollView.views = newValue }
    }
    
    public override var intrinsicContentSize: CGSize {
        return scrollView.intrinsicContentSize
    }
}
