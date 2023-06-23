import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import CoreMotion

class MainCameraViewController: UIViewController {
    
    private var cameraView: XCamera!

    var isOn = false
    var gridOn = false
    var touchShootOn = false
    
    var motionManager: CMMotionManager!
    var currentAngleH: Float = 0.0
    var currentAngleY: Float = 0.0
    var isSkyShot = false
    
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
    
    private lazy var underWarningTitle = UILabel().then {
        $0.text = "화면을 띄워주세요!"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private let centerButton = UIButton(type: .system).then {
        let image = UIImage(named: "centerButton")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
//        $0.layer.cornerRadius = 45.0
//        $0.layer.borderWidth = 2
//        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let correctionButton = UIButton(type: .system).then {
        let image = UIImage(named: "correctionImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let styleButton = UIButton(type: .system).then {
        let image = UIImage(named: "StyleImage")
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
    
    private let navCenterButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "aspectRatioButton"), for: .normal)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        cameraView = XCamera(frame: CGRect(x: 0, y: 0, width: 350, height: 480))
        configureNavigationItems()
        configureStackView()
        bindAction()
        layout()
        
        cameraView.setAspectRatio(.full)
        cameraView.setBackgroundColor(.white)
        cameraView.setFlashMode(.off)
        cameraView.setCameraPosition(.back)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        cameraView.addGestureRecognizer(pinchGesture)
        
        cameraView.startRunning()
        
        filterSelectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 270)

        setupUI()
        configureDeviceMotion()
        
        self.navigationItem.titleView = navCenterButton
        navCenterButton.addTarget(self, action: #selector(navCenterButtonTapped), for: .touchUpInside)
    }
    
    @objc func navCenterButtonTapped() {
        print("네비게이션 가운데 버튼이 눌렸습니다.")
    }
    
    func configureDeviceMotion() {
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main, withHandler: { (motion, error) in
            guard let deviceMotion = motion else { return }
            
            let attitude = deviceMotion.attitude
            let x = attitude.roll * (180 / .pi)
            let roundedX = Float(round(x * 100)) / 100.0
            let currentAngleY = attitude.pitch * (180 / .pi)

            self.currentAngleH = roundedX * 90

            if (-90 < self.currentAngleH && self.currentAngleH < 90
                    && -15 < currentAngleY && currentAngleY < 15) {
                
                self.view.subviews.forEach { subview in
                    if subview != self.centerButton && subview != self.cameraView {
                        if self.view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
                            let startColor = UIColor(red: 151 / 255, green: 149 / 255, blue: 240 / 255, alpha: 1.0).cgColor
                            let endColor = UIColor(red: 210 / 255, green: 179 / 255, blue: 224 / 255, alpha: 1.0).cgColor
                            
                            let gradientLayer = CAGradientLayer()
                            
                            gradientLayer.frame = self.view.bounds
                            
                            gradientLayer.colors = [startColor, endColor]
                            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
                            
                            self.view.layer.insertSublayer(gradientLayer, at: 0)
                        }
                        
                        self.navigationItem.rightBarButtonItem?.tintColor = .white
                        self.navigationItem.leftBarButtonItem?.tintColor = .white
                        
                        self.styleButton.isHidden = true
                        self.correctionButton.isHidden = true
                        self.effectButton.isHidden = true
                        self.filterButton.isHidden = true
                        self.toggleButtonStackView.isHidden = true
                        
                        self.centerButton.setBackgroundImage(UIImage(named: "180Button"), for: UIControl.State.normal)
                        
                        self.view.addSubview(self.underWarningTitle)
                        
                        self.underWarningTitle.snp.makeConstraints {
                            $0.top.equalTo(self.centerButton.snp.top).offset(-40.0)
                            $0.centerX.equalToSuperview()
                        }
                    }
                }
            } else {
                
                self.view.subviews.forEach { subview in
                    if subview != self.centerButton && subview != self.cameraView {
                        
                        if let gradientLayer = self.view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
                            gradientLayer.removeFromSuperlayer()
                        }
                        
                        self.navigationItem.rightBarButtonItem?.tintColor = .black
                        self.navigationItem.leftBarButtonItem?.tintColor = .black
                        
                        self.view.backgroundColor = .white
                                                
                        self.styleButton.isHidden = false
                        self.correctionButton.isHidden = false
                        self.effectButton.isHidden = false
                        self.filterButton.isHidden = false
                        self.toggleButtonStackView.isHidden = false
                        
                        self.underWarningTitle.removeFromSuperview()
                        
                        self.centerButton.setBackgroundImage(UIImage(named: "centerButton"), for: UIControl.State.normal)
                    }
                }
            }
        })
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {

        let zoomFactor = cameraView.handleZoomGesture(pinchGesture: gesture)
        print("Zoom factor: \(zoomFactor)")
    }
    
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: #selector(backButtonTap(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(ellipsisButtonTap(_:)))
    }
    
    private func configureButtonContainer(button: UIButton, label: UILabel, text: String) -> UIStackView {
        let buttonContainer = UIStackView()
        buttonContainer.axis = .vertical
        buttonContainer.alignment = .center
        buttonContainer.spacing = 0.0
        button.layer.cornerRadius = 8.0
        button.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        buttonContainer.addArrangedSubview(button)
        buttonContainer.addArrangedSubview(label)
        
        return buttonContainer
    }
    
    private func configureStackView() {
        
        let correctionButton = correctionButton
        let correctionLabel = UILabel()
        
        let correctionLabelButtonContainer = configureButtonContainer(button: correctionButton, label: correctionLabel, text: "보정")

        let styleButton = styleButton
        let styleLabel = UILabel()
        
        let styleLabelButtonContainer = configureButtonContainer(button: styleButton, label: styleLabel, text: "스타일")
        
        
        let effectButton = effectButton
        let effectLabel = UILabel()
        
        let effectLabelButtonContainer = configureButtonContainer(button: effectButton, label: effectLabel, text: "효과")
        
        let filterButton = filterButton
        let filterLabel = UILabel()
        
        let filterButtonContainer = configureButtonContainer(button: filterButton, label: filterLabel, text: "필터")
        
        
        stackView.addArrangedSubview(correctionLabelButtonContainer)
        stackView.addArrangedSubview(styleLabelButtonContainer)
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

        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterSelectionView()
            })

        filterSelectionView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideFilterSelectionView()
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
    
    private func bindAction() {
        centerButton.rx.tap
            .bind {
                print("centerButton tapped")
                self.cameraView.capturePhoto { result in
                    switch result {
                    case .success(let image):
                        print("사진 저장")
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        break
                    case .failure(let error):
                        print("저장 실패 \(error)")
                        break
                    }
                }
            }
    }
    
    @objc private func backButtonTap(_ sender: Any) {
        print("backButton tapped")
        
        isOn.toggle()
        
        if isOn {
            cameraView.setCameraPosition(.back)
            print("back")
        } else {
            cameraView.setCameraPosition(.front)
            print("front")
        }
    }
    
    @objc private func ellipsisButtonTap(_ sender: Any) {
        print("ellipsisButton tapped")

        touchShootOn.toggle()
        
        if touchShootOn {
            cameraView.addTapGesture(allow: false)
            print("실행하지 않음")
        } else {
            cameraView.addTapGesture(allow: true)
            print("실행")
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
