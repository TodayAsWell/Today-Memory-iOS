//
//  MainCameraViewController.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift
import SnapKit
import Then

class MainCameraViewController: UIViewController {
    
    private var exView = UIImageView().then {
        $0.image = UIImage(named: "dagImage")
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 30
    }
    
    private let centerButton = UIButton(type: .system).then {
        let image = UIImage(named: "CaptureButton")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavigationItems()
        configureStackView()
        bindAction()
        layout()
    }
    
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: #selector(backButtonTap(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(ellipsisButtonTap(_:)))
    }
    
    private func configureButtonContainer(button: UIButton, label: UILabel) -> UIStackView {
        let buttonContainer = UIStackView()
        buttonContainer.axis = .vertical
        buttonContainer.alignment = .center
        buttonContainer.spacing = 6.5
        
        button.backgroundColor = .black
        button.snp.makeConstraints { make in
            make.width.height.equalTo(35)
        }
        
        label.text = "보정"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        buttonContainer.addArrangedSubview(button)
        buttonContainer.addArrangedSubview(label)
        
        return buttonContainer
    }
    
    private func configureStackView() {
        (0..<4).forEach { _ in
            let button = UIButton(type: .system)
            let label = UILabel()
            
            let buttonContainer = configureButtonContainer(button: button, label: label)
            stackView.addArrangedSubview(buttonContainer)
        }
        
        stackView.insertArrangedSubview(centerButton, at: 2)
        
        stackView.arrangedSubviews.forEach { arrangedSubview in
            guard let buttonContainer = arrangedSubview as? UIStackView else { return }
            buttonContainer.alignment = .center
            buttonContainer.distribution = .fill
        }
    }
    
    private func layout() {
        [
            exView,
            stackView
        ].forEach { view.addSubview($0) }
        
        exView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(90.0)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(430.0)
        }
                
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-86)
            $0.left.greaterThanOrEqualToSuperview().offset(20)
            $0.right.lessThanOrEqualToSuperview().offset(-20)
            $0.left.equalTo(centerButton.snp.left).offset(-20).priority(.high)
            $0.right.equalTo(centerButton.snp.right).offset(20).priority(.high)
        }
        
        centerButton.snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
    }
    
    private func bindAction() {
        centerButton.rx.tap
            .bind {
                print("centerButton tapped")
            }
    }
    
    @objc private func backButtonTap(_ sender: Any) {
        print("backButton tapped")
    }
    
    @objc private func ellipsisButtonTap(_ sender: Any) {
        print("ellipsisButton tapped")
    }
}
