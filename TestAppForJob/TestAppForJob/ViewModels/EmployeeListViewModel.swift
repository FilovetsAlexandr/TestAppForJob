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
    var searchText: String?
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
                   let upcomingBirthdayDate2 = calendar.nextDate(after: today, matching: components2, matchingPolicy: .nextTime)
                {
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
                
                // Применяем фильтры к загруженным сотрудникам
                self?.applyFilters()
                    
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
        onEmployeesUpdated?()
    }
    private func applyFilters() {
        var filteredEmployees = employees
        
        // Применяем категорию
        if selectedCategoryIndex != 0 {
            let selectedCategory = categories[selectedCategoryIndex]
            filteredEmployees = filteredEmployees.filter { $0.department.lowercased() == selectedCategory.lowercased() }
        }
        
        // Применяем текст поиска
        if let searchText = searchText?.lowercased(), !searchText.isEmpty {
            filteredEmployees = filteredEmployees.filter { employee in
                employee.firstName.lowercased().contains(searchText) ||
                employee.lastName.lowercased().contains(searchText) ||
                employee.userTag.lowercased().contains(searchText)
            }
        }
        
        // Сохраняем отфильтрованных сотрудников
        self.filteredEmployees = filteredEmployees
        
        // Проверяем значение alphabetSwitch.isSelected в UserDefaults
        let alphabetSwitchState = UserDefaults.standard.bool(forKey: "AlphabetSwitchState")
        if alphabetSwitchState {
            // Если переключатель был выбран, сортируем пользователей по алфавиту
            sortEmployeesAlphabetically()
        } else {
            sortEmployeesByBirthday()
        }
        
        onEmployeesUpdated?()
    }
    
    func handleCategorySelection(at index: Int) {
        let searchText = self.searchText
        selectedCategoryIndex = index // Обновляем выбранную категорию
        
        switch index {
        case 0:
            categoryFilteredEmployees = employees // Обновляем массив categoryFilteredEmployees для категории "Все"
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
        
        if let alphabetSwitchState = UserDefaults.standard.object(forKey: "AlphabetSwitchState") as? Bool, alphabetSwitchState {
            filteredEmployees = categoryFilteredEmployees // Обновляем массив filteredEmployees с учетом выбранной категории
            sortEmployeesAlphabetically()
        } else {
            filteredEmployees = categoryFilteredEmployees // Обновляем массив filteredEmployees с учетом выбранной категории
            sortEmployeesByBirthday()
        }
        
        updateSearchResults(searchText: searchText)
    }
    
    func updateSearchResults(searchText: String?) {
        self.searchText = searchText ?? ""
        
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
