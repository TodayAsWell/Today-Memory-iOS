//
//  ViewController.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/05/18.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var introductionData: [IntroductionModel] = []
    var nextButton = UIButton()
    var pageControl = UIPageControl()
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == introductionData.count - 1 {
                nextButton.setTitle("Start", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func layout() {
        
    }
}
