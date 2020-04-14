//
//  SortingVisualizing.swift
//  Sorting Visualized
//
//  Created by Darkhonbek Mamataliev on 14/4/20.
//  Copyright © 2020 Darkhonbek Mamataliev. All rights reserved.
//

protocol SortingVisualizingProtocol {
    static func getSortingActions<T: Comparable>(_ array: [T]) -> [SortingAction]

    // TODO: - Do I need this?
    @discardableResult
    static func sort<T: Comparable>(_ array: [T]) -> [T]
}
