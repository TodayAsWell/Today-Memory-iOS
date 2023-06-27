import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class FinishViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    
    public var downloadWidth: Double = 100.0
    
    public var exImage = UIImageView().then {
        $0.image = UIImage(named: "ExPolaroid")
    }
    
    public var downloadButton = UIButton().then {
        $0.setImage(UIImage(named: "DownloadImage"), for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.Gray2.cgColor
        $0.layer.cornerRadius = 50.0
        $0.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        layout()
        
        downloadButton.imageView?.contentMode = .scaleAspectFit
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    private func setupNavigationItem() {
        title = "저장 완료!"
        view.backgroundColor = .F6F6F8
    }
}
