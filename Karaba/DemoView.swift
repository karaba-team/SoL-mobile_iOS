//
//  DemoView.swift
//  Karaba
//
//  Created by Rem Remy on 14/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import UIKit

protocol MyViewDelegate {
    func viewString() -> String;
}

class DemoView: UIView {

//    var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
//    var dotCoor = [xYCoor]()
    var tappedDots = [Array<Int>]()
    let drawTest = UIBezierPath()
    var touchesTest = Set<UITouch>()
    var indexTappedDot = 0
     
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        print("dari view \(xy)")
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func calculateIndexPoint(index: Int) -> CGPoint{
        let size = xy[1].dotSize
        let halfsize: Double = Double(size/2)
        
        let xPoint: Double = Double(xy[index].x) + halfsize
        let yPoint: Double = Double(xy[index].y) + halfsize
        
        return CGPoint(x: xPoint, y: yPoint)
    }
    
    func drawLine2(points: Array<Int>, strokeColor: UIColor){
            guard let context = UIGraphicsGetCurrentContext() else {return}
            
        if points.count < 4 {
            return
        }
        
        if points.first != points.last {
            return
        }
        
            context.move(to: calculateIndexPoint(index: points.first!))
        
            points.dropFirst().forEach { point in
                context.addLine(to: calculateIndexPoint(index: point))
            }
            
            context.setStrokeColor(strokeColor.cgColor)
            context.strokePath()
            
            context.closePath()
            
    //        tappedDots = [Set<Int>]()
        
    //        context.setFillColor(UIColor.black.cgColor)
    //        context.fillPath()

    //        path.close()


    //        fillColor.setFill()
    //        strokeColor.setStroke()

    //        path.fill()
    //        path.stroke()
        }
    
    override func draw(_ rect: CGRect) {
//        createRectangle()
        if !tappedDots.isEmpty {
//            drawLine2(points: tappedDots[indexTappedDot], strokeColor: .blue)
            drawLine2(points: tappedDots.last!, strokeColor: .blue)
//            tappedDots.forEach { dots in
//                print("dotsDraw", dots)
//                drawLine2(points: dots, strokeColor: .blue)
//            }
            print("")
        }
//        if !tappedDots.isEmpty && tappedDots[indexTappedDot].count<=2
    }
    

    
    func addDotIndex(x : Int, y : Int, touchBegin: Bool = false, touchEnded: Bool = false){
        for data in xy{
            if (data.x + 10 >= x && data.x - 10 <= x) && (data.y + 10 >= y && data.y - 10 <= y){
                let index = data.dotIndex-1
                
                if touchBegin {
//                    if tappedDots.isEmpty == true{
                        tappedDots.append([index])
//                        print("masuk nih berarti \(tappedDots[0])")
//                    }
//                    } else if tappedDots[tappedDots.count-1].last == index{
//                        lastTappedDots.append(index)
//                        tappedDots.append(lastTappedDots)
//                        print("masukin yg dah ga kosong")
//                    }


                    return
                }
                
                guard var lastTappedDots = tappedDots.popLast() else {
                    return
                }
                
//                if tappedDots.count == 0{
//                    tappedDots.append([index])
//                    print("masuk yang terakhir \(tappedDots[0])")
//                    print("tap yg terakhir\(tappedDots[tappedDots.count-1].last!) index\(index)")
//                } else if tappedDots[tappedDots.count-1].last! == index{
                lastTappedDots.append(index)
                var uniqDot = uniq(source: lastTappedDots)
//                uniqDot.append(uniqDot.first!)
                
                if touchEnded {
                    uniqDot.append(index)
                }
                
                tappedDots.append(uniqDot)
//                if tappedDots[indexTappedDot].last != tappedDots[indexTappedDot].first{
//                    tappedDots[indexTappedDot].append(tappedDots[indexTappedDot].first!)
//                }
                print("indexTappedDot \(indexTappedDot)")
                
//                }
                
                
                
                print("bacot", data.dotIndex)
            }
        }
    }
    
    func addLastDotIndex(x : Int, y : Int, touchBegin: Bool = false){
        for data in xy{
            if (data.x + 10 >= x && data.x - 10 <= x) && (data.y + 10 >= y && data.y - 10 <= y){
                let index = data.dotIndex-1
                
                tappedDots[indexTappedDot].append(index)
            }
        }
    }
    
    func checkDotIndex(x : Int, y : Int)-> Int{
        for data in xy{
            if (data.x + 10 >= x && data.x - 10 <= x) && (data.y + 10 >= y && data.y - 10 <= y){
                let index = data.dotIndex-1
                
                return index
            }
        }
        return 0
    }
    
    func checkDotPosition(x : Int, y : Int)-> Bool{
        for data in xy{
            if (data.x + 10 >= x && data.x - 10 <= x) && (data.y + 10 >= y && data.y - 10 <= y){
                return true
            }
        }
        return false
        print("ga dapet")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        drawTest.move(to: (touches.first?.location(in: self))!)
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self.viewWithTag(0))
        
        if(checkDotPosition(x: Int(location.x), y: Int(location.y))){
            addDotIndex(x: Int(location.x), y: Int(location.y), touchBegin: true)
        }
        
        print("touch begin")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        drawTest.addLine(to: location)
        if(checkDotPosition(x: Int(location.x), y: Int(location.y))){
            addDotIndex(x: Int(location.x), y: Int(location.y))
            print("dot touched")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIColor.black.setStroke()
//        drawTest.stroke()
//
//        drawTest.close()
        
//        drawLine(points: [14,25,27], strokeColor: .black, fillColor: .blue)
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        
        if(checkDotPosition(x: Int(location.x), y: Int(location.y))){
            addDotIndex(x: Int(location.x), y: Int(location.y), touchEnded: true)
            print("touch ended")
        }
   
//        do{
//            try
//        if (checkDotPosition(x: Int(location.x), y: Int(location.y))) == true && tappedDots[indexTappedDot].first == checkDotIndex(x: Int(location.x), y: Int(location.y)){
//                   addLastDotIndex(x: Int(location.x), y: Int(location.y))
//                   print("tambah yg terakhir")
////
////
//            }
//        }catch let error{
//            print("Error: \(error)")
//        }

        print("list of dots", tappedDots)
        setNeedsDisplay()
//        layoutIfNeeded()
    }
    
    
}

