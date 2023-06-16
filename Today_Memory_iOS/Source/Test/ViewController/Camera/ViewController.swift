import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterSelectionView: UIView {
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)  // 흑색으로 변경
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white  // 흰색으로 변경

        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}

class CameraViewController: UIViewController {
    private let filterSelectionView = FilterSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        // 카메라 뷰 설정 코드

        // 필터 선택 뷰 초기화
        filterSelectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 200)
        view.addSubview(filterSelectionView)
        view.backgroundColor = .lightGray  // 밝은 회색으로 변경

        // 필터 선택 버튼 추가
        let filterButton = UIButton()
        filterButton.setTitle("필터 선택", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)  // 흑색으로 변경
        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterSelectionView()
            })

        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }

        // 필터 선택 뷰 닫기 버튼 동작 설정
        filterSelectionView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hideFilterSelectionView()
            })
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
