//
//  EmployeeDetailVC.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 15.03.24.
//

import Kingfisher
import SnapKit
import UIKit

class EmployeeDetailVC: UIViewController {
    // MARK: - Constants

    private let profileView = EmployeeProfileView()
    private let birthView = EmployeeDateOfBirthView()
    private let phoneNumberView = EmployeePhoneNumberView()
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        backButtonSetup()
        handlePhoneTapNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Views

    private func setupViews() {
        view.addSubview(profileView)
        view.addSubview(birthView)
        view.addSubview(phoneNumberView)
        view.backgroundColor = .white
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(184)
        }
        birthView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(60)
        }
        phoneNumberView.snp.makeConstraints { make in
            make.top.equalTo(birthView.snp.bottom).offset(6)
            make.leading.equalTo(birthView)
            make.trailing.equalTo(birthView)
            make.height.equalTo(60)
        }
        
        if let employee = employee {
            setupUserProfile(employee)
        }
    }
    
    // MARK: - Loading Views

    private func setupUserProfile(_ employee: Employee) {
        loadImage(employee)
        assignData(employee)
        formatAndDisplayDateOfBirth(employee)
        displayAge(employee)
    }
    
    private func loadImage(_ employee: Employee) {
        let placeholderImage = UIImage(named: "placeholder")
        let avatarURL = URL(string: employee.avatarURL)
        profileView.photoImageView.kf.setImage(with: avatarURL, placeholder: placeholderImage)
    }

    private func assignData(_ employee: Employee) {
        profileView.nameLabel.text = employee.firstName + " " + employee.lastName
        profileView.userTagLabel.text = employee.userTag
        profileView.positionLabel.text = employee.position
        phoneNumberView.numberLabel.text = employee.phone
    }
    
    private func formatAndDisplayDateOfBirth(_ employee: Employee) {
        let formattedDate = DateFormat.formatDate(employee.birthday, fromFormat: "yyyy-MM-dd", toFormat: "d MMMM yyyy", localeIdentifier: "ru_RU")
        birthView.dateOfBirthLabel.text = formattedDate
    }
    
    private func displayAge(_ employee: Employee) {
        let age = DateFormat.calculateAgeFromDate(employee.birthday, format: "yyyy-MM-dd")
        let resultAgeString: String

        switch age % 10 {
        case 1 where age % 100 != 11:
            resultAgeString = "\(age) год"
        case 2 ... 4 where !(age % 100 >= 12 && age % 100 <= 14):
            resultAgeString = "\(age) года"
        default:
            resultAgeString = "\(age) лет"
        }
        
        birthView.ageLabel.text = resultAgeString
    }
    
    // MARK: - Back Button Setup

    private func backButtonSetup() {
        let backButton = UIBarButtonItem(image: UIImage(named: "backVector"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Phone Number Handling

    private func handlePhoneTapNumber() {
        phoneNumberView.tapPhoneHandler = {
            self.handlePhoneTap()
        }
    }
    
    private func handlePhoneTap() {
        guard let phoneNumber = employee?.phone else {
            print("Некорректный номер телефона")
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let callAction = UIAlertAction(title: "\(phoneNumber)", style: .default) { _ in
            self.makeCall()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        callAction.setValue(UIColor(red: 0.198, green: 0.198, blue: 0.198, alpha: 1), forKey: "titleTextColor")
        cancelAction.setValue(UIColor(red: 0.198, green: 0.198, blue: 0.198, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(callAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - makeCall

    private func validatePhoneNumber() -> String? {
        guard let phoneNumber = phoneNumberView.numberLabel.text else {
            return nil
        }
        return phoneNumber
    }
    
    // открытие URL для осуществления звонка
    private func openCallURL(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else {
            print("URL не может быть создан")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                if success {
                    print("Идет вызов")
                } else {
                    print("Не удалось совершить звонок")
                }
            })
        } else { print("Устройство не может осуществить звонок") }
    }
    
    // совершение звонка
    private func makeCall() {
        guard let phoneNumber = validatePhoneNumber() else {
            print("Некорректный номер телефона")
            return
        }
        openCallURL(phoneNumber: phoneNumber)
    }
}
