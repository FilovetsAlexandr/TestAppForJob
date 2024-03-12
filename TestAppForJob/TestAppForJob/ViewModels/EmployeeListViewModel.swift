//
//  EmployeeListViewModel.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import UIKit

final class EmployeeListViewModel {
    private var employees: [Employee] = []
    var filteredEmployees: [Employee] = []
    private var categoryFilteredEmployees: [Employee] = []
    var onEmployeesUpdated: (() -> Void)?
    var onErrorMessage: ((Error) -> Void)?
    let categories = ["Все", "Android", "iOS", "Дизайн", "Менеджмент", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка", "Аналитика"]
    private var inSearchMode: Bool = false
    private var selectedCategoryIndex: Int = 0
    
    func fetchEmployees() {
        APIManager.shared.getEmployees { [weak self] result in
            switch result {
            case .success(let response):
                self?.employees = response.items
                self?.filteredEmployees = response.items
                self?.onEmployeesUpdated?()
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    func handleCategorySelection(at index: Int) {
        switch index {
        case 0:
            categoryFilteredEmployees = employees
        case 1:
            categoryFilteredEmployees = employees.filter { $0.department == "android" }
        case 2:
            categoryFilteredEmployees = employees.filter { $0.department == "ios" }
        case 3:
            categoryFilteredEmployees = employees.filter { $0.department == "design" }
        case 4:
            categoryFilteredEmployees = employees.filter { $0.department == "management" }
        case 5:
            categoryFilteredEmployees = employees.filter { $0.department == "qa" }
        case 6:
            categoryFilteredEmployees = employees.filter { $0.department == "back_office" }
        case 7:
            categoryFilteredEmployees = employees.filter { $0.department == "frontend" }
        case 8:
            categoryFilteredEmployees = employees.filter { $0.department == "hr" }
        case 9:
            categoryFilteredEmployees = employees.filter { $0.department == "pr" }
        case 10:
            categoryFilteredEmployees = employees.filter { $0.department == "backend" }
        case 11:
            categoryFilteredEmployees = employees.filter { $0.department == "support" }
        case 12:
            categoryFilteredEmployees = employees.filter { $0.department == "analytics" }
        default:
            categoryFilteredEmployees = employees
        }
        filteredEmployees = categoryFilteredEmployees
        onEmployeesUpdated?()
    }
    
    func updateSearchResults(searchText: String?) {
          guard let searchText = searchText?.lowercased(), !searchText.isEmpty else {
              filteredEmployees = categoryFilteredEmployees
              onEmployeesUpdated?()
              return
          }
          
          filteredEmployees = categoryFilteredEmployees.filter { employee in
              employee.firstName.lowercased().contains(searchText) ||
              employee.lastName.lowercased().contains(searchText) ||
              employee.userTag.lowercased().contains(searchText)
          }
          onEmployeesUpdated?()
      }
}
