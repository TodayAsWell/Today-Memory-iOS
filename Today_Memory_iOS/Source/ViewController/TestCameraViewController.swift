import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    private var photoButton: UIButton!
    private var videoButton: UIButton!
    private var layout: UIStackView!
    private var isPhotoSelected: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        view.backgroundColor = .white
    }

    private func setupUI() {
        photoButton = UIButton().then {
            $0.setTitle("Photo", for: .normal)
            $0.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        }

        videoButton = UIButton().then {
            $0.setTitle("Video", for: .normal)
            $0.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        }

        layout = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 20

            // Photo 버튼을 추가
            $0.addArrangedSubview(photoButton)

            // Video 버튼을 추가하지만 초기에는 숨김 처리
            $0.addArrangedSubview(videoButton)
            videoButton.isHidden = true

            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(view)
                make.centerY.equalTo(view)

                // Photo 버튼을 중앙에 위치
                make.left.equalTo(photoButton.snp.right).offset(isPhotoSelected ? 0 : 20)
            }
        }
    }

    @objc private func photoButtonTapped() {
        if !isPhotoSelected {
            isPhotoSelected = true
            layout.snp.updateConstraints { make in
                make.left.equalTo(photoButton.snp.right).offset(0)
            }
        }
    }

    @objc private func videoButtonTapped() {
        if isPhotoSelected {
            isPhotoSelected = false
            layout.snp.updateConstraints { make in
                make.left.equalTo(photoButton.snp.right).offset(20)
            }
        }
    }
}
