//
//  CustomModalViewController.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 12.03.24.
//

import SnapKit
import UIKit

class EmployeeFiltersModalVC: UIViewController {
    
    weak var delegate: CustomModalViewControllerDelegate?
    
    var containerViewHeightConstraint: Constraint?
    var containerViewBottomConstraint: Constraint?

    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "vector")
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.1079650596, green: 0.1179667488, blue: 0.1391604543, alpha: 1)
        let newButtonSize = CGRect(x: 0, y: 0, width: 6, height: 12)
        button.frame = newButtonSize
        button.isHidden = true
        button.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        return button
    }()
        
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сортировка"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
        
    lazy var alphabetSwitch: UIButton = {
        let button = UIButton(type: .custom)
        let unselectedImage = UIImage(named: "circleUnselected")?.resize(withSize: CGSize(width: 24, height: 24))
        let selectedImage = UIImage(named: "circleSelected")?.resize(withSize: CGSize(width: 24, height: 24))
        button.setImage(unselectedImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.addTarget(self, action: #selector(handleSwitchAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var alphabetLabel: UILabel = {
        let label = UILabel()
        label.text = " По алфавиту"
        label.textColor = .black
        return label
    }()
        
    lazy var birthdaySwitch: UIButton = {
        let button = UIButton(type: .custom)
        let unselectedImage = UIImage(named: "circleUnselected")?.resize(withSize: CGSize(width: 24, height: 24))
        let selectedImage = UIImage(named: "circleSelected")?.resize(withSize: CGSize(width: 24, height: 24))
        button.setImage(unselectedImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.addTarget(self, action: #selector(handleSwitchAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = " По дню рождения"
        label.textColor = .black
        return label
    }()
        
    lazy var contentStackView: UIStackView = {
        let alphabetStackView = UIStackView(arrangedSubviews: [alphabetSwitch, alphabetLabel])
        alphabetStackView.axis = .horizontal
        alphabetStackView.alignment = .leading

        let birthdayStackView = UIStackView(arrangedSubviews: [birthdaySwitch, birthdayLabel])
        birthdayStackView.axis = .horizontal
        birthdayStackView.alignment = .leading

        let spacer = UIView()

        let innerStackView = UIStackView(arrangedSubviews: [titleLabel])
        innerStackView.axis = .vertical
        innerStackView.alignment = .center

        let stackView = UIStackView(arrangedSubviews: [innerStackView, alphabetStackView, birthdayStackView, spacer])
        stackView.axis = .vertical
        stackView.spacing = 10

        return stackView
    }()
        
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
        
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
        
    // Constants
    let defaultHeight: CGFloat = UIScreen.main.bounds.height / 2
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 60
    var currentContainerHeight: CGFloat = 300
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        setupPanGesture()
        backButton.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(alphabetSwitch.isSelected, forKey: "AlphabetSwitchState")
        UserDefaults.standard.set(birthdaySwitch.isSelected, forKey: "BirthdaySwitchState")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
        let alphabetSwitchState = UserDefaults.standard.bool(forKey: "AlphabetSwitchState")
        let birthdaySwitchState = UserDefaults.standard.bool(forKey: "BirthdaySwitchState")
        
        if !alphabetSwitchState && !birthdaySwitchState {
            // Если ни один переключатель не выбран, выбераем alphabetSwitch по умолчанию
            alphabetSwitch.isSelected = true
            birthdaySwitch.isSelected = false
        } else {
            // Если уже выбран один из переключателей, сделаем выбранный переключатель активным
            alphabetSwitch.isSelected = alphabetSwitchState
            birthdaySwitch.isSelected = birthdaySwitchState
        }
    }
        
    @objc func handleBackAction() {
        dismiss(animated: false, completion: nil)
    }
        
    @objc func handleCloseAction() {
        animateDismissView()
    }
        
    @objc func handleSwitchAction(_ sender: UIButton) {
        if sender == alphabetSwitch {
            if sender.isSelected {
                // Если переключатель уже выбран, сделаем его неактивным
                alphabetSwitch.isSelected = false
            } else {
                // Если переключатель не выбран, снимаем выбор с другого переключателя и выбираем этот
                alphabetSwitch.isSelected = true
                birthdaySwitch.isSelected = false
            }
        } else if sender == birthdaySwitch {
            if sender.isSelected {
                // Если переключатель уже выбран, сделаем его неактивным
                birthdaySwitch.isSelected = false
            } else {
                // Если переключатель не выбран, снимаем выбор с другого переключателя и выбираем этот
                birthdaySwitch.isSelected = true
                alphabetSwitch.isSelected = false
            }
        }
        
        // Сохраняем выбор в UserDefaults
        UserDefaults.standard.set(alphabetSwitch.isSelected, forKey: "AlphabetSwitchState")
        UserDefaults.standard.set(birthdaySwitch.isSelected, forKey: "BirthdaySwitchState")
        
        // Закрываем модальное окно
        delegate?.didCloseModalViewController()
        dismiss(animated: true, completion: nil)
    }
        
    func setupView() {
        view.backgroundColor = .clear
    }
        
    func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(contentStackView)
        containerView.addSubview(backButton)
                
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            containerViewHeightConstraint = make.height.equalTo(defaultHeight).constraint
        }
                
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().offset(-20)
        }
                
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }

    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.update(offset: newHeight)
                view.layoutIfNeeded()
                backButton.isHidden = false
            }
        case .ended:
            if newHeight < dismissibleHeight {
                animateDismissView()
                backButton.isHidden = true
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
                backButton.isHidden = true
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
                backButton.isHidden = true
            } else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        containerView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }

    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }

    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint?.update(offset: self.defaultHeight)
            self.view.layoutIfNeeded()
        }
    }
}

protocol CustomModalViewControllerDelegate: AnyObject {
    func didCloseModalViewController()
}
