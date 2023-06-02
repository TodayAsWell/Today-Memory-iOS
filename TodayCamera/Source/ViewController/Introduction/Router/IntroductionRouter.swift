//
//  IntroductionRouter.swift
//  TodayCamera
//
//  Created by 박준하 on 2023/06/02.
//

import UIKit

class IntroductionRouter: IntroductionRouterProtocol {
    weak var view: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = IntroductionView()
        let presenter = IntroductionPresenter()
        let interactor = IntroductionInteractor()
        let router = IntroductionRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
    
    func navigateToMain() {
        // Implement your navigation logic here to navigate to the main screen.
        print("Go to main")
    }
}
