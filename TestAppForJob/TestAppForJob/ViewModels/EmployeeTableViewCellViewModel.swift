//
//  EmployeeTableViewCellViewModel.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 12.03.24.
//

import Foundation

final class EmployeeTableViewCellViewModel {
    let fullName: String
    let position: String
    let userTag: String
    let avatarURL: URL?
    let birthday: String?

    init(employee: Employee) {
        self.fullName = employee.firstName + " " + employee.lastName
        self.position = employee.position
        self.userTag = employee.userTag
        self.avatarURL = URL(string: employee.avatarURL)
        self.birthday = employee.birthday
    }
}
