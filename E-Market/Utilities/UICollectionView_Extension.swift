//
//  UICollectionView_Extension.swift
//  E-Market
//
//  Created by Kaushik Makwana on 11/01/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        guard let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect) else {
            return []
        }
        return allLayoutAttributes.map { $0.indexPath }
    }
    
    open func register<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }
    
    open func register<T: UICollectionReusableView>(header aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionHeader
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }
    
    open func register<T: UICollectionReusableView>(footer aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionFooter
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }
    
    open func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    open func dequeue<T: UICollectionReusableView>(header aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: type(of: aClass))
        let kind = UICollectionView.elementKindSectionHeader
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: name,
            for: indexPath
        ) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    open func dequeue<T: UICollectionReusableView>(footer aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: type(of: aClass))
        let kind = UICollectionView.elementKindSectionFooter
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: name,
            for: indexPath
        ) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}
