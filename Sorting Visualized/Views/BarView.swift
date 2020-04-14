//
//  BarView.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 9/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

class BarView: UIView {
    private let height: CGFloat
    private let width: CGFloat

    // MARK: - Init

    init(width: CGFloat, height: CGFloat) {
        self.height = height
        self.width = width

        super.init(frame: .zero)

        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}
