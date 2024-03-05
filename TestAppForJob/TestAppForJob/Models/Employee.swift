//
//  Employee.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import Foundation

// MARK: - Employee
struct Employee: Codable {
    let id: String
    let avatarURL: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: String
    let position: String
    let birthday: String
    let phone: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName
        case lastName
        case userTag
        case department
        case position
        case birthday
        case phone
    }
}
