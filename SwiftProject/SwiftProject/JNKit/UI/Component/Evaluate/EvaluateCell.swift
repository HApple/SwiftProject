//
//  EvaluateCell.swift
//  SwiftProject
//
//  Created by Miles on 2021/8/4.
//

import UIKit
import Kingfisher
import SKPhotoBrowser //有BUG 无专场动画
import JXPhotoBrowser

class EvaluateCell: UITableViewCell {
    
    enum Appearance {
        static let hMargin:CGFloat = 8
        static let vMargin:CGFloat = 10
        static let hSpcae:CGFloat = 5
        static let vSpcae:CGFloat = 5
        static let HeaderViewHeight:CGFloat = 40
        static let contentFont: UIFont = UIFont.systemFont(ofSize: 13)
        
        static let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        static let minimumLineSpacing: CGFloat = 5
        static let minimumInteritemSpacing: CGFloat = 5
        static let imageWidth: CGFloat = (UIScreen.main.bounds.width - minimumLineSpacing * 2 - hMargin * 2) / 3
        static let imageItemSize: CGSize = CGSize(width: imageWidth, height: imageWidth)
    }

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imgCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var imgCollectionViewConstraintHeight: NSLayoutConstraint!
    
    
    var model: EvaluateModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        avatarImgView.layer.cornerRadius = 25 * 0.5
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.backgroundColor = .white
        imageCollectionView.showsVerticalScrollIndicator = false
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.register(EvaluateImageCell.self, forCellWithReuseIdentifier: "EvaluateImageCell")
        
        imgCollectionViewFlowLayout.minimumLineSpacing = Appearance.minimumLineSpacing
        imgCollectionViewFlowLayout.minimumInteritemSpacing = Appearance.minimumInteritemSpacing
        imgCollectionViewFlowLayout.sectionInset = Appearance.sectionInset
        imgCollectionViewFlowLayout.itemSize = Appearance.imageItemSize
        
        imgCollectionViewConstraintHeight.constant = 0
    }
}


extension EvaluateCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.imgURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EvaluateImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EvaluateImageCell", for: indexPath) as! EvaluateImageCell
        cell.imageURL = model.imgURLs?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            self.model.imgURLs?.count ?? 0
        }
        browser.reloadCellAtIndex = { context in
            let string = self.model.imgURLs?[context.index] ?? ""
            let url = URL(string: string)
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            let collectionPath = IndexPath(item: context.index, section: indexPath.section)
            let collectionCell = collectionView.cellForItem(at: collectionPath) as? EvaluateImageCell
            let placeholder = collectionCell?.imageView.image
            // 用 Kingfisher 加载
            browserCell?.imageView.kf.setImage(with: url, placeholder: placeholder)
        }
        browser.transitionAnimator = JXPhotoBrowserZoomAnimator(previousView: { index -> UIView? in
            let path = IndexPath(item: index, section: indexPath.section)
            let cell = collectionView.cellForItem(at: path) as? EvaluateImageCell
            return cell?.imageView
        })
        browser.pageIndex = indexPath.item
        browser.show()
        
        
        /*
        var images = [SKPhotoProtocol]()
        model.imgURLs?.forEach({ str in
            let photo = SKPhoto.photoWithImageURL(str)
            images.append(photo)
        })
       let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.row)
       browser.delegate = self
       self.parentViewController?.present(browser, animated: true, completion: {})
      */
    }
}

extension EvaluateCell:SKPhotoBrowserDelegate {
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        let cell = imageCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! EvaluateImageCell
        return cell.imageView
    }
}

extension EvaluateCell {
    
    public static func cellHeight(with model: EvaluateModel) -> CGFloat {
     
        var height = Appearance.vMargin
        
        height += Appearance.HeaderViewHeight
        
        height += Appearance.hSpcae
        let label = UILabel()
        label.text = model.content
        label.font = Appearance.contentFont
        label.width = UIScreen.main.bounds.width - Appearance.hMargin * 2
        height += label.jn.requiredHeight
        
        
        height += Appearance.hSpcae
        let imgCount = model.imgURLs?.count ?? 0
        height += imgColletionViewHeight(by: imgCount)

        return height
        
    }

    private static func imgColletionViewHeight(by imgCount:Int) -> CGFloat {
        if imgCount == 0 {
            return 0
        }else {
            let lineCount:Int = imgCount / 3 + (imgCount % 3 == 0 ? 0 : 1)
            var height = Appearance.sectionInset.top + Appearance.sectionInset.bottom
            height += (CGFloat(lineCount) * Appearance.imageItemSize.height) + (CGFloat(lineCount) - 1) * Appearance.minimumLineSpacing
            return height
        }
    }
    
    public func configure(with model: EvaluateModel) {
        self.model = model
        avatarImgView.kf.setImage(with: URL(string: model.avatarURL ?? ""))
        nickNameLabel.text = model.name
        contentLabel.text = model.content
        let imgCount:Int = model.imgURLs?.count ?? 0
        imgCollectionViewConstraintHeight.constant = Self.imgColletionViewHeight(by: imgCount)
        imageCollectionView.reloadData()
    }
}
