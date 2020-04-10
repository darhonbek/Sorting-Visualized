//
//  BarView.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 9/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let width: CGFloat = 16.0
}

class BarView: UIView {
    let value: CGFloat

    // MARK: - Init

    init(value: CGFloat) {
        self.value = value

        super.init(frame: .zero)

        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: .width, height: value)
    }
}
