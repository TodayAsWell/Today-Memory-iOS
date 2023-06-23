import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

protocol FrameViewDelegate: AnyObject {
    func didSelectFrameImage(image: UIImage)
}

class FrameView: UIView {
    
    weak var delegate: FrameViewDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        layout.itemSize = CGSize(width: 100, height: 220)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
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
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(220)
        }
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FrameCollectionViewCell.self, forCellWithReuseIdentifier: "FrameCollectionViewCell")
    }
}

extension FrameView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameCollectionViewCell", for: indexPath) as! FrameCollectionViewCell
        
        cell.imageView.image = UIImage(named: "FameImage")
        cell.titleLabel.text = "Flower"
        
        if indexPath.row == 1 {
            cell.imageView.image = UIImage(named: "EXBlackDesignFrame")
            cell.titleLabel.text = "balckPainting"
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("index \(indexPath.row)")
        var selectedImage = UIImage(named: "ExPolaroid")
        
        switch indexPath.row {
        case 0:
            selectedImage = UIImage(named: "ExPolaroid")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 1:
            selectedImage = UIImage(named: "blackDesignFrame")
            delegate?.didSelectFrameImage(image: selectedImage!)
            
        default:
            selectedImage = UIImage(named: "ExPolaroid")
            delegate?.didSelectFrameImage(image: selectedImage!)
        }
    }
}
