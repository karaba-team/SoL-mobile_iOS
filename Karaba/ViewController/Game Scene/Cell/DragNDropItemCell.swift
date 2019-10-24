//
//  DragNDropItemCell.swift
//  Karaba
//
//  Created by Ferry Irawan on 24/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import UIKit

class DragNDropItemCell: UICollectionViewCell {

    @IBOutlet weak var testView: UIView!{
        didSet{
            testView.backgroundColor = .red
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
