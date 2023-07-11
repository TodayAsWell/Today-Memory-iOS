import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SingleFinishViewController: UIViewController, FinishViewInterface {
//    var presenter: FinishPresenterInterface!
    
    private var disposeBag = DisposeBag()
    
    private var downloadWidth: Double = 100.0
    
    private var mainFrameView: UIView
    private var userImageView: UIImageView
    private var exImage: UIImageView
    
    private var editedFrame: EditedFrame
    
    init(editedFrame: EditedFrame) {
        self.editedFrame = editedFrame
        self.mainFrameView = editedFrame.mainFrameView!
        self.userImageView = editedFrame.userImageView!
        self.exImage = editedFrame.exImage!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var downloadButton = UIButton().then {
        $0.setImage(UIImage(named: "DownloadImage"), for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.Gray2.cgColor
        $0.layer.cornerRadius = 50.0
        $0.isEnabled = true
    }
    
    private func saveImageToGallery() {
        let screenBounds = UIScreen.main.bounds
        let adjustedWidth = screenBounds.width
        let adjustedHeight = adjustedWidth
        let rendererSize = CGSize(width: adjustedWidth, height: adjustedHeight)

        let canvasRenderer = UIGraphicsImageRenderer(size: rendererSize)

        let imageToCombine = canvasRenderer.image { rendererContext in
            UIGraphicsBeginImageContextWithOptions(rendererSize, false, 0.0)

            let context = rendererContext.cgContext
            
            context.setFillColor(UIColor.white.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: adjustedWidth, height: adjustedHeight))

            let mainFrameCenterX = (adjustedWidth - mainFrameView.bounds.width) / 2.0
            let mainFrameCenterY = (adjustedHeight - mainFrameView.bounds.height) / 2.0
            context.translateBy(x: mainFrameCenterX, y: mainFrameCenterY)
            mainFrameView.layer.render(in: context)
            context.translateBy(x: -mainFrameCenterX, y: -mainFrameCenterY)

            let centerX = (adjustedWidth - userImageView.bounds.width) / 2.0
            let centerY = (adjustedHeight - userImageView.bounds.height) / 2.0
            context.translateBy(x: centerX, y: centerY)
            userImageView.layer.render(in: context)
            exImage.layer.render(in: context)

            UIGraphicsEndImageContext()
        }
        

        UIImageWriteToSavedPhotosAlbum(imageToCombine, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        print("Save image to gallery")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter.viewDidLoad()
        
        downloadButton.rx.tap
            .subscribe(with: self, onNext: { [weak self] _,_   in
                guard let self = self else { return }
                self.saveImageToGallery()
            })
            .disposed(by: disposeBag)
        setupNavigationItem()
        layout()
    }
    
    func setupNavigationItem() {
        title = "저장 완료!"
        view.backgroundColor = .F6F6F8
    }

    func layout() {
        view.addSubview(mainFrameView)
        view.addSubview(userImageView)
        view.addSubview(exImage)
        view.addSubview(downloadButton)
    
        downloadButton.imageView?.contentMode = .scaleAspectFit
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        mainFrameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(504)
            $0.height.equalTo(648)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(mainFrameView.snp.top).offset(30)
            $0.centerX.equalTo(mainFrameView.snp.centerX)
            $0.height.equalTo(462.0)
            $0.width.equalTo(443.0)
        }
        
        exImage.snp.makeConstraints {
            $0.top.equalTo(mainFrameView.snp.top)
            $0.centerX.equalTo(mainFrameView.snp.centerX)
            $0.width.equalTo(504)
            $0.height.equalTo(648)
        }
        
        downloadButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64.0)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100.0)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: "Failed to save image to gallery: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("실패")
        } else {
            let alert = UIAlertController(title: "Success", message: "Image saved to gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("성공")
        }
    }
}

extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
