//
//  EmployeeListTableVC.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 4.03.24.
//

import SnapKit
import UIKit

final class EmployeeListVC: UIViewController {
    // MARK: - Variables

    private let viewModel: EmployeeListViewModel
    
    // MARK: - UI Components
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        return tv
    }()
    
    private let notFoundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notFound")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - LifeCycle

    init(_ viewModel: EmployeeListViewModel = EmployeeListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Загрузка состояния переключателей из UserDefaults
        let alphabetSwitchState = UserDefaults.standard.bool(forKey: "AlphabetSwitchState")
        let birthdaySwitchState = UserDefaults.standard.bool(forKey: "BirthdaySwitchState")
        
        // Применение выбранной сортировки
        if alphabetSwitchState {
            viewModel.sortEmployeesAlphabetically()
        } else if birthdaySwitchState {
            viewModel.sortEmployeesByBirthday()
        } else {
            viewModel.handleCategorySelection(at: viewModel.selectedCategoryIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupCollectionViewAndTableView()
        fetchData()
        setupNotFoundImageView()

        // Проверяем значение alphabetSwitch.isSelected в UserDefaults
        let alphabetSwitchState = UserDefaults.standard.bool(forKey: "AlphabetSwitchState")
        if alphabetSwitchState {
            // Если переключатель был выбран, сортируем пользователей по алфавиту
            viewModel.employees.sort { $0.firstName < $1.firstName }
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupCollectionViewAndTableView() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            return collectionView
        }()
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = #colorLiteral(red: 0.3981328607, green: 0.2060295343, blue: 1, alpha: 1)
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Введите имя, фамилию, тег..."
        
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        
        searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
    }
    
    private func setupNotFoundImageView() {
        view.addSubview(notFoundImageView)
        notFoundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(118)
        }
    }
    // MARK: - Data Fetching
    private func fetchData() {
        viewModel.onEmployeesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchEmployees()
    }
}

// MARK: - Search Controller Functions

extension EmployeeListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(searchText: searchController.searchBar.text)
        notFoundImageView.isHidden = !viewModel.filteredEmployees.isEmpty
        tableView.reloadData()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let filtersModalVC = EmployeeFiltersModalVC()
        filtersModalVC.delegate = self
        filtersModalVC.modalPresentationStyle = .overCurrentContext
        present(filtersModalVC, animated: false, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false // Отключаем активность поискового контроллера
        searchController.searchBar.text = nil // Очищаем текст поисковой строки
        viewModel.updateSearchResults(searchText: nil) // Обновляем результаты поиска с пустым текстом
        viewModel.handleCategorySelection(at: viewModel.selectedCategoryIndex) // Обновляем фильтры по категории
        notFoundImageView.isHidden = !viewModel.filteredEmployees.isEmpty // Обновляем видимость изображения "Не найдено"
        tableView.reloadData() // Обновляем таблицу
    }
}

// MARK: - TableView Functions

extension EmployeeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.filteredEmployees.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as? EmployeeTableViewCell else { fatalError("Unable to dequeue EmployeeCell") }
        let employee = viewModel.filteredEmployees[indexPath.row]
        let cellViewModel = EmployeeTableViewCellViewModel(employee: employee)
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 90 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let employee = viewModel.filteredEmployees[indexPath.row]
        let employeeDetailsVC = EmployeeDetailVC()
        employeeDetailsVC.employee = employee
        navigationController?.pushViewController(employeeDetailsVC, animated: true)
    }
}

// MARK: - CollectionView Functions

extension EmployeeListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.categories.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EmployeeHorizontalCategoriesCollectionViewCell
        
        let categories = viewModel.categories
        let category = categories[indexPath.item]
        let isSelected = indexPath.item == viewModel.selectedCategoryIndex
        let categoryViewModel = EmployeeHorizontalCategoriesCellViewModel(category: category, isSelected: isSelected)
        cell.configure(with: categoryViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.register(EmployeeHorizontalCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? EmployeeHorizontalCategoriesCollectionViewCell else { return CGSize(width: 100, height: 30) }
        
        let categories = viewModel.categories
        let category = categories[indexPath.item]
        let isSelected = indexPath.item == viewModel.selectedCategoryIndex
        let categoryViewModel = EmployeeHorizontalCategoriesCellViewModel(category: category, isSelected: isSelected)
        cell.configure(with: categoryViewModel)
        
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return CGSize(width: size.width + 15, height: 30)
    }
}

extension EmployeeListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.handleCategorySelection(at: indexPath.item)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension EmployeeListVC: FiltersModalVCDelegate {
    func didCloseFiltersModalVC() {
        // Загрузка состояния переключателей из UserDefaults
        let alphabetSwitchState = UserDefaults.standard.bool(forKey: "AlphabetSwitchState")
        let birthdaySwitchState = UserDefaults.standard.bool(forKey: "BirthdaySwitchState")
        
        // Применение выбранной сортировки
        if alphabetSwitchState {
            viewModel.sortEmployeesAlphabetically()
        } else if birthdaySwitchState {
            viewModel.sortEmployeesByBirthday()
        } else {
            viewModel.handleCategorySelection(at: viewModel.selectedCategoryIndex)
        }
    }
}
