//
//  SortingVisualizer.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 11/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

import Foundation

protocol SorterProtocol {
    func mergeSort<T: Comparable>(_ array: [T]) -> [T]
}

class SortingVisualizer: SorterProtocol {
    func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
        let n = array.count

        guard n > 1 else { return array }

        let midIndex = array.index(array.startIndex, offsetBy: n/2)
        var leftArray = Array(array[0 ..< midIndex])
        var rightArray = Array(array[midIndex ..< n])

        leftArray = mergeSort(leftArray)
        rightArray = mergeSort(rightArray)

        return merge(leftArray, rightArray)
    }

    private func merge<T: Comparable>(_ lhs: [T], _ rhs: [T]) -> [T] {
        var lIndex = 0
        var rIndex = 0
        var array: [T] = []

        while lIndex < lhs.count && rIndex < rhs.count {
            if lhs[lIndex] < rhs[rIndex] {
                array.append(lhs[lIndex])
                lIndex += 1
            } else {
                array.append(rhs[rIndex])
                rIndex += 1
            }
        }

        while lIndex < lhs.count {
            array.append(lhs[lIndex])
            lIndex += 1
        }

        while rIndex < rhs.count {
            array.append(rhs[rIndex])
            rIndex += 1
        }

        return array
    }
}
