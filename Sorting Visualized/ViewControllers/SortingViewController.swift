//
//  SortingViewController.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 9/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let spacing: CGFloat = 8.0
    static let horizontalPadding: CGFloat = 24.0
    static let verticalPadding: CGFloat = 24.0
}

private extension String {
    static let animate = "Animate"
}

class SortingViewController: UIViewController {
    private lazy var animateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(.animate, for: .normal)
        button.addTarget(self, action: #selector(touchUpInside(animateButton:)), for: .touchUpInside)

        button.backgroundColor = .red

        return button
    }()

    private lazy var barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = .spacing

        stackView.backgroundColor = .green

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        populateBars()
    }

    private func setupLayout() {
        view.backgroundColor = .yellow
        view.addSubview(animateButton)
        view.addSubview(barStackView)

        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: .verticalPadding),
            barStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalPadding),
            barStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -.horizontalPadding),

            animateButton.topAnchor.constraint(equalTo: barStackView.bottomAnchor, constant: .verticalPadding),
            animateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalPadding),
            animateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.horizontalPadding),
            animateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.verticalPadding)
        ])
    }

    private func populateBars() {
        [CGFloat(128), 512, 256, 64].forEach {
            let barView = BarView(value: $0)
            barView.translatesAutoresizingMaskIntoConstraints = false
            barStackView.addArrangedSubview(barView)
        }
    }

    @objc func touchUpInside(animateButton: UIButton) {
        let semaphore = DispatchSemaphore(value: 0)
        let subviews = barStackView.arrangedSubviews
        let firstView = subviews[0]

        for index in 1 ..< subviews.count {
            let secondView = subviews[subviews.count - 1 - index]

            UIView.animate(withDuration: 0.5, animations: {
                semaphore.signal()

                let xOriginFirst = firstView.frame.origin.x
                firstView.frame.origin.x = secondView.frame.origin.x
                secondView.frame.origin.x = xOriginFirst
            }) { _ in
            }

            semaphore.wait(timeout: .now() + .seconds(2))
        }
    }
}

