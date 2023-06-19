//
//  IntroductionPresenterProtocol.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit

protocol IntroductionPresenterProtocol: AnyObject {
    var view: IntroductionViewProtocol? { get set }
    var interactor: IntroductionInteractorProtocol! { get set }
    var router: IntroductionRouterProtocol! { get set }
    
    func loadData()
    func nextButtonTapped()
    func introductionDataFetched(data: [IntroductionModel])
    func pageControlValueChanged(pageIndex: Int)
    func scrollViewDidEndDecelerating(pageIndex: Int)
}
