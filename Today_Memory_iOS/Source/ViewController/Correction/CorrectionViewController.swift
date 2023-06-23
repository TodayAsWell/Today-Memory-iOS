import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class CorrectionViewController: UIViewController, SendDataDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate {
    
    let disposeBag = DisposeBag()
    
    private let controlView = ControlView()
    private let frameView = FrameView()
    private let stickerView = StickerView()
    
    lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "이전", image: UIImage(systemName: "arrow.uturn.left"), handler: { _ in
                print("이전")
            }),
            UIAction(title: "다음", image: UIImage(systemName: "arrow.uturn.right"), handler: { _ in
                print("다음")
            }),
            UIAction(title: "초기화", image: UIImage(systemName: "arrow.clockwise"), handler: { _ in
                print("초기화")
            }),
            UIAction(title: "설정", image: UIImage(systemName: "gearshape.fill"), handler: { _ in
                print("설정")
                let settingViewController = SettingViewController()
                self.navigationController?.pushViewController(settingViewController, animated: true)
            })
        ]
    }()
    
    lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    
    
    private var exImage = UIImageView().then {
        $0.image = UIImage(named: "ExPolaroid")
    }
    
    private let filterButton = UIButton(type: .system).then {
        $0.setTitle("필터", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    private let frameButton = UIButton(type: .system).then {
        $0.setTitle("액자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    private let adjustmentButton = UIButton(type: .system).then {
        $0.setTitle("조정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    private let stickerButton = UIButton(type: .system).then {
        $0.setTitle("스티커", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    
    private let emptyView1 = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let emptyView2 = UIView().then {
        $0.backgroundColor = .white
    }
    
    private var bottomToolBar = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.backgroundColor = .white
    }
    
    
    override func viewDidLoad() {
        setupNavigationItem()
        
        stickerView.delegate = self
            
        view.backgroundColor = .F6F6F8
        
        view.addSubview(exImage)
        exImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(504)
            $0.height.equalTo(648)
        }
        view.addSubview(bottomToolBar)
        view.addSubview(emptyView1)
        view.addSubview(emptyView2)
        
        bottomToolBar.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100.0)
        }
        
        bottomToolBar.addArrangedSubview(emptyView1)
        bottomToolBar.addArrangedSubview(filterButton)
        bottomToolBar.addArrangedSubview(frameButton)
        bottomToolBar.addArrangedSubview(adjustmentButton)
        bottomToolBar.addArrangedSubview(stickerButton)
        bottomToolBar.addArrangedSubview(emptyView2)
        
        emptyView1.snp.makeConstraints {
            $0.width.equalTo(emptyView2)
        }
        
        emptyView2.snp.makeConstraints {
            $0.width.equalTo(emptyView1)
        }
        
        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.filterButton)
                self?.applyFilter()
                self?.deselectButtons(except: self?.filterButton)
                self?.showFilterSelectionView()

            })
            .disposed(by: disposeBag)
        
        frameButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.frameButton)
                self?.applyFrame()
                self?.deselectButtons(except: self?.frameButton)
                self?.showFrameViewSelectionView()
            })
            .disposed(by: disposeBag)
        
        adjustmentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.adjustmentButton)
                self?.adjustPhoto()
                self?.deselectButtons(except: self?.adjustmentButton)
            })
            .disposed(by: disposeBag)
        
        stickerButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.toggleButton(owner.stickerButton)
                owner.applySticker()
                owner.deselectButtons(except: owner.stickerButton)
                owner.showStickerViewSelectionView()
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setupNavigationItem() {
        title = "보정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.BAA7E7
        
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                print("네비게이션 버튼이 클릭되었습니다.")
                let finishVC = FinishViewController()

                guard let navigationController = self.navigationController else {
                    fatalError("Navigation controller not found.")
                }

                navigationController.pushViewController(finishVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                                menu: menu)
    }
    
    func toggleButton(_ button: UIButton?) {
        button?.isSelected = !(button?.isSelected ?? false)
        button?.tintColor = button?.isSelected == true ? .black : nil
    }
    
    func deselectButtons(except selectedButton: UIButton?) {
        let buttonsToDeselect = [filterButton, frameButton, adjustmentButton, stickerButton].filter { $0 != selectedButton }
        buttonsToDeselect.forEach { $0?.isSelected = false }
        buttonsToDeselect.forEach { $0?.backgroundColor = .clear }
    }
    
    func applyFilter() {
        print("필터 버튼이 탭되었습니다.")
        hideFameViewSelectionView()
        hideStickerSelectionView()
    }
    
    func applyFrame() {
        print("액자 버튼이 탭되었습니다.")
        hideFilterSelectionView()
        hideStickerSelectionView()
    }
    
    func adjustPhoto() {
        print("조정 버튼이 탭되었습니다.")
        hideFilterSelectionView()
        hideFameViewSelectionView()
        hideStickerSelectionView()
    }
    
    func applySticker() {
        print("스티커 버튼이 탭되었습니다.")
        hideFilterSelectionView()
        hideFameViewSelectionView()
    }
    
    private func showFilterSelectionView() {
        controlView.alpha = 0.0
        view.addSubview(controlView)
        view.bringSubviewToFront(bottomToolBar)
        
        controlView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        controlView.transform = CGAffineTransform(translationX: 0, y: 300)
        
        self.controlView.alpha = 1.0
        self.controlView.transform = CGAffineTransform.identity
    }
    
    private func showFrameViewSelectionView() {
        frameView.alpha = 0.0
        view.addSubview(frameView)
        view.bringSubviewToFront(bottomToolBar)
        
        frameView.snp.makeConstraints {
            $0.left.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250.0)
        }
        
        frameView.transform = CGAffineTransform(translationX: 0, y: 300)
        
        self.frameView.alpha = 1.0
        self.frameView.transform = CGAffineTransform.identity
    }
    
    private func showStickerViewSelectionView() {
        stickerView.alpha = 0.0
        view.addSubview(stickerView)
        view.bringSubviewToFront(stickerView)
        
        stickerView.snp.makeConstraints {
            $0.left.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250.0)
        }
        
        stickerView.transform = CGAffineTransform(translationX: 0, y: 300)
        
        self.stickerView.alpha = 1.0
        self.stickerView.transform = CGAffineTransform.identity
    }
    
    private func hideFameViewSelectionView() {
        UIView.animate(withDuration: 0.3) {
            self.frameView.alpha = 0.0
        } completion: { _ in
            self.frameView.removeFromSuperview()
        }
    }
    
    private func hideFilterSelectionView() {
        UIView.animate(withDuration: 0.3) {
            self.controlView.alpha = 0.0
        } completion: { _ in
            self.controlView.removeFromSuperview()
        }
    }
    
    private func hideStickerSelectionView() {
        UIView.animate(withDuration: 0.3) {
            self.stickerView.alpha = 0.0
        } completion: { _ in
            self.stickerView.removeFromSuperview()
        }
    }
}

