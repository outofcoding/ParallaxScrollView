//
//  ViewController.swift
//  ParallaxScrollView
//
//  Created by outofcoding on 02/24/2021.
//  Copyright (c) 2021 outofcoding. All rights reserved.
//

import UIKit

import ParallaxScrollView

class ViewController: UIViewController {

    let items =
    ["bear", "outofcode", "DH",
    "apple", "pear", "chestnut", "pine nut", "walnut", "acorn", "tangerine", "strawberry",
    "pineapple", "grape", "peach", "apricot", "Japanese apricot", "plum", "prune", "kiwi", "tomato", "blueberry",
    "cherry", "banana", "orange", "watermelon", "melon", "oriental melon",
    "pumpkin", "cucumber", "onion", "garlic", "ginger", "radish", "mugwort", "carrot"]
    
    
    private lazy var itemView = ParallaxItemView(delegate: self)
    
    private lazy var scrollView = ParallaxScrollView()
    private lazy var view1 = TestView(items: ["bear", "outofcode", "DH"])
    private lazy var view2 = TestView(items: ["apple", "pear", "chestnut", "pine nut", "walnut", "acorn", "tangerine", "strawberry"])
    private lazy var view3 = TestView(items: ["pineapple", "grape", "peach", "apricot", "Japanese apricot", "plum", "prune", "kiwi", "tomato", "blueberry"])
    private lazy var view4 = TestView(items: ["cherry", "banana", "orange", "watermelon", "melon", "oriental melon"])
    private lazy var view5 = TestView(items: ["pumpkin", "cucumber", "onion", "garlic", "ginger", "radish", "mugwort", "carrot"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.views = [view1, view2, view3, view4, view5]
        view1.onClick = onClick
        view2.onClick = onClick
        view3.onClick = onClick
        view4.onClick = onClick
        view5.onClick = onClick
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
        ])
        
        view.addSubview(itemView)
        
        NSLayoutConstraint.activate([
            itemView.leftAnchor.constraint(equalTo: view.leftAnchor),
            itemView.rightAnchor.constraint(equalTo: view.rightAnchor),
            itemView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 50),
        ])
    }
    
    @objc func onClick(_ button: StringButton) {
        print("click", button.title(for: .normal) ?? "None")
    }
}

extension ViewController: ParallaxItemViewDelegate {
    func numberOfItems(with parallaxItemView: ParallaxItemView) -> Int { self.items.count }
    
    func parallaxScrollView(_ parallaxItemView: ParallaxItemView, viewForItemAt index: Int) -> UIView {
        let value = items[index]
        
        let button = StringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(value, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        
        return button
    }
}
