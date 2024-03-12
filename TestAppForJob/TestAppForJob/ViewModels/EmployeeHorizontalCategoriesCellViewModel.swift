//
//  EmployeeHorizontalCategoriesCellViewModel.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 12.03.24.
//

import Foundation

final class EmployeeHorizontalCategoriesCellViewModel {
    let category: String
    var isSelected: Bool

    init(category: String, isSelected: Bool) {
        self.category = category
        self.isSelected = isSelected
    }
}
