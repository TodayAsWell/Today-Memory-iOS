//
//  IntroductionInteractorProtocol.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit

protocol IntroductionInteractorProtocol: AnyObject {
    var presenter: IntroductionPresenterProtocol! { get set }
    
    func fetchIntroductionData()
}
