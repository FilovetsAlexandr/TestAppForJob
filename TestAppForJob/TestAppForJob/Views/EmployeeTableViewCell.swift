//
//  EmployeeTableViewCell.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import SnapKit
import UIKit

final class EmployeeTableViewCell: UITableViewCell {
    let fullNameLabel = UILabel()
    let positionLabel = UILabel()
    let userTagLabel = UILabel()
    let photoImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Разделение фотографии на круглую форму
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
        photoImageView.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        // Добавление элементов к contentView ячейки
        contentView.addSubview(photoImageView)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(userTagLabel)
        
        // Определение ограничений для каждого элемента с помощью SnapKit
        photoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(72)
            make.height.equalTo(72)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(photoImageView.snp.trailing).offset(10)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(5)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        userTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(fullNameLabel.snp.centerY)
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
