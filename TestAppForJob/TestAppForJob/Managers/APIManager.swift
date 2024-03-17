//
//  APIManager.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import Foundation

// MARK: - Errors
enum NetworkError: Error {
    case noData
    case noInternet
    case serverError
    case decodingError
}

// MARK: - APIManager class
final class APIManager {
    // Singleton
    static let shared = APIManager()
    
    func fetchUserData(completion: @escaping (Result<Employees, NetworkError>) -> Void) {
        print("try to fetch")
        let urlString = "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users"
        guard let apiURL = URL(string: urlString) else {
            fatalError("Ошибка: неверный URL")
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Успешный запрос
        request.setValue("code=200, example=success", forHTTPHeaderField: "Prefer" )
        
        // Запрос с ошибкой
//        request.setValue("code=500, example=error-500", forHTTPHeaderField: "Prefer" )
        
        
        URLSession.shared.dataTask(with: request) { data, response, error  in
            // Проверка наличия ошибки при выполнении запроса
            guard error == nil else {
                print("Ошибка при выполнении запроса: \(error?.localizedDescription ?? "")")
                completion(.failure(.noData))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            print("Статус код: \(httpResponse?.statusCode ?? 0)")
            
            // Проверка статус кода на наличие ошибки 500
            if httpResponse?.statusCode == 500 {
                if let preferHeader = httpResponse?.value(forHTTPHeaderField: "Prefer"), preferHeader.contains("code=500") {
                    completion(.failure(.serverError))
                    return
                }
            }
            
            guard let safeData = data else { return }
            
            do {
                let decodedEmployees = try JSONDecoder().decode(Employees.self, from: safeData)
                print("Успешное декодирование данных: \(decodedEmployees)")
                completion(.success(decodedEmployees))
            } catch let decodeError {
                print("Ошибка декодирования данных: \(decodeError)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
