import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SnapKit

class FilterCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
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
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(64)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
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
