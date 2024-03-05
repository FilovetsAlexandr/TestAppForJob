//
//  EmployeesResponse.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import Foundation

// MARK: - Employees
struct Employees: Codable {
    let items: [Employee]
    
    enum CodingKeys: String, CodingKey {
            case items
        }
}
