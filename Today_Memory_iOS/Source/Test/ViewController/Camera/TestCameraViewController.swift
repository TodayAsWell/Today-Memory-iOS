//
//  TestCameraViewController.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/16.
//

import UIKit
import SnapKit
import Then

class TestCameraViewController: UIViewController {
    
    var cameraView: XCamera!
    var gridView: XGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView = XCamera(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.addSubview(cameraView)
        
        cameraView.setAspectRatio(.square)
        cameraView.setBackgroundColor(.white)
        cameraView.setFlashMode(.off)
        cameraView.setCameraPosition(.back)
        
        gridView = XGridView(frame: cameraView.frame)
        gridView.isUserInteractionEnabled = false
        view.addSubview(gridView)
        
        cameraView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(500.0)
        }
        
        cameraView.startRunning()
        updateGridViewSize()
    }
    
    func updateGridViewSize() {
        let cameraViewSize = cameraView.frame.size
        let gridSize = CGSize(width: cameraViewSize.width, height: cameraViewSize.width)
        let gridOrigin = CGPoint(x: cameraView.frame.origin.x, y: cameraView.frame.origin.y + (cameraViewSize.height - gridSize.height) / 2)
        gridView.frame = CGRect(origin: gridOrigin, size: gridSize)
    }
}
