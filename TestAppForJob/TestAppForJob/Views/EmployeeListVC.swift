//
//  EmployeeListTableVC.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import Kingfisher
import SnapKit
import UIKit

class EmployeeListVC: UIViewController {
    
    private var viewModel: EmployeeListVC!
    private var employees: [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       // tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "cell")
        
        APIManager.shared.getEmployees { result in
            switch result {
            case .success(let employees):
                // Обработка успешного получения данных
                DispatchQueue.main.async {
                    self.viewModel.employees = employees.items
                    self.tableView.reloadData()
                }
            case .failure(let error):
                // Обработка ошибки
                print(error)
            }
        }
        
        viewModel = EmployeeListVC()
    }
    
    // MARK: Private properties
    private var tableView = UITableView()
}

// MARK: - UITableViewDataSource
extension EmployeeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.employees.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        let employee = viewModel.employees[indexPath.row]
        cell.fullNameLabel.text = "\(employee.firstName) \(employee.lastName)"
        cell.positionLabel.text = employee.position
        cell.photoImageView.image = UIImage(named: "placeholder")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            // Загрузка изображения с использованием Kingfisher
            if let avatarURL = URL(string: employee.avatarURL) {
                  cell.photoImageView.kf.setImage(with: avatarURL, placeholder: UIImage(named: "placeholder")) { result in
                      switch result {
                      case .success(let value):
                          cell.photoImageView.image = value.image
                          cell.setNeedsLayout() // Обновите ячейку после загрузки изображения
                      case .failure(let error):
                          print("Error loading image: \(error)")
                      }
                  }
              }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 120 }
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 45 }
}
