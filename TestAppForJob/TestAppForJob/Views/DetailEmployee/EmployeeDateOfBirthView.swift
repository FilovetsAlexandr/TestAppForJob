//
//  UserDateOfBirthView.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 15.03.24.
//

import UIKit
import SnapKit

class EmployeeDateOfBirthView: UIView {
    // MARK: - Constants
    let dateOfBirthLabel = UILabel()
    let ageLabel = UILabel()
    let starImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(dateOfBirthLabel)
        addSubview(ageLabel)
        addSubview(starImageView)
        backgroundColor = .white
        configureDateOfBirthLabel()
        configureAgeLabel()
        configureStarImageView()
        
        // MARK: - setConstraints
        starImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        dateOfBirthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.leading.equalTo(starImageView.snp.trailing).offset(12)
        }
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.trailing.equalToSuperview()
        }
    }
    
    private func configureDateOfBirthLabel() {
        dateOfBirthLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        dateOfBirthLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configureAgeLabel() {
        ageLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        ageLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configureStarImageView() {
        starImageView.clipsToBounds = true
        starImageView.contentMode = .scaleAspectFill
        starImageView.image = UIImage(named: "star")
    }
}
