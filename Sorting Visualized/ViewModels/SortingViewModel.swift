//
//  SortingViewModel.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 14/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation

protocol SortingViewModelProtocol {
//    associatedtype T
    var sortingAlgorithm: SortingAlgorithm { get set }

    var array: [Int] { get set }

    var actions: [SortingAction]? { get set }

    func sort()
}

extension SortingViewModelProtocol {
    var sortingVisualizer: SortingVisualizingProtocol.Type {
        switch sortingAlgorithm {
        case .bubbleSort: return BubbleSortVisualizer.self
        case .mergeSort: return MergeSortVisualizer.self
        }
    }
}

class SortingViewModel: SortingViewModelProtocol {
    var sortingAlgorithm: SortingAlgorithm
    var array: [Int] = []
    var actions: [SortingAction]?

    init(sortingAlgorithm: SortingAlgorithm = .bubbleSort) {
        self.sortingAlgorithm = sortingAlgorithm
        array = generateRandomArray()
    }

    func sort() {
       actions = sortingVisualizer.getSortingActions(array)
    }

    private func generateRandomArray() -> [Int] {
        var array: [Int] = []
        for _ in 0 ..< 10 {
            array.append(Int.random(in: 10...300))
        }
        return array
    }
}
