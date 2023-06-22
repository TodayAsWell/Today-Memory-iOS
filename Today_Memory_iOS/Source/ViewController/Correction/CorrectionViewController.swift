import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class CorrectionViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private let controlView = ControlView()
    private let frameView = FrameView()
    
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
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.stickerButton)
                self?.applySticker()
                self?.deselectButtons(except: self?.stickerButton)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setupNavigationItem() {
        title = "보정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.BAA7E7
        
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
    }
    
    func applyFrame() {
        print("액자 버튼이 탭되었습니다.")
        hideFilterSelectionView()
    }
    
    func adjustPhoto() {
        print("조정 버튼이 탭되었습니다.")
        hideFilterSelectionView()
        hideFameViewSelectionView()
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
}
