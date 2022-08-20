//
//  ShaveView.swift
//  MotionCude
//
//  Created by Artem Serebriakov on 19.08.2022.
//

import UIKit

final class ShapeView : UIView {
    var cornerRadius = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random
        cornerRadius = Bool.random()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if cornerRadius {
            layer.cornerRadius = 0.5 * layer.bounds.width
        }
    }
}
