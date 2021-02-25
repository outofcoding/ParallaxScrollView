//
//  ParallaxItemView.swift
//  ParallaxScrollView
//
//  Created by ipagong on 2021/02/25.
//

import UIKit

public protocol ParallaxItemViewDelegate: class {
    func layoutOptions(with parallaxItemView: ParallaxItemView) -> ParallaxItemView.LayoutOptions?
    
    func parallaxScrollView(_ parallaxItemView: ParallaxItemView, cellForItemAt index: Int) -> UIView
    
    func numberOfItems(with parallaxItemView: ParallaxItemView) -> Int
}

extension ParallaxItemViewDelegate {
    public func layoutOptions(with parallaxItemView: ParallaxItemView) -> ParallaxItemView.LayoutOptions? { nil }
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
    
    public var layoutOptions: LayoutOptions = LayoutOptions() {
        didSet {
            scrollView.spacing = self.layoutOptions.spacing.vertical
            scrollView.contentInset = self.layoutOptions.contentInset
        }
    }
    
    private var rowWidths = [CGFloat]()
    private var rowViews = [[UIView]]()
    
    public override var intrinsicContentSize: CGSize { return scrollView.intrinsicContentSize }
}

extension ParallaxItemView {
    public func reloadData() {
        self.scrollView.clear()
        guard let count = delegate?.numberOfItems(with: self) else { return }
        
        layoutOptions = delegate?.layoutOptions(with: self) ?? LayoutOptions(spacing: Spacing())
        
        let rowCount = min(Int(count / layoutOptions.preferColumnCount) + 1, layoutOptions.maxRowCount)
        
        self.rowWidths.append(contentsOf: Array(repeating: 0.0, count: rowCount))
        self.rowViews.append(contentsOf: Array(repeating: [UIView](), count: rowCount))
        
        (0..<count).forEach { index in
            guard let view = self.delegate?.parallaxScrollView(self, cellForItemAt: index) else { return }
            
            let rowIndex = pickRow(itemIndex: index)
            
            let newWidths = rowWidths[rowIndex] + layoutOptions.spacing.horizontal + view.intrinsicContentSize.width
            
            rowWidths[rowIndex] = newWidths
            rowViews[rowIndex].append(view)
        }
        
        self.scrollView.views = self.rowViews.compactMap{ RowItemView(items: $0, horizontalSpacing: layoutOptions.spacing.horizontal) }
        
        self.rowViews.removeAll()
        self.rowWidths.removeAll()
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

extension ParallaxItemView {
    public struct LayoutOptions {
        public var spacing: Spacing = Spacing()
        public var contentInset: UIEdgeInsets = .zero
        public var maxRowCount: Int = 3
        public var preferColumnCount: Int = 8
    }
    
    public struct Spacing {
        var vertical: CGFloat = 5
        var horizontal: CGFloat = 5
    }
}
