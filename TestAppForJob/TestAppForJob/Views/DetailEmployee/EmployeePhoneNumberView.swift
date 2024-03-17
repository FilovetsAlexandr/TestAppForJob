//
//  UserPhoneNumberView.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 15.03.24.
//

import UIKit
import SnapKit

class EmployeePhoneNumberView: UIView {
    // MARK: - Constants
    let numberLabel = UILabel()
    let phoneImageView = UIImageView()
    var tapPhoneHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(numberLabel)
        addSubview(phoneImageView)
        backgroundColor = .white
        configureProfilePhoneNumberLabel()
        configureProfilePhoneImage()
        
        // MARK: - setConstraints
        phoneImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneImageView)
            make.leading.equalTo(phoneImageView.snp.trailing).offset(12)
            // Устанавливаем правую границу метки таким образом чтобы она находилась внутри
            make.trailing.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    private func configureProfilePhoneNumberLabel() {
        numberLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        numberLabel.font = UIFont(name: "Inter-Medium", size: 16)
        numberLabel.isUserInteractionEnabled = true
        numberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneIconTapped)))
    }
    
    private func configureProfilePhoneImage() {
        phoneImageView.clipsToBounds = true
        phoneImageView.contentMode = .scaleAspectFill
        phoneImageView.image = UIImage(named: "phone")
        phoneImageView.isUserInteractionEnabled = true
        phoneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneIconTapped)))
    }
    
    @objc private func phoneIconTapped() {
        tapPhoneHandler?()
    }
}
