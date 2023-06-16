//
//  TestViewController.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/15.
//

import UIKit
import SnapKit
import Then

class TestViewController: UIViewController {
    
    private var exView1 = UIImageView().then {
        $0.image = UIImage(named: "dagImage")
    }
    
    private var exView2 = UIImageView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 200.0
    }
    
    private lazy var testLabel = UILabel().then {
        $0.text = "박준하"
        $0.font = .systemFont(ofSize: 60, weight: .semibold)
        $0.numberOfLines = 2
        $0.textColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        view.addSubview(exView2)
        view.addSubview(testLabel)
        view.addSubview(exView1)
        exView2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(166.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(400.0)
        }
        
        testLabel.snp.makeConstraints {
            $0.top.equalTo(exView2.snp.bottom).offset(60.0)
            $0.centerX.equalToSuperview()
        }
        
        exView1.snp.makeConstraints {
            $0.top.equalTo(testLabel.snp.bottom).offset(155.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(200.0)
            $0.width.equalTo(600.0)
        }
    }
}
