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
    
    private let toggleButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .center
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
            stackView,
            toggleButtonStackView
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

        pictureToggleButton.backgroundColor = pictureToggleButton.isSelected ? .Yellow : .White
        videoToggleButton.backgroundColor = videoToggleButton.isSelected ? .Yellow : .White

        let button1TitleColor: UIColor = pictureToggleButton.isSelected ? .black : .Gray4
        let button2TitleColor: UIColor = videoToggleButton.isSelected ? .black : .Gray4
        pictureToggleButton.setTitleColor(button1TitleColor, for: .normal)
        videoToggleButton.setTitleColor(button2TitleColor, for: .normal)
    }
}
