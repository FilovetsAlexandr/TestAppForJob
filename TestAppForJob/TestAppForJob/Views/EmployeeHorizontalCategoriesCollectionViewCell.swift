//
//  CustomCollectionViewCell.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 11.03.24.
//

import UIKit

final class EmployeeHorizontalCategoriesCollectionViewCell: UICollectionViewCell {
    
    let nameCategoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3981328607, green: 0.2060295343, blue: 1, alpha: 1)
        view.isHidden = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            nameCategoryLabel.textColor = self.isSelected ? .black : .gray
            selectionView.isHidden = !self.isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameCategoryLabel)
        nameCategoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(selectionView)
        selectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
