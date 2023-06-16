//
//  IntroductionRouterProtocol.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit

protocol IntroductionRouterProtocol: AnyObject {
    var view: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateToMain()
}
