import Foundation
import UIKit

extension FinishViewController {
    
    func layout() {
        view.addSubview(exImage)
        view.addSubview(downloadButton)

        exImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(504)
            $0.height.equalTo(648)
        }
        
        downloadButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64.0)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100.0)
        }
    }
}
