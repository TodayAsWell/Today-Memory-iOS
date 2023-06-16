import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MainCameraViewController: UIViewController {
    
    private var exView = UIImageView().then {
        $0.image = UIImage(named: "dagImage")
    }
    
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
        $0.backgroundColor = .white
        $0.layer.borderWidth = 5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 40.0
    }
    
    let styleButton = UIButton(type: .system).then {
        let image = UIImage(named: "StyleImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let correctionButton = UIButton(type: .system).then {
        let image = UIImage(named: "CorrectionImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }

    let effectButton = UIButton(type: .system).then {
        let image = UIImage(named: "EffectImage")
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
        $0.layer.cornerRadius = 19.0
    }
    
    private let videoToggleButton = UIButton().then {
        $0.setTitle("동영상", for: .normal)
        $0.setTitleColor(UIColor.Gray4, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = .White
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 19.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        styleButton.rx.tap
            .bind {
                print("asdf")
            }
        
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
        buttonContainer.spacing = 0.0
        button.layer.cornerRadius = 8.0
        button.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        label.text = "보정"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        buttonContainer.addArrangedSubview(button)
        buttonContainer.addArrangedSubview(label)
        
        return buttonContainer
    }
    
    private func configureStackView() {

        let styleButton = styleButton
        let styleLabel = UILabel()
        
        let styleLabelButtonContainer = configureButtonContainer(button: styleButton, label: styleLabel)
        
        let correctionButton = correctionButton
        let correctionLabel = UILabel()
        
        let correctionLabelButtonContainer = configureButtonContainer(button: correctionButton, label: correctionLabel)
        
        
        let effectButton = effectButton
        let effectLabel = UILabel()
        
        let effectLabelButtonContainer = configureButtonContainer(button: effectButton, label: effectLabel)
        
        let filterButton = filterButton
        let filterLabel = UILabel()
        
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
    
    private func layout() {
        [
            exView,
            stackView,
            toggleButtonStackView
        ].forEach { view.addSubview($0) }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            exView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(72.0)
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
                $0.width.height.equalTo(80)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.width.equalTo(148)
                $0.height.equalTo(76)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(stackView.snp.top).offset(-10.0)
            }
            
            [pictureToggleButton, videoToggleButton].forEach { button in
                toggleButtonStackView.addArrangedSubview(button)
                button.snp.makeConstraints {
                    $0.width.equalTo(54)
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
            
            
        } else {
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
        }
    }
}
