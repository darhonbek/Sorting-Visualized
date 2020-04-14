//
//  BubbleSortVisualizer.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 14/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

class BubbleSortVisualizer: SortingVisualizingProtocol {
    // TODO: - Check if this can be improved
    private static var actions: [SortingAction] = []

    static func getSortingActions<T: Comparable>(_ array: [T]) -> [SortingAction] {
        actions = []
        sort(array)
        return actions
    }

    @discardableResult
    static func sort<T: Comparable>(_ array: [T]) -> [T] {
        var array = array

        for i in 0 ..< array.count {
            for j in i ..< array.count {
                actions.append(.compare(i, j))
                if array[i] > array[j] {
                    actions.append(.swap(i, j))
                    swap(&array, i, j)
                }
            }
        }

        return array
    }

    private static func swap<T>(_ array: inout [T], _ i: Int, _ j: Int) {
        let temp = array[i]
        array[i] = array[j]
        array[j] = temp
    }
}