extension CorrectionViewController {
    // > 스티커 삭제 (꾹 눌러서 삭제)
    @objc func longPress(_ gesture : UILongPressGestureRecognizer){
        if gesture.state != .ended { return }
        
        let alert = UIAlertController(title: "해당 스티커를 삭제하시겠습니까?".localized(), message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "삭제".localized(), style: .destructive) {_ in
            gesture.view?.removeFromSuperview()}
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "취소".localized(), style: .cancel) { (cancel) in})
        self.present(alert, animated: true, completion: nil)
    }
    
    // 스티커 위치조절
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }

    
    // 스티커 크기 조절
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y:gesture.scale)
        gesture.scale = 1
    }
    
    // 스티커 회전
    @objc func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    // 동시에 여러 움직임 인식 가능
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func sendData(image: UIImage) {
        let imageSticker = UIImageView(image: image)
        let stickerSize = CGSize(width: 200, height: 200)
        let stickerOrigin = CGPoint(x: exImage.bounds.midX - stickerSize.width/2, y: exImage.bounds.midY - stickerSize.height/2)
        imageSticker.frame = CGRect(origin: stickerOrigin, size: stickerSize)
        imageSticker.image = image
        imageSticker.isUserInteractionEnabled = true
        imageSticker.contentMode = .scaleAspectFit
            
        self.exImage.addSubview(imageSticker)
        self.exImage.isUserInteractionEnabled = true
        self.exImage.clipsToBounds = true
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(_:)))
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotateGesture(_:)))
        let removeGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        
        [panGesture, pinchGesture, rotateGesture, removeGesture].forEach {
            $0.delegate = self
            imageSticker.addGestureRecognizer($0)
        }
    }


}
