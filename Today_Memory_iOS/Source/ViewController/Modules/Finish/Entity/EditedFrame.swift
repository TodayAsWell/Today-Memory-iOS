//
//  EditedFrame.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/29.
//

import Foundation
import UIKit

struct EditedFrame {
    var mainFrameView: UIView?
    var userImageView: UIImageView?
    var exImage: UIImageView?

    init(userImageView: UIImageView) {
        self.userImageView = userImageView
    }

    init(mainFrameView: UIView, userImageView: UIImageView, exImage: UIImageView) {
        self.mainFrameView = mainFrameView
        self.userImageView = userImageView
        self.exImage = exImage
    }
}
