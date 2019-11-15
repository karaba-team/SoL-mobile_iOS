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
    
    func setShape(_ shape: ShapeModel){
        
        print("CELL: PATH COUNT", shape.pathCount)
        print("CELL: PATH", shape.path)
        drawShape(points: shape.path, scale: 1)
    }
    
    func drawShape(points: [CGPoint], scale: Int){
        let freeform = UIBezierPath()
        let points = points.map { CGPoint(x: $0.x / 5, y: $0.y / 5) }
        freeform.move(to: points.first!)
        
        for point in points.dropFirst(){
            freeform.addLine(to: point)
        }
        freeform.close()
        
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
        
//        let x = (frameWidth - shapeWidth) / 2
//        let y = (frameHeight - shapeHeight) / 2
        let x = (self.frame.size.width/2) - (shapeWidth/2)
        let y = (self.frame.size.height/2) - (shapeHeight/2)
        
        shape.position = CGPoint(x: x, y: y)
        
        layer.addSublayer(shape)
    }
}
