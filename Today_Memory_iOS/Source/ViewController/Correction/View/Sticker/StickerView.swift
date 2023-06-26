import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

protocol SendDataDelegate {
    func sendData(image:UIImage)
    func removeAllStickers()
}

class StickerView: UIView {
    
    let categorySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["전체", "감정", "식물", "사람"])
        segmentedControl.addTarget(self, action: #selector(categorySegmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()

    
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
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cellData = ["blackHartSticker","blackFlowerSticker","blackJapaneseFlower","pinkHartSticker","pinkFlowerSticker","pinkJapaneseFlower","purpleHartSticker","purpleFlowerSticker","purpleJapaneseFlower","gradationHartSticker","gradationFlowerSticker","gradationJapaneseFlower", "goodWonjunSticker", "재하"] {
        didSet {
            collectionView.reloadData()
        }
    }
    var delegate : SendDataDelegate?
    
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

        addSubview(categorySegmentedControl)
        categorySegmentedControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }

        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categorySegmentedControl.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }

        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func closeButtonTapped() {
        removeFromSuperview()
    }
    
    @objc private func categorySegmentedControlValueChanged() {
        switch categorySegmentedControl.selectedSegmentIndex {
        case 0:
            //모두 보기
            cellData = ["blackHartSticker","blackFlowerSticker","blackJapaneseFlower","pinkHartSticker","pinkFlowerSticker","pinkJapaneseFlower","purpleHartSticker","purpleFlowerSticker","purpleJapaneseFlower","gradationHartSticker","gradationFlowerSticker","gradationJapaneseFlower", "goodWonjunSticker", "재하"]
        case 1:
            //감정
            cellData = ["pinkHartSticker","blackHartSticker","purpleHartSticker", "gradationHartSticker"]
        case 2:
            //식물
            cellData = ["pinkFlowerSticker", "blackFlowerSticker", "purpleFlowerSticker", "gradationJapaneseFlower", "pinkJapaneseFlower" , "blackJapaneseFlower", "purpleJapaneseFlower", "gradationJapaneseFlower"]
        case 3:
            //사람
            cellData = ["goodWonjunSticker", "재하"]
        default:
            break
        }
        
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.id)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42)
        }
    }
}

extension StickerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.id, for: indexPath) as! StickerCollectionViewCell
        
        let sticker = UIImage(named: cellData[indexPath.row])!
        cell.setupCell(sticker: sticker)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("index \(indexPath.row)")
        let image = cellData[indexPath.row]
        delegate?.sendData(image:UIImage(named: image)!)
    }
}
