//
//  ParallaxItemView.swift
//  ParallaxScrollView
//
//  Created by ipagong on 2021/02/25.
//

import UIKit

public protocol ParallaxItemViewDelegate: class {
    func parallaxScrollView(_ parallaxItemView: ParallaxItemView, cellForItemAt index: Int) -> UIView
    
    func numberOfItems(with parallaxItemView: ParallaxItemView) -> Int
}

public final class ParallaxItemView: UIView {
    public init(delegate: ParallaxItemViewDelegate?) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }

    private lazy var scrollView = ScrollView()
    
    public weak var delegate: ParallaxItemViewDelegate?
    
    public var maxRowCount: Int = 3
    
    public var preferColumnCount: Int = 8
    
    public var itemInset: UIEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
    
    public var spacing: CGFloat {
        get { scrollView.spacing }
        set { scrollView.spacing = newValue }
    }
    
    public var contentInset: UIEdgeInsets {
        get { scrollView.contentInset }
        set { scrollView.contentInset = newValue }
    }
    
    private var rowWidths = [CGFloat]()
    private var rowViews = [[UIView]]()
    
    public override var intrinsicContentSize: CGSize { return scrollView.intrinsicContentSize }
}

extension ParallaxItemView {
    public func reloadData() {
        self.clear()
        
        guard let count = self.delegate?.numberOfItems(with: self) else { return }
        
        let rowCount = min(Int(count / preferColumnCount) + 1, maxRowCount)
        
        self.rowWidths.append(contentsOf: Array(repeating: 0.0, count: rowCount))
        self.rowViews.append(contentsOf: Array(repeating: [UIView](), count: rowCount))
        
        (0..<count).forEach { index in
            guard let view = self.delegate?.parallaxScrollView(self, cellForItemAt: index) else { return }
            
            let rowIndex = pickRow(itemIndex: index)
            
            let newWidths = rowWidths[rowIndex] + itemInset.left + view.intrinsicContentSize.width + itemInset.right
            
            rowWidths[rowIndex] = newWidths
            rowViews[rowIndex].append(view)
        }
        
        self.scrollView.views = self.rowViews.compactMap{ RowItemView(itemInset: self.itemInset, items: $0) }
        
        self.rowViews.removeAll()
        self.rowWidths.removeAll()
    }
    
    public func clear() {
        self.rowViews.removeAll()
        self.rowWidths.removeAll()
        
        self.scrollView.clear()
    }
}

extension ParallaxItemView {
    private func loadView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        self.reloadData()
    }
    
    private func pickRow(itemIndex: Int) -> Int {
        rowWidths.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
    }
}
