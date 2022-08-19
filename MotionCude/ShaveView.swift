//
//  ShaveView.swift
//  MotionCude
//
//  Created by Artem Serebriakov on 19.08.2022.
//

import UIKit

final class ShapeView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random
        layer.cornerRadius = Bool.random() ? 50 : 0
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
