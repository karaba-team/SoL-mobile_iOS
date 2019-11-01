//
//  GameVC+CollectionView.swift
//  Karaba
//
//  Created by Andika Leonardo on 01/11/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragNDropItemCell", for: indexPath) as! DragNDropItemCell
        cell.testView.backgroundColor = UIColor(hexString: itemColor[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem(itemIndex: indexPath.row, frame : collectionView.layoutAttributesForItem(at: indexPath)!.frame)
    }
    
}
