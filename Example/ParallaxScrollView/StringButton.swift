//
//  StringButton.swift
//  ParallaxScrollView_Example
//
//  Created by Donghyuk on 2021/02/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class StringButton: UIButton {
    
    var onClick: ((StringButton) -> Void)?
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = intrinsicContentSize.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 20, height: size.height)
    }
    
    @objc func onClick(_ any: Any) {
        onClick?(self)
    }
}
