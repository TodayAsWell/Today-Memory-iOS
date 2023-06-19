//////
//////  IntroductionModel.swift
//////  TodayCamera
//////
//////  Created by 박준하 on 2023/06/01.
//////
////
import UIKit
import SnapKit
import Then

struct IntroductionModel {
    var title: String
    var image: UIImage

    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
}
