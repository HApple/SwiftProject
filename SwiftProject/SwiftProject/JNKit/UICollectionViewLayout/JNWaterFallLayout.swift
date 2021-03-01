//
//  JNWaterFallLayout.swift
//  SwiftProject
//
//  Created by hjn on 2021/2/19.
//

import UIKit


protocol JNWaterFallLayoutDataSource {
    /// 获取item高度， 返回itemWidth 和 indexPath去获取
    func waterFallLayoutItemHeight(layout: JNWaterFallLayout, itemWidth: CGFloat, indexPath: IndexPath) -> CGFloat
}

class JNWaterFallLayout: UICollectionViewLayout {
    
    var dataSource: JNWaterFallLayoutDataSource?

    /// 总共有多少列，默认为2
    var column: Int = 2
    /// 列间距，默认为0
    var columnSpcaing:CGFloat = 0.0
    /// 行间距
    var rowSpacing:CGFloat = 0.0
    /// section与collectionView的间距，默认是（0,0,0,0）
    var sectionInset: UIEdgeInsets = .zero
    
    /// 根据设置的列数， 列间距，返回itemWidth
    private var itemWidth:CGFloat {
        let collectionViewWidth = collectionView?.frame.size.width ?? 0
        // 减去间距
        let width = (collectionViewWidth - sectionInset.left - sectionInset.right - columnSpcaing * CGFloat((column - 1)))
        // 均分
        let itemWidth = width / CGFloat(column)
        return itemWidth
    }
    /// 用于记录每一行的最大值
    private var maxYDic:[Int:CGFloat] = [:]
    private var attributesArray:[UICollectionViewLayoutAttributes] = []
    
    convenience init(column: Int) {
        self.init()
        self.column = column
    }
}


// MARK: - Layout Override 布局必须重写的方法
extension JNWaterFallLayout {

    /// 1. 初始化数据源
    override func prepare() {
        super.prepare()
        attributesArray.removeAll()
        // 初始化字典， 有几列就有几个键值对，key为列，value为列的最大y值
        // 初始值为上内边距
        for i in 0..<column {
            maxYDic[i] = sectionInset.top
        }
        // 获取item总数
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        // 为每个Item创建attributes存入数组中
        for i in 0..<itemCount {
            // 循环调用2去计算item attribute
            guard let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0)) else { return }
            attributesArray.append(attributes)
        }
    }
    
    
    /// 2. 计算每个Attribute
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let height = dataSource?.waterFallLayoutItemHeight(layout: self, itemWidth: itemWidth, indexPath: attributes.indexPath)
        guard let itemHeight = height else {
            print("you must implement JNWaterFallLayoutDataSource methods - Warning : 需要重写瀑布流的返回高度代理方法!")
            return nil
        }
        
        // 找出最短一列
        var minIndex:Int = 0
        for item in maxYDic {
            if item.value < (maxYDic[minIndex] ?? 0) {
                minIndex = item.key
            }
        }
        // 根据最短列去计算itemX
        let itemX = sectionInset.left + (columnSpcaing + itemWidth) * CGFloat(minIndex)
        var itemY:CGFloat = 0
        if column == 1 {
            // 一列情况
            if indexPath.row == 0 {
                itemY = maxYDic[minIndex] ?? 0
            }else {
                itemY = (maxYDic[minIndex] ?? 0) + rowSpacing
            }
        }else {
            // 瀑布流多列情况
            // 第一行 Cell 不需要添加 rowSpacing, 对应的indexPath.row < column
            if indexPath.row < column {
                itemY = maxYDic[minIndex] ?? 0
            }else {
                itemY = (maxYDic[minIndex] ?? 0) + rowSpacing
            }
        }
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        // 更新maxY
        maxYDic[minIndex] = attributes.frame.maxY
        return attributes
    }
    
    /// 3. 返回数据源
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    /// 4. 返回itemSize
    override var collectionViewContentSize: CGSize {
        // 找出最长一列
        var maxIndex:Int = 0
        for item in maxYDic {
            if item.value > maxYDic[maxIndex] ?? 0 {
                maxIndex = item.key
            }
        }
        let contentSizeY = sectionInset.bottom + (maxYDic[maxIndex] ?? 0)
        return CGSize(width: collectionView?.frame.size.width ?? 0, height: contentSizeY)
    }
}


