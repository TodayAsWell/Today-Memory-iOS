//
//  IntroductionInteractor.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import Foundation
import UIKit

class IntroductionInteractor: IntroductionInteractorProtocol {
    weak var presenter: IntroductionPresenterProtocol!
    
    func fetchIntroductionData() {
        let introductionData = [
            IntroductionModel(title: "프리미엄\n필터", image: UIImage(named: "ExampleImage")!),
            IntroductionModel(title: "3D\n필터", image: UIImage(named: "ExampleImage")!),
            IntroductionModel(title: "사진\n보정", image: UIImage(named: "ExampleImage")!)
        ]
        presenter.introductionDataFetched(data: introductionData)
    }
}
