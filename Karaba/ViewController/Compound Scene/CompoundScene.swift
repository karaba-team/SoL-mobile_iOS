//
//  CompoundScene.swift
//  Karaba
//
//  Created by Rem Remy on 23/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit

class CompoundScene: SKScene{

    private var arrShape = [[[CGPoint]]]()
    private var minimal = CGPoint(x: 0, y: 0)
    private var maximal = CGPoint(x: 0, y: 0)
    private var titikBerat = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
            //simpen titik"nya
            let polygons = [
                [
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 100, y: 100),
                    CGPoint(x: 100, y: 0)
                ],
                [
    //                CGPoint(x: 50, y: 50),
    //                CGPoint(x: 50, y: 150),
    //                CGPoint(x: 150, y: 150),
    //                CGPoint(x: 150, y: 50),
                    CGPoint(x: 50, y: 25),
                    CGPoint(x: -100, y: -100),
                    CGPoint(x: -100, y: -1)

                ]
            ]
            
            //gambar titik di tiap pathnya
            let path = CGMutablePath()

            for points in polygons {
                path.addLines(between: points)
                path.closeSubpath()
            }

            let first = CGMutablePath()
            first.addLines(between: polygons[0]);
            first.closeSubpath()

            let second = CGMutablePath()
            second.addLines(between: polygons[1]);
            second.closeSubpath()

            let node = SKShapeNode(path: first)
            node.fillColor = .red
            node.strokeColor = .white
            node.lineWidth = 2

            let child = SKShapeNode(path: second)
            child.fillColor = .red
            child.strokeColor = .white
            node.lineWidth = 2
            node.addChild(child)

            let child2 = SKShapeNode(path: first)
            child2.fillColor = .red
            child2.strokeColor = .clear
            node.lineWidth = 2
            node.addChild(child2)

            addChild(node)

            //simpen dalam 1 array hasil gabungan objectnya
            var tempArrShape : [[CGPoint]] = []
            
            for polygon in polygons{
                print("ini yang baru",polygon)
                tempArrShape.append(polygon)
            }
            
            cariTitikBerat()
            
            tempArrShape.append([titikBerat])
            print("cek stlh tambah titikberat : ", tempArrShape)
            
            //formatnya [obj1, obj2, titik berat] jadinya
            arrShape.append(tempArrShape)
            print("arrshape nih", arrShape)
        }
        
        func cariTitikBerat() {
            //buat frame dari object gabungan
            for shape in arrShape{
                for dot in shape{
                    for xy in dot{
                        print("xy yg kali ini", xy)
                        if maximal.x < xy.x{
                            maximal.x = xy.x
                        }
                        if maximal.y < xy.y{
                            maximal.y = xy.y
                        }
                        if minimal.x > xy.x{
                            minimal.x = xy.x
                        }
                        if minimal.y > xy.y{
                            minimal.y = xy.y
                        }
                    }
                }
            }
            
            //dapetin titik berat dari framenya
            titikBerat = CGPoint(x: maximal.x-abs(maximal.x-minimal.x)/2, y: maximal.y-abs(maximal.y-minimal.y)/2)
        }
        
        
        func touchDown(atPoint pos : CGPoint) {
        
        }
        
        func touchMoved(toPoint pos : CGPoint) {
            
        }
        
        func touchUp(atPoint pos : CGPoint) {
            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
        }
}
