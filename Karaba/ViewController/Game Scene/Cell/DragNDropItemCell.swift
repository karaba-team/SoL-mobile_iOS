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
            testView.backgroundColor = .white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func drawShape(points: [CGPoint], scale: Int){
        let freeform = UIBezierPath()
//        freeform.move(to: .zero)
        freeform.move(to: points.first!)
        for point in points.dropFirst(){
            freeform.addLine(to: point)
        }
        
        let shape = CAShapeLayer()
        shape.path = freeform.cgPath
        shape.fillColor = UIColor.white.cgColor
        shape.strokeColor = UIColor.black.cgColor
        shape.lineWidth = 1
        
        
        let shapeHeight = freeform.cgPath.boundingBox.height
        let shapeWidth = freeform.cgPath.boundingBox.height
        
        let frameHeight = bounds.size.height
        let frameWidth = bounds.size.width
        print("shape :", shapeWidth, shapeHeight)
        print("frame :", frameWidth, frameHeight)
        
        let x = (frameWidth - shapeWidth) / 2
        let y = (frameHeight - shapeHeight) / 2
        
        shape.position = CGPoint(x: x, y: y)
        
        layer.addSublayer(shape)
    }

}
