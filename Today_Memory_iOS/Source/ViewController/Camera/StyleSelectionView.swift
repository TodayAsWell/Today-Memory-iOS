import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

protocol StyleSelectionViewDelegate: AnyObject {
    func didSelectStyleAt(index: Int)
}

class StyleSelectionView: UIView {
    
    weak var delegate: StyleSelectionViewDelegate?
    
    let closeButton = UIButton().then {
        let image = UIImage(named: "closeImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let centerButton = UIButton(type: .system).then {
        let image = UIImage(named: "centerButton")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(centerButton)
        centerButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(60)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(centerButton.snp.top).offset(-20.0)
            $0.height.equalTo(100)
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(38.0)
            $0.trailing.equalToSuperview().offset(-55)
            $0.height.width.equalTo(24.0)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StyleCollectionViewCell.self, forCellWithReuseIdentifier: "StyleCollectionViewCell")
    }
}

extension StyleSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StyleCollectionViewCell", for: indexPath) as! StyleCollectionViewCell
                
        switch indexPath.row {
        case 0:
            cell.imageView.image = UIImage(named: "MiniThoughtImage")
            cell.imageView.layer.borderWidth = 2
            cell.imageView.layer.borderColor = UIColor(named: "EAEAFC")?.cgColor
        default:
            cell.imageView.backgroundColor = .red
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectStyleAt(index: indexPath.row)
    }
}
