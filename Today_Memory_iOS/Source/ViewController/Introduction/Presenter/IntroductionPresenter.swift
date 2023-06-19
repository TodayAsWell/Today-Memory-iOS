//
//  IntroductionPresenter.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit

class IntroductionPresenter: IntroductionPresenterProtocol {
    
    weak var view: IntroductionViewProtocol?
    var interactor: IntroductionInteractorProtocol!
    var router: IntroductionRouterProtocol!
    
    func loadData() {
        interactor.fetchIntroductionData()
    }
    
    func nextButtonTapped() {
        if view?.currentPage == view?.introductionData.count - 1 {
            router.navigateToMain()
        } else {
            view?.currentPage += 1
            view?.scrollToPage(view!.currentPage)
        }
    }
    
    func introductionDataFetched(data: [IntroductionModel]) {
        view?.introductionData = data
        view?.mainCollectionView.reloadData()
    }
    
    func pageControlValueChanged(pageIndex: Int) {
        view?.scrollToPage(pageIndex)
    }
    
    func scrollViewDidEndDecelerating(pageIndex: Int) {
        view?.currentPage = pageIndex
    }
}
