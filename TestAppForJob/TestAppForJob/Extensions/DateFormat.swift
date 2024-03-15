//
//  DateFormat.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 15.03.24.
//

import Foundation

class DateFormat {
    static func formatDate(_ dateString: String, fromFormat: String, toFormat: String, localeIdentifier: String) -> String? {
        let dateFormatter = DateFormatter()
        // локализация
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        // установка формата даты
        dateFormatter.dateFormat = fromFormat
        // преобразование строки  в формат даты
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            return nil
        }
        // установка формата измененной даты
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    static func calculateAgeFromDate(_ dateString: String, format: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // можно ли создать дату из строки с помощью указанного формата и в случае неудачи возвращаем 0
        guard let birthDate = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            return 0
        }
        // Вычисляем возраст на основе разницы между датой рождения и текущей датой, возвращаем полученный возраст
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        return age
    }
}
