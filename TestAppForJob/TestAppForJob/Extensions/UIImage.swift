//
//  File.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 13.03.24.
//

import UIKit

extension UIImage {
    func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
