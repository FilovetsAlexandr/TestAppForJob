//
//  EmployeeListErrorVC.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import SnapKit
import UIKit

final class EmployeeListErrorVC: UIViewController {
    private var retryAction: (() -> Void)?
    
    init(retryAction: @escaping (() -> Void)) {
        self.retryAction = retryAction
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nlo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Какой-то сверхразумный все сломал"
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Постараемся быстро починить"
        return label
    }()
    
    private let tryAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Попробовать снова", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.purple, for: .normal)
        button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(errorImageView)
        errorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(56)
        }
        
        view.addSubview(helloLabel)
        helloLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorImageView.snp.bottom).offset(16)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(helloLabel.snp.bottom).offset(16)
        }
        
        // Add tryAgainButton after other subviews
        view.addSubview(tryAgainButton)
        tryAgainButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorLabel.snp.bottom).offset(16)
        }
    }
    
    @objc private func tryAgainButtonTapped() {
        retryAction?()
        dismiss(animated: true, completion: nil)
    }
}
