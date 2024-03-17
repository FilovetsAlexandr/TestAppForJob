//
//  ErrorLoadView.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 16.03.24.
//

import UIKit
import SnapKit

class EmployeeErrorLoadView: UIView {
    // MARK: - Constants
    private let errorImageView = UIImageView()
    private let errorTitleLabel = UILabel()
    private let errorDescriptionLabel = UILabel()
    let tryRequestButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(errorImageView)
        addSubview(errorTitleLabel)
        addSubview(errorDescriptionLabel)
        addSubview(tryRequestButton)
        setupUI()
        configureErrorImageView()
        configureErrorTitleLabel()
        configureDescriptionLabel()
        configureRequestButton()
        setupConstraints()
        
    }
    
    // MARK: - Configures
    
    private func setupConstraints() {
        errorImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(56)
        }
        errorTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(errorImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        errorDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(errorTitleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        tryRequestButton.snp.makeConstraints { make in
            make.top.equalTo(errorDescriptionLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(343)
        }
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
    }
    
    private func configureErrorImageView() {
        errorImageView.clipsToBounds = true
        errorImageView.contentMode = .scaleAspectFill
        errorImageView.image = UIImage(named: "nlo")
    }
    
    private func configureErrorTitleLabel() {
        errorTitleLabel.text = "Какой-то сверхразум все сломал"
        errorTitleLabel.textColor = #colorLiteral(red: 0.0196066983, green: 0.01960874721, blue: 0.06194228679, alpha: 1)
        errorTitleLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
        errorTitleLabel.textAlignment = .center
    }
    
    private func configureDescriptionLabel() {
        errorDescriptionLabel.text = "Постараемся быстро починить"
        errorDescriptionLabel.textColor = #colorLiteral(red: 0.5921563506, green: 0.5921571851, blue: 0.6093562245, alpha: 1)
        errorDescriptionLabel.font = UIFont(name: "Inter-Regular", size: 16)
        errorDescriptionLabel.textAlignment = .center
    }
    
    private func configureRequestButton() {
        tryRequestButton.setTitle("Попробовать снова", for: .normal)
        tryRequestButton.backgroundColor = .white
        tryRequestButton.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        tryRequestButton.setTitleColor(UIColor.systemGray4, for: .highlighted)
        tryRequestButton.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
    }
}
