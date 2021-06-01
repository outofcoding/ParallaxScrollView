//
//  ScrollView.swift
//  ParallaxScrollView
//
//  Created by outofcoding on 2021/02/24.
//

import Foundation

final class ScrollView: UIScrollView {
    var spacing: CGFloat = 5
    var views: [UIView] = [] {
        didSet { createView(views) }
    }
    
    private lazy var leftAnchors: [NSLayoutConstraint] = []
    private lazy var maxWidth: CGFloat = 0.0
    private lazy var scrollDelegate = ScrollViewDelegate()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.99)
        delegate = scrollDelegate
        
        scrollDelegate.didChangeOffset = { [weak self] offset in
            self?.scrollTo(offset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentSize = CGSize(width: maxWidth, height: 10)
    }
    
    override var intrinsicContentSize: CGSize {
        let superViewSize = superview?.frame.size ?? .zero
        let spacingSum = CGFloat(subviews.count - 1) * spacing
        let height = subviews.reduce(spacingSum) { before, now -> CGFloat in
            before + now.intrinsicContentSize.height
        }
        
        return CGSize(width: superViewSize.width, height: height)
    }
    
    func clear() {
        self.views.removeAll()
        self.subviews.forEach{ $0.removeFromSuperview() }
    }
}

private extension ScrollView {
    func createView(_ views: [UIView]) {
        subviews.forEach { $0.removeFromSuperview() }
        leftAnchors = []
        
        views.forEach { view in
            let anchor: NSLayoutYAxisAnchor
            let spacing: CGFloat
            if let last = subviews.last {
                anchor = last.bottomAnchor
                spacing = self.spacing
            } else {
                anchor = topAnchor
                spacing = 0
            }
            
            addSubview(view)
            view.topAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
            
            if let superview = superview {
                let leftAnchor = view.leftAnchor.constraint(equalTo: superview.leftAnchor)
                leftAnchor.isActive = true
                leftAnchors.append(leftAnchor)
            } else {
                #if DEBUG
                fatalError("Please add this view after set views")
                #endif
            }
            
            maxWidth = max(maxWidth, viewSize(with: view))
        }
    }
    
    func scrollTo(_ offset: CGFloat) {
        let scrollWidth = frame.size.width
        let maxScroll = maxWidth - scrollWidth
        
        let anchorCount = leftAnchors.count
        if anchorCount == 0 { return }
        
        for (index, view) in subviews.enumerated() {
            guard (0..<anchorCount).contains(index) else { break }
            
            let viewWidth = viewSize(with: view)
            
            let anchor = leftAnchors[index]
            
            if viewWidth == maxWidth {
                anchor.constant = -offset
            } else {
                let scroll = scrollWidth - viewWidth
                if scroll < 0 {
                    let ratio = scroll / maxScroll
                    let constant = offset * ratio
                    anchor.constant = constant
                }
            }
        }
    }
    
    func viewSize(with view: UIView) -> CGFloat {
        let viewWidth = view.intrinsicContentSize.width
        if viewWidth > -1 {
            return viewWidth
        } else {
            return view.frame.size.width
        }
    }
}
