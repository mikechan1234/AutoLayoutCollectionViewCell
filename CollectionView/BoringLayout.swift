//
//  BoringLayout.swift
//  CollectionView
//
//  Created by Chan, Michael(AWF) on 04/07/2017.
//  Copyright © 2017 eBay Inc. All rights reserved.
//

import Foundation

import UIKit

class BoringLayout: UICollectionViewLayout {
    
    var itemHeight: CGFloat = 50
    var spacing: CGFloat = 10
    private var width: CGFloat = 0
    private var numberOfItems = 0
    
    var heightCache = [Int: CGFloat]()
    
    // Prepare is called before any of the layout is calculated
    override func prepare() {
        print(#function)
        super.prepare()
        self.width = self.collectionView?.bounds.width ?? 0
        self.numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    override var collectionViewContentSize: CGSize {
        print(#function)
        // This layout only supports one section
        
        let value = (0..<self.numberOfItems).reduce(0) { (result, value) -> CGFloat in
            
            if let cachedHeight = heightCache[value] {
                
                return result + cachedHeight + spacing
                
            } else {
                
                return result + itemHeight + spacing
                
            }
            
        }
        
        return CGSize(width: self.width, height: value)
        
    }
    
    // This function is called periodically, using rects that the collection view is asking for.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(#function)
        
        // You could optimise here by not checking every single index path in the collection view, for example
        let attributes: [UICollectionViewLayoutAttributes] = (0..<self.numberOfItems).flatMap {
            
            let indexPath = IndexPath(item: $0, section: 0)
            
            let frame = self.frame(for: indexPath)
            if !frame.intersects(rect) {
                return nil
            }
            
            return self.layoutAttributesForItem(at: indexPath)
            
        }
        
        return attributes
    }
    
    private func frame(for indexPath: IndexPath) -> CGRect {
        // Now we can't use a constant height for each frame, so must calculate from the cache
        let heightsTillNow: CGFloat = (0..<indexPath.item).reduce(0) {
            return $0 + self.spacing + (self.heightCache[$1] ?? self.itemHeight)
        }
        
        return CGRect(x: 0, y: heightsTillNow, width: self.width, height: self.heightCache[indexPath.item] ?? self.itemHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(#function)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = self.frame(for: indexPath)
        return attributes
    }
    
    override public func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        
        print(#function)
        // Do we have a recorded size for this item?
        let index = originalAttributes.indexPath.item
        if let height = self.heightCache[index], height == preferredAttributes.size.height {
            return false
        } else {
            return true
        }
    }
    
    override public func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        print(#function)
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        
        let oldContentSize = self.collectionViewContentSize
        self.heightCache[originalAttributes.indexPath.item] = preferredAttributes.size.height
        let newContentSize = self.collectionViewContentSize
        context.contentSizeAdjustment = CGSize(width: 0, height: newContentSize.height - oldContentSize.height)
        // If an item has changed size, the layout of everything underneath it has also been invalidated.
        let indexPaths: [IndexPath] = (originalAttributes.indexPath.item..<self.numberOfItems).map {
            return IndexPath(item: $0, section: 0)
        }
        context.invalidateItems(at: indexPaths)
        
        return context
    }
}
