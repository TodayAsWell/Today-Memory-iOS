//
//  IntroductionViewProtocol.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit

protocol IntroductionViewProtocol: AnyObject {
    var introductionData: [IntroductionModel] { get set }
    var currentPage: Int { get set }
    
    func scrollToPage(_ pageIndex: Int)
}
