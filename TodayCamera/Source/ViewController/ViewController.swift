import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    let toggleButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .center
    }
    
    let pictureToggleButton = UIButton().then {
        $0.setTitle("사진", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = .Yellow
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 19.0
    }
    
    let videoToggleButton = UIButton().then {
        $0.setTitle("동영상", for: .normal)
        $0.setTitleColor(UIColor.Gray4, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = .White
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 19.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupButtons()
        view.backgroundColor = .White
    }

    func setupStackView() {
        view.addSubview(toggleButtonStackView)
        toggleButtonStackView.snp.makeConstraints { make in
            make.width.equalTo(148)
            make.height.equalTo(76)
            make.center.equalToSuperview()
        }
    }

    func setupButtons() {
        [pictureToggleButton, videoToggleButton].forEach { button in
            toggleButtonStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(74)
                make.height.equalTo(38)
            }
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        pictureToggleButton.snp.makeConstraints { make in
            make.width.equalTo(videoToggleButton.snp.width)
        }

        videoToggleButton.snp.makeConstraints { make in
            make.width.equalTo(pictureToggleButton.snp.width)
        }

        toggleButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
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
