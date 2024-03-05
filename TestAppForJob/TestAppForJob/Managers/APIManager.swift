//
//  APIManager.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import Foundation

class APIManager {
    // Singleton
    static let shared = APIManager()
    
    let urlString = "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users"
    
    func getEmployees(completion: @escaping (Result<Employees, Error>) -> Void) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let employees = try JSONDecoder().decode(Employees.self, from: data)
                completion(.success(employees))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
