import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class StickerView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        layout.itemSize = CGSize(width: 100, height: 100)
        
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
        collectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.id)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumInteritemSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42)
        }
    }
}

extension StickerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.id, for: indexPath) as! StickerCollectionViewCell
        
        cell.imageView.image = UIImage(named: "blackHartSticker")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("index \(indexPath.row)")
    }
}
