import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SnapKit

class StyleCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        updateSelectionStyle()
    }
    
    private func updateSelectionStyle() {
        let borderWidth: CGFloat = isSelected ? 4 : 0
        let borderColor: UIColor = isSelected ? .yellow : .clear
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.cgColor
    }
}
