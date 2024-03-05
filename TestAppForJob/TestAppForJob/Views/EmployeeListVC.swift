//
//  EmployeeListTableVC.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import Kingfisher
import SnapKit
import UIKit

final class EmployeeListVC: UIViewController {
    private var viewModel: EmployeeListViewModel!
    private var refreshControl: UIRefreshControl?
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.rowHeight = 100
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        
        viewModel = EmployeeListViewModel()
        refreshControl!.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        viewModel.fetchEmployees { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: Private methods
    
    @objc private func refreshData() {
        viewModel.refreshData()
        tableView.reloadData()
        refreshControl!.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension EmployeeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.employees.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        let employee = viewModel.employees[indexPath.row]
        cell.fullNameLabel.text = "\(employee.firstName) \(employee.lastName)"
        cell.positionLabel.text = employee.position
        cell.userTagLabel.text = employee.userTag
        cell.photoImageView.image = UIImage(named: "placeholder")
        
        // Изменение шрифта для fullNameLabel
        cell.fullNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Изменение шрифта и цвета + прозрачность для userTagLabel
        cell.userTagLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        cell.userTagLabel.font = UIFont.systemFont(ofSize: 12)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Загрузка изображения с использованием Kingfisher
            if let avatarURL = URL(string: employee.avatarURL) {
                cell.photoImageView.kf.setImage(with: avatarURL, placeholder: UIImage(named: "placeholder")) { result in
                    switch result {
                    case .success(let value):
                        cell.photoImageView.image = value.image
                        cell.layoutIfNeeded()
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
        return cell
    }
}
