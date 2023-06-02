import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .center
    }
    
    let button1 = UIButton().then {
        $0.setTitle("사진", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = .Yellow
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 19.0
    }
    
    let button2 = UIButton().then {
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
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalTo(148)
            make.height.equalTo(76)
            make.center.equalToSuperview()
        }
    }

    func setupButtons() {
        [button1, button2].forEach { button in
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(74)
                make.height.equalTo(38)
            }
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        button1.snp.makeConstraints { make in
            make.width.equalTo(button2.snp.width)
        }

        button2.snp.makeConstraints { make in
            make.width.equalTo(button1.snp.width)
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if sender.isSelected {
            return
        }

        button1.isSelected = (sender == button1)
        button2.isSelected = (sender == button2)

        button1.backgroundColor = button1.isSelected ? .Yellow : .White
        button2.backgroundColor = button2.isSelected ? .Yellow : .White
        // 버튼 타이틀 색상 변경
        let button1TitleColor: UIColor = button1.isSelected ? .black : .Gray4
        let button2TitleColor: UIColor = button2.isSelected ? .black : .Gray4
        button1.setTitleColor(button1TitleColor, for: .normal)
        button2.setTitleColor(button2TitleColor, for: .normal)
    }
}
