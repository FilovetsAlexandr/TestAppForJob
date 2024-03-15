//
//  EmployeeListViewModel.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import UIKit

final class EmployeeListViewModel {
    // MARK: - Properties
    
    let categories = ["Все", "Android", "iOS", "Дизайн", "Менеджмент", "QA", "Бэк-офис", "Frontend", "HR", "PR", "Backend", "Техподдержка", "Аналитика"]
    
    var isAlphabeticallySorted: Bool = false
    private var isFetchingData = false
    var employees: [Employee] = []
    var searchResults: [Employee] = []
    private var categoryFilteredEmployees: [Employee] = []
    private var inSearchMode: Bool = false
    private var pastBirthdayEmployees: [Employee] = []
    var filteredEmployees: [Employee] = []
    var onEmployeesUpdated: (() -> Void)?
    var onErrorMessage: ((Error) -> Void)?
    var selectedCategoryIndex: Int = 0
    
    var birthdayEmployees: [Employee] = []
    var nonBirthdayEmployees: [Employee] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func sortEmployeesAlphabetically() {
        filteredEmployees.sort { $0.firstName < $1.firstName }
        onEmployeesUpdated?()
    }
    
    func sortEmployeesByBirthday() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        filteredEmployees.sort { employee1, employee2 -> Bool in
            let birthday1 = employee1.birthday
            let birthday2 = employee2.birthday

            if let date1 = dateFormatter.date(from: birthday1), let date2 = dateFormatter.date(from: birthday2) {
                let today = Date()
                let calendar = Calendar.current
                let components1 = calendar.dateComponents([.month, .day], from: date1)
                let components2 = calendar.dateComponents([.month, .day], from: date2)

                if let upcomingBirthdayDate1 = calendar.nextDate(after: today, matching: components1, matchingPolicy: .nextTime),
                    let upcomingBirthdayDate2 = calendar.nextDate(after: today, matching: components2, matchingPolicy: .nextTime) {

                    return upcomingBirthdayDate1 < upcomingBirthdayDate2
                }
            }

            return false
        }
        
        onEmployeesUpdated?()
    }
    
    
    func fetchEmployees() {
        guard !isFetchingData else { return }
            
        isFetchingData = true
            
        APIManager.shared.getEmployees { [weak self] result in
            self?.isFetchingData = false
                
            switch result {
            case .success(let response):
                self?.employees = response.items
                self?.categoryFilteredEmployees = response.items
                self?.filteredEmployees = response.items
                    
                // Проверяем значение alphabetSwitch.isSelected в UserDefaults
                let alphabetSwitchState = UserDefaults.standard.bool(forKey: "AlphabetSwitchState")
                if alphabetSwitchState {
                    // Если переключатель был выбран, сортируем пользователей по алфавиту
                    self?.sortEmployeesAlphabetically()
                } else {
                    self?.sortEmployeesByBirthday()
                }
                    
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
    
    func handleCategorySelection(at index: Int) {
        switch index {
        case 0:
            filteredEmployees = employees
        case 1:
            filteredEmployees = employees.filter { $0.department == "android" }
        case 2:
            filteredEmployees = employees.filter { $0.department == "ios" }
        case 3:
            filteredEmployees = employees.filter { $0.department == "design" }
        case 4:
            filteredEmployees = employees.filter { $0.department == "management" }
        case 5:
            filteredEmployees = employees.filter { $0.department == "qa" }
        case 6:
            filteredEmployees = employees.filter { $0.department == "back_office" }
        case 7:
            filteredEmployees = employees.filter { $0.department == "frontend" }
        case 8:
            filteredEmployees = employees.filter { $0.department == "hr" }
        case 9:
            filteredEmployees = employees.filter { $0.department == "pr" }
        case 10:
            filteredEmployees = employees.filter { $0.department == "backend" }
        case 11:
            filteredEmployees = employees.filter { $0.department == "support" }
        case 12:
            filteredEmployees = employees.filter { $0.department == "analytics" }
        default:
            filteredEmployees = employees
        }
        
        categoryFilteredEmployees = filteredEmployees
        
        if let alphabetSwitchState = UserDefaults.standard.object(forKey: "AlphabetSwitchState") as? Bool, alphabetSwitchState {
            sortEmployeesAlphabetically()
        } else {
            sortEmployeesByBirthday()
        }
    }
    
    func updateSearchResults(searchText: String?) {
           guard let searchText = searchText?.lowercased(), !searchText.isEmpty else {
               categoryFilteredEmployees = filteredEmployees
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
