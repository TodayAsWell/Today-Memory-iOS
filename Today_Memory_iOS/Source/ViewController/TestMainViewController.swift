//
//  TestMainViewController.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/20.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class TestMainCameraViewController: UIViewController {
    
    private var cameraView = UIView().then {
        $0.backgroundColor = .red
        
    }

    var isOn = false
    var gridOn = false
    var touchShootOn = false
    
    private let filterSelectionView = FilterSelectionView()
    
    private let stackView = UIStackView().then {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            $0.axis = .horizontal
            $0.spacing = 80.0
            $0.alignment = .center
        } else {
            $0.axis = .horizontal
            $0.spacing = 40.0
            $0.alignment = .center
        }
        
    }
    
    private let centerButton = UIButton(type: .system).then {
        let image = UIImage(named: "centerButton")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 45.0
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let styleButton = UIButton(type: .system).then {
        let image = UIImage(named: "EffectImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let correctionButton = UIButton(type: .system).then {
        let image = UIImage(named: "BellImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }

    let effectButton = UIButton(type: .system).then {
        let image = UIImage(named: "StyleImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let filterButton = UIButton(type: .system).then {
        let image = UIImage(named: "FilterImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    private let toggleButtonStackView = UIStackView().then {

        if UIDevice.current.userInterfaceIdiom == .pad {
            $0.axis = .horizontal
            $0.spacing = 20.0
            $0.alignment = .center
        } else {
            $0.axis = .horizontal
            $0.spacing = 20.0
            $0.alignment = .center
        }
    }
    
    private let pictureToggleButton = UIButton().then {
        $0.setTitle("사진", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = .Yellow
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 16.5
    }
    
    private let videoToggleButton = UIButton().then {
        $0.setTitle("동영상", for: .normal)
        $0.setTitleColor(UIColor.Gray4, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = .White
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 16.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationItems()
        configureStackView()
        layout()
        
        filterSelectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 270)
        
        setupUI()
    }
    
    @objc func buttonTappeds() {
        // 버튼이 탭되었을 때 처리할 로직
        print("버튼 탭 됨")
    }
    
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
    }
    
    private func configureButtonContainer(button: UIButton, label: UILabel) -> UIStackView {
        let buttonContainer = UIStackView()
        buttonContainer.axis = .vertical
        buttonContainer.alignment = .center
        buttonContainer.spacing = 8.0
        button.layer.cornerRadius = 8.0
        button.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        buttonContainer.addArrangedSubview(button)
        buttonContainer.addArrangedSubview(label)
        
        return buttonContainer
    }
    
    private func configureStackView() {

        let styleButton = styleButton
        let styleLabel = UILabel()
        styleLabel.text = "보정"
        let styleLabelButtonContainer = configureButtonContainer(button: styleButton, label: styleLabel)
        
        let correctionButton = correctionButton
        let correctionLabel = UILabel()
        correctionLabel.text = "스타일"
        let correctionLabelButtonContainer = configureButtonContainer(button: correctionButton, label: correctionLabel)
        
        
        let effectButton = effectButton
        let effectLabel = UILabel()
        effectLabel.text = "효과"
        let effectLabelButtonContainer = configureButtonContainer(button: effectButton, label: effectLabel)
        
        let filterButton = filterButton
        let filterLabel = UILabel()
        filterLabel.text = "필터"
        let filterButtonContainer = configureButtonContainer(button: filterButton, label: filterLabel)
        
        
        
        stackView.addArrangedSubview(styleLabelButtonContainer)
        stackView.addArrangedSubview(correctionLabelButtonContainer)
        stackView.addArrangedSubview(centerButton)
        stackView.addArrangedSubview(effectLabelButtonContainer)
        stackView.addArrangedSubview(filterButtonContainer)
        stackView.insertArrangedSubview(centerButton, at: 2)
        
        stackView.arrangedSubviews.forEach { arrangedSubview in
            guard let buttonContainer = arrangedSubview as? UIStackView else { return }
            buttonContainer.alignment = .center
            buttonContainer.distribution = .fill
        }
    }
    
    private func setupUI() {
        view.addSubview(filterSelectionView)

        styleButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.showFilterSelectionView()
            })

        filterSelectionView.closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.hideFilterSelectionView()
            })
    }
    
    private func layout() {
        [
            cameraView,
            stackView,
            toggleButtonStackView
        ].forEach { view.addSubview($0) }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cameraView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(53.0)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalTo(744.0)
            }
            
            stackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-36)
                $0.left.greaterThanOrEqualToSuperview().offset(20)
                $0.right.lessThanOrEqualToSuperview().offset(-20)
                $0.left.equalTo(centerButton.snp.left).offset(-40).priority(.high)
                $0.right.equalTo(centerButton.snp.right).offset(40).priority(.high)
            }
            
            centerButton.snp.makeConstraints {
                $0.width.height.equalTo(90)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.width.equalTo(178)
                $0.height.equalTo(76)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(stackView.snp.top).offset(-10.0)
            }
            
            [pictureToggleButton, videoToggleButton].forEach { button in
                toggleButtonStackView.addArrangedSubview(button)
                button.snp.makeConstraints {
                    $0.width.equalTo(87)
                    $0.height.equalTo(33)
                }
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            
            pictureToggleButton.snp.makeConstraints {
                $0.width.equalTo(videoToggleButton.snp.width)
            }
            
            videoToggleButton.snp.makeConstraints {
                $0.width.equalTo(pictureToggleButton.snp.width)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
            
            
        } else {
            cameraView.snp.makeConstraints {
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
            
            toggleButtonStackView.snp.makeConstraints {
                $0.width.equalTo(148)
                $0.height.equalTo(76)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(stackView.snp.top).offset(-20.0)
            }
            
            [pictureToggleButton, videoToggleButton].forEach { button in
                toggleButtonStackView.addArrangedSubview(button)
                button.snp.makeConstraints {
                    $0.width.equalTo(74)
                    $0.height.equalTo(38)
                }
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            
            pictureToggleButton.snp.makeConstraints {
                $0.width.equalTo(videoToggleButton.snp.width)
            }
            
            videoToggleButton.snp.makeConstraints {
                $0.width.equalTo(pictureToggleButton.snp.width)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        pictureToggleButton.isSelected = (sender == pictureToggleButton)
        videoToggleButton.isSelected = (sender == videoToggleButton)
        
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
            
            let button1TitleColor: UIColor = self.pictureToggleButton.isSelected ? .black : .Gray4
            let button2TitleColor: UIColor = self.videoToggleButton.isSelected ? .black : .Gray4
            self.pictureToggleButton.setTitleColor(button1TitleColor, for: .normal)
            self.videoToggleButton.setTitleColor(button2TitleColor, for: .normal)
            
            self.pictureToggleButton.backgroundColor = self.pictureToggleButton.isSelected ? .Yellow : .White
            self.videoToggleButton.backgroundColor = self.videoToggleButton.isSelected ? .Yellow : .White
            
            if self.pictureToggleButton.isSelected {
                self.centerButton.snp.remakeConstraints {
                    $0.width.height.equalTo(90)
                    $0.centerY.equalToSuperview()
                }
            } else if self.videoToggleButton.isSelected {
                self.centerButton.snp.remakeConstraints {
                    $0.width.height.equalTo(90)
                    $0.centerX.equalToSuperview()
                }
            }
            
            self.stackView.setNeedsLayout()
            self.stackView.layoutIfNeeded()
        }
    }

    
    private func showFilterSelectionView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterSelectionView.frame.origin.y = self.view.frame.height - self.filterSelectionView.frame.height
        }
    }

    private func hideFilterSelectionView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterSelectionView.frame.origin.y = self.view.frame.height
        }
    }
}
