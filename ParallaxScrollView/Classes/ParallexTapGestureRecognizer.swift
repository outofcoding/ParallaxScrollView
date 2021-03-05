//
//  ParallexTapGestureRecognizer.swift
//  ParallaxScrollView
//
//  Created by ipagong on 2021/02/26.
//

import UIKit

class ParallexTapGestureRecognizer: UITapGestureRecognizer {
    let index: Int
    
    init(target: Any?, action: Selector?, index: Int) {
        self.index = index
        
        super.init(target: target, action: action)
        
        cancelsTouchesInView = false
    }
}
