//
//  MergeSortVisualizer.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 11/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

// TODO: - Come up with visualization. Think about `move` action (or refactor to use in-place sorting).

class MergeSortVisualizer: SortingVisualizingProtocol {
    private static var actions: [SortingAction] = []

    static func getSortingActions<T: Comparable>(_ array: [T]) -> [SortingAction] {
        actions = []
        sort(array)
        return actions
    }

    @discardableResult
    static func sort<T: Comparable>(_ array: [T]) -> [T] {
        let n = array.count

        guard n > 1 else { return array }

        let midIndex = array.index(array.startIndex, offsetBy: n/2)
        var leftArray = Array(array[0 ..< midIndex])
        var rightArray = Array(array[midIndex ..< n])

        leftArray = sort(leftArray)
        rightArray = sort(rightArray)

        return merge(leftArray, rightArray)
    }

    private static func merge<T: Comparable>(_ lhs: [T], _ rhs: [T]) -> [T] {
        var array: [T] = []
        var index = 0
        var lIndex = 0
        var rIndex = 0

        while lIndex < lhs.count && rIndex < rhs.count {
            actions.append(.compare(lIndex, rIndex))

            if lhs[lIndex] < rhs[rIndex] {
                actions.append(.move(lIndex, index))
                array.append(lhs[lIndex])
                lIndex += 1
            } else {
                actions.append(.move(rIndex, index))
                array.append(rhs[rIndex])
                rIndex += 1
            }

            index += 1
        }

        while lIndex < lhs.count {
            actions.append(.move(lIndex, index))
            array.append(lhs[lIndex])
            lIndex += 1
            index += 1
        }

        while rIndex < rhs.count {
            actions.append(.move(rIndex, index))
            array.append(rhs[rIndex])
            rIndex += 1
            index += 1
        }

        return array
    }
}
