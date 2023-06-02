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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: #selector(backButtonTap(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(ellipsisButtonTap(_:)))
        
        (0..<4).forEach { _ in
            let button = UIButton(type: .system).then {
                $0.backgroundColor = .black
                $0.snp.makeConstraints { make in
                    make.width.height.equalTo(35)
                }
            }
            
            let label = UILabel().then {
                $0.text = "보정"
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.textAlignment = .center
            }
            
            let buttonContainer = UIStackView().then {
                $0.axis = .vertical
                $0.alignment = .center
                $0.spacing = 6.5
            }
            
            buttonContainer.addArrangedSubview(button)
            buttonContainer.addArrangedSubview(label)
            
            stackView.addArrangedSubview(buttonContainer)
        }
        
        stackView.insertArrangedSubview(centerButton, at: 2)
        
        centerButton.rx.tap
            .bind {
                print("centerButton tapped")
            }
        
        layout()
    }
    
    func layout() {
        [
            exView
        ].forEach { view.addSubview($0) }
        
        exView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(90.0)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(430.0)
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-86)
            make.left.greaterThanOrEqualToSuperview().offset(20)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.left.equalTo(centerButton.snp.left).offset(-20).priority(.high)
            make.right.equalTo(centerButton.snp.right).offset(20).priority(.high)
        }
        
        centerButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        stackView.arrangedSubviews.forEach { arrangedSubview in
            guard let buttonContainer = arrangedSubview as? UIStackView else { return }
            buttonContainer.alignment = .center
            buttonContainer.distribution = .fill
        }
    }
    
    @objc private func backButtonTap(_ sender: Any) {
        print("backButton tapped")
    }
    
    @objc private func ellipsisButtonTap(_ sender: Any) {
        print("ellipsisButton tapped")
    }
}
