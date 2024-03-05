//
//  EmployeeListViewModel.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import NVActivityIndicatorView
import UIKit

final class EmployeeListViewModel {
    var employees: [Employee] = []

    func refreshData() {
        fetchEmployees { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let employees):
                    self?.employees = employees
                case .failure(let error):
                    print("Ошибка при получении данных: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchEmployees(completion: @escaping (Result<[Employee], Error>) -> Void) {
        APIManager.shared.getEmployees { result in
            switch result {
            case .success(let employees):
                self.employees = employees.items
                completion(.success(self.employees))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
