//
//  EmployeeTableViewCell.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import Kingfisher
import SnapKit
import UIKit

final class EmployeeTableViewCell: UITableViewCell {
    static let identifier = "EmployeeTableViewCell"
    
    // MARK: - Variables
      
    private var viewModel: EmployeeTableViewCellViewModel?
    
    // MARK: - UI Components
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let userTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 36
        return imageView
    }()
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: EmployeeTableViewCellViewModel) {
        self.viewModel = viewModel
          
        fullNameLabel.text = viewModel.fullName
        positionLabel.text = viewModel.position
        userTagLabel.text = viewModel.userTag
        updateBirthdayLabel()

        photoImageView.kf.setImage(with: viewModel.avatarURL, placeholder: UIImage(named: "placeholder"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullNameLabel.text = nil
        positionLabel.text = nil
        userTagLabel.text = nil
        birthdayLabel.text = nil
        photoImageView.image = nil
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        addSubview(photoImageView)
        addSubview(fullNameLabel)
        addSubview(positionLabel)
        addSubview(userTagLabel)
        addSubview(birthdayLabel)
        
        photoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(72)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalTo(photoImageView.snp.trailing).offset(10)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        userTagLabel.snp.makeConstraints { make in
            make.leading.equalTo(fullNameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(fullNameLabel)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(fullNameLabel)
        }
    }
    // MARK: Private methods
    
    private func updateBirthdayLabel() {
        let birthdaySwitchState = UserDefaults.standard.bool(forKey: "BirthdaySwitchState")
        
        if birthdaySwitchState {
            if let birthdayString = viewModel?.birthday {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let birthdayDate = dateFormatter.date(from: birthdayString) {
                    let russianLocale = Locale(identifier: "ru_RU")
                    dateFormatter.locale = russianLocale
                    dateFormatter.dateFormat = "dd MMMM"
                    let formattedDate = dateFormatter.string(from: birthdayDate)
                    birthdayLabel.text = formattedDate
                } else {
                    birthdayLabel.text = nil
                }
            } else {
                birthdayLabel.text = nil
            }
        } else {
            birthdayLabel.text = nil
        }
    }
}
