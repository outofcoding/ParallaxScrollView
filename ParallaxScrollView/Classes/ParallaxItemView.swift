//
//  ParallaxItemView.swift
//  ParallaxScrollView
//
//  Created by ipagong on 2021/02/25.
//

import UIKit

public protocol ParallaxItemViewDelegate: class {
    func numberOfItems(with parallaxItemView: ParallaxItemView) -> Int
    
    func parallaxScrollView(_ parallaxItemView: ParallaxItemView, viewForItemAt index: Int) -> UIView
    
    func parallaxScrollView(_ parallaxItemView: ParallaxItemView, didSelectAt index: Int)
    
    func parallaxScrollView(_ parallaxItemView: ParallaxItemView, reloadView view: UIView?, index: Int)
    
    func layoutOptions(with parallaxItemView: ParallaxItemView) -> ParallaxItemView.LayoutOptions
}

extension ParallaxItemViewDelegate { // for optioanl.
    public func parallaxScrollView(_ parallaxItemView: ParallaxItemView, didSelectAt index: Int) { }
    public func parallaxScrollView(_ parallaxItemView: ParallaxItemView, reloadView view: UIView?, index: Int) { }
    public func layoutOptions(with parallaxItemView: ParallaxItemView) -> ParallaxItemView.LayoutOptions { .init() }
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
            scrollView.spacing = layoutOptions.spacing.vertical
            scrollView.contentInset = layoutOptions.contentInset
        }
    }
    
    private var rowWidths = [CGFloat]()
    private var rowViews = [[UIView]]()

    private var views = [UIView?]()
    private var gestures = [ParallexTapGestureRecognizer]()
    
    public override var intrinsicContentSize: CGSize { return scrollView.intrinsicContentSize }
    
    @objc func didSelectItems(with tapGesture: ParallexTapGestureRecognizer) {
        delegate?.parallaxScrollView(self, didSelectAt: tapGesture.index)
    }
}

extension ParallaxItemView {
    public func reloadData() {
        guard let delegate = self.delegate else { return }

        clear()
        
        let count = delegate.numberOfItems(with: self)
        
        guard count > 0 else { return }
        
        layoutOptions = delegate.layoutOptions(with: self)
        
        let rowCount = layoutOptions.rowCount(with: count)
        
        rowWidths.append(contentsOf: Array(repeating: 0.0, count: rowCount))
        rowViews.append(contentsOf: Array(repeating: [UIView](), count: rowCount))
        
        gestures.append(contentsOf: Array(0..<count).map{ ParallexTapGestureRecognizer(target: self, action: #selector(didSelectItems(with:)), index: $0) })
        
        (0..<count).forEach { [weak self] index in
            guard let self = self else { return }
            guard let delegate = self.delegate else { return }
            
            let view = delegate.parallaxScrollView(self, viewForItemAt: index)
                
            views.append(view)
            
            view.addGestureRecognizer(self.gestures[index])
            
            let rowIndex = pickRow(itemIndex: index)
            
            let newWidths = rowWidths[rowIndex] + layoutOptions.spacing.horizontal + view.intrinsicContentSize.width
            
            rowWidths[rowIndex] = newWidths
            rowViews[rowIndex].append(view)
        }
        
        scrollView.views = rowViews.compactMap{ RowItemView(items: $0, spacing: layoutOptions.spacing) }
    }
    
    public func getItems(with index: Int) -> UIView? {
        guard index < views.count else { return nil }
        return views[index]
    }
    
    public func reloadItemViews() {
        views.enumerated().forEach{ (index, view) in
            self.delegate?.parallaxScrollView(self, reloadView: view, index: index)
        }
    }
}

extension ParallaxItemView {
    
    private func clear() {
        rowViews.removeAll()
        rowWidths.removeAll()
        gestures.removeAll()
        views.removeAll()
        scrollView.clear()
    }
    
    private func loadView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        reloadData()
    }
    
    private func pickRow(itemIndex: Int) -> Int {
        rowWidths.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
    }
}

extension ParallaxItemView {
    public struct LayoutOptions {
        public let spacing: Spacing
        public let contentInset: UIEdgeInsets
        public let maxRowCount: Int
        public let preferColumnCount: Int
        
        func rowCount(with itemCount: Int) -> Int {
            let overCount = (itemCount % preferColumnCount == 0 ? 0 : 1)
            
            return min(Int(itemCount / preferColumnCount) + overCount, maxRowCount)
        }
        
        public init(spacing: Spacing = Spacing(),
                    contentInset: UIEdgeInsets = .zero,
                    maxRowCount: Int = 3,
                    preferColumnCount: Int = 8) {
            self.spacing = spacing
            self.contentInset = contentInset
            self.maxRowCount = maxRowCount
            self.preferColumnCount = preferColumnCount
        }
    }
    
    public struct Spacing {
        let vertical: CGFloat
        let horizontal: CGFloat
        let leftMargin: CGFloat
        let rightMargin: CGFloat
        
        public init(
            vertical: CGFloat = 5,
            horizontal: CGFloat = 5,
            leftMargin: CGFloat = 16,
            rightMargin: CGFloat = 16
        ) {
            self.vertical = vertical
            self.horizontal = horizontal
            self.leftMargin = leftMargin
            self.rightMargin = rightMargin
        }
    }
}
