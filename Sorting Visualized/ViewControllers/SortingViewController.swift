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
    static let horizontalPadding: CGFloat = 24.0
    static let verticalPadding: CGFloat = 24.0
}

private extension String {
    static let sort = "Sort"
}

class SortingViewController: UIViewController {
    var viewModel: SortingViewModelProtocol

    private var bars: [BarView]?

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
        populateBars()
    }
}

// MARK: - Layout

extension SortingViewController {
    private func setupLayout() {
        view.backgroundColor = .yellow
        view.addSubview(sortButton)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: .verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalPadding),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -.horizontalPadding),

            sortButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .verticalPadding),
            sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalPadding),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.horizontalPadding),
            sortButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.verticalPadding)
        ])
    }

    private func populateBars() {
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

// MARK: - Sorting Actions

extension SortingViewController {
    @objc func touchUpInside(sortButton: UIButton) {
        viewModel.sort()
        bars = stackView.subviews.compactMap { $0 as? BarView }

        guard let actions = viewModel.actions else { return }

        perform(actions: actions)
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

                let tempX = bars[i].frame.origin.x
                bars[i].frame.origin.x = bars[j].frame.origin.x
                bars[j].frame.origin.x = tempX

                let tempBar = bars[i]
                bars[i] = bars[j]
                bars[j] = tempBar

                self.bars = bars
            }
            innerCompletion = {}
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

        UIView.animate(withDuration: 0.2, animations: {
            animation()
        }) { _ in
            innerCompletion()
            completion()
        }
    }
}

