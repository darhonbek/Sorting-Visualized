//
//  SortingViewController.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 9/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let width: CGFloat = 8.0
    static let spacing: CGFloat = 2.0
    static let smallHorizontalPadding: CGFloat = 16.0
    static let horizontalPadding: CGFloat = 24.0
    static let verticalPadding: CGFloat = 24.0
}

private extension String {
    static let reset = "Reset"
    static let sort = "Sort"
}

class SortingViewController: UIViewController {
    var viewModel: SortingViewModelProtocol

    private var bars: [BarView]?

    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(.reset, for: .normal)
        button.addTarget(self, action: #selector(touchUpInside(resetButton:)), for: .touchUpInside)

        button.backgroundColor = .red

        return button
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(.sort, for: .normal)
        button.addTarget(self, action: #selector(touchUpInside(sortButton:)), for: .touchUpInside)

        button.backgroundColor = .red

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.spacing = .spacing

        stackView.backgroundColor = .green

        return stackView
    }()

    // MARK: - Init

    init(viewModel: SortingViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetAndPopulateBars()
    }
}

// MARK: - Layout

extension SortingViewController {
    private func setupLayout() {
        view.backgroundColor = .yellow
        view.addSubview(stackView)
        view.addSubview(resetButton)
        view.addSubview(sortButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: .verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalPadding),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -.horizontalPadding),

            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .smallHorizontalPadding),
            resetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .verticalPadding),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.verticalPadding),
            resetButton.widthAnchor.constraint(equalTo: sortButton.widthAnchor),

            sortButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: .smallHorizontalPadding),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.horizontalPadding),
            sortButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .verticalPadding),
            sortButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.verticalPadding)
        ])
    }

    private func resetAndPopulateBars() {
        stackView.subviews.forEach { $0.removeFromSuperview() }

        var randomNumbers: [CGFloat] = []
        for i in 0 ..< viewModel.array.count {
            randomNumbers.append(CGFloat(viewModel.array[i]))
        }

        randomNumbers.forEach {
            let barView = BarView(width: .width, height: $0)
            barView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(barView)
        }
    }
}

// TODO: - Move to separate sorting animations class/enum.
// MARK: - Sorting Actions

extension SortingViewController {
    @objc func touchUpInside(sortButton: UIButton) {
        viewModel.sort()
        bars = stackView.subviews.compactMap { $0 as? BarView }

        guard let actions = viewModel.actions else { return }

        perform(actions: actions)
    }

    @objc func touchUpInside(resetButton: UIButton) {
        viewModel.reset()
        resetAndPopulateBars()
    }

    private func perform(actions: [SortingAction], index: Int = 0) {
        perform(action: actions[index]) { [weak self] in
            if index + 1 < actions.count {
                self?.perform(actions: actions, index: index + 1)
            }
        }
    }

    private func perform(action: SortingAction, completion: @escaping () -> Void) {
        let animation: () -> Void
        let innerCompletion: () -> Void

        switch action {
        case .swap(let i, let j):
            animation = { [weak self] in
                guard let self = self, var bars = self.bars else { return }

                bars[i].backgroundColor = .green
                bars[j].backgroundColor = .green

                let tempX = bars[i].frame.origin.x
                bars[i].frame.origin.x = bars[j].frame.origin.x
                bars[j].frame.origin.x = tempX

                let tempBar = bars[i]
                bars[i] = bars[j]
                bars[j] = tempBar

                self.bars = bars
            }
            innerCompletion = { [weak self] in
                guard let self = self, let bars = self.bars else { return }

                bars[i].backgroundColor = .blue
                bars[j].backgroundColor = .blue
            }
        case .compare(let i, let j):
            animation = { [weak self] in
                guard let self = self, let bars = self.bars else { return }

                bars[i].backgroundColor = .red
                bars[j].backgroundColor = .red
            }
            innerCompletion = { [weak self] in
                guard let self = self, let bars = self.bars else { return }

                bars[i].backgroundColor = .blue
                bars[j].backgroundColor = .blue
            }
        case .move:
            // TODO: - Update
            animation = {}
            innerCompletion = {}
            break
        }

        UIView.animate(withDuration: 0.01, animations: {
            animation()
        }) { _ in
            innerCompletion()
            completion()
        }
    }
}

