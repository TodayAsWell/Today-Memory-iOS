//
//  IntroductionView.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class IntroductionView: UIViewController, IntroductionViewProtocol, UIScrollViewDelegate {
    
    var presenter: IntroductionPresenterProtocol!
    
    var mainCollectionView: UICollectionView!
    var introductionData: [IntroductionModel] = []
    
    var nextButton = UIButton().then {
        $0.setTitle("계속", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.backgroundColor = .yellow
    }
    var pageControl = UIPageControl()
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == introductionData.count - 1 {
                nextButton.setTitle("시작", for: .normal)
            } else {
                nextButton.setTitle("계속", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter.nextButtonTapped()
            })
        
        setUI()
        setCollectionView()
        layout()
        presenter.loadData()
        
        pageControl.numberOfPages = introductionData.count
        pageControl.currentPage = 0
        pageControl.tintColor = .yellow
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .yellow
    }
    
    func layout() {
        view.addSubview(mainCollectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        mainCollectionView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(700.0)
            $0.width.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainCollectionView.snp.bottom).offset(40.0)
            $0.height.equalTo(42.0)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-68.0)
            $0.width.equalTo(350.0)
            $0.height.equalTo(60.0)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
        presenter.scrollViewDidEndDecelerating(pageIndex: pageIndex)
    }

    private func scrollToPage(_ pageIndex: Int) {
        guard pageIndex >= 0 && pageIndex < introductionData.count else {
            return
        }
        
        let indexPath = IndexPath(item: pageIndex, section: 0)
        mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        scrollToPage(sender.currentPage)
        presenter.pageControlValueChanged(pageIndex: sender.currentPage)
    }
}
