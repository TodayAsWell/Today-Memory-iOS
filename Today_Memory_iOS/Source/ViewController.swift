//
//  ViewController.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/07/11.
//

import UIKit
import BSImagePicker
import Photos
import SnapKit
import Then

class ViewController1: UIViewController {
    
    lazy var addButton = UIButton().then {
        $0.setTitle("Add Photo", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
    }

    lazy var logoLabel = UILabel().then {
        $0.text = "Stay With Us"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.adjustsFontSizeToFitWidth = true
    }

    // ... 다른 UI 구성요소 및 코드 ...

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        if logoLabel.adjustsFontSizeToFitWidth == false{
            logoLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @objc func addPhoto() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 4
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true
     
        
        
        self.presentImagePicker(imagePicker, select: {(asset) in print("Selected \(asset)")
        }, deselect: {(asset) in print("Deselected \(asset)")
        },cancel: {(asset) in print("Cancled with selections: \(asset)")
        }, finish: {(asset) in print("Finished with selections : \(asset)")
            for i in 0..<4{
                self.imgViews[i].image = self.AssetsToImage(assets: asset[i])

            }
        
        })
    }

    fileprivate func setupUI() {
        // addButton UI
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }

        // logoLabel UI
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).offset(-20)
        }

        // ... 다른 UI 구성요소 추가 ...
    }

    // ... 다른 함수 및 구현 ...
}
