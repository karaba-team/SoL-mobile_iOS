//
//  CompoundScene.swift
//  Karaba
//
//  Created by Rem Remy on 25/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit

class CompoundScene: SKScene{

    private var dotTiles: SKTileMapNode!
    private var arrShape = [[[CGPoint]]]()
    private var minimal = CGPoint(x: 0, y: 0)
    private var maximal = CGPoint(x: 0, y: 0)
    private var titikBerat = CGPoint(x: 0, y: 0)
    private var node = SKShapeNode()
    private var finalNode = SKShapeNode()
    private var distance: [CGFloat] = [0,0]
    private var minmaxFrame = [CGPoint]()
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = true
        node.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(_:)))
        
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
        
        backgroundColor = .white

        guard let tileSet = SKTileSet(named: "dotTileSet") else {
            // hint: don't use the filename for named, use the tileset inside
            fatalError()
        }

        let tileSize = CGSize(width: 80, height: 80) // from image size
        dotTiles = SKTileMapNode(tileSet: tileSet, columns: 8, rows: 8, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        dotTiles.fill(with: tileGroup) // fill or set by column/row
        //tileMap.setTileGroup(tileGroup, forColumn: 5, row: 5)
        dotTiles.position = CGPoint(x: (self.view?.center.x)!, y: (self.view?.center.y)!)
        addChild(dotTiles)
        
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

        node = SKShapeNode(path: first)
        node.fillColor = .red
        node.strokeColor = .black
        node.lineWidth = 2

        let child = SKShapeNode(path: second)
        child.fillColor = .red
        child.strokeColor = .black
        node.lineWidth = 2
        node.addChild(child)

        let child2 = SKShapeNode(path: first)
        child2.fillColor = .red
        child2.strokeColor = .clear
        node.lineWidth = 2
        node.addChild(child2)

        finalNode.fillColor = .red
        finalNode.strokeColor = .black
        finalNode.lineWidth = 2
        finalNode.addChild(node)

        addChild(finalNode)
//        node.removeFromParent()
        self.view?.addGestureRecognizer(pinchGesture)

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
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        let pinch = SKAction.scale(by: sender.scale, duration: 0.0)
        let uiposition = sender.location(in: view)
        let sceneposition = convertPoint(fromView: uiposition)
        
        let selectedNodes = nodes(at: sceneposition)
        selectedNodes.forEach { (n) in
            if n != dotTiles{
                n.run(pinch)
                if minmaxFrame.isEmpty{
                    minmaxFrame.append(CGPoint(x: n.frame.minX, y: n.frame.minY))
                    minmaxFrame.append(CGPoint(x: n.frame.minX, y: n.frame.maxY))
                    minmaxFrame.append(CGPoint(x: n.frame.maxX, y: n.frame.maxY))
                    minmaxFrame.append(CGPoint(x: n.frame.maxX, y: n.frame.minY))
                }else{
                    minmaxFrame[0] = CGPoint(x: n.frame.minX, y: n.frame.minY)
                    minmaxFrame[1] = CGPoint(x: n.frame.minX, y: n.frame.maxY)
                    minmaxFrame[2] = CGPoint(x: n.frame.maxX, y: n.frame.maxY)
                    minmaxFrame[3] = CGPoint(x: n.frame.maxX, y: n.frame.minY)
                }
            }
        }
        
        sender.scale = 1.0
//        snapShapeToDot(points: minmaxFrame)
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
    
    func countDistance(dot1: CGPoint, dot2: CGPoint) -> CGFloat{
        return sqrt(((dot2.x-dot1.x)*(dot2.x-dot1.x))+((dot2.y-dot1.y)*(dot2.y-dot1.y)))
    }
    
    func centerOfEveryDot(points: [CGPoint]) -> [CGPoint]{
        var savedCenter = [CGPoint]()
    
        for point in points{
            let dotIndexColumn = dotTiles.tileColumnIndex(fromPosition: point)
            let dotIndexRow = dotTiles.tileRowIndex(fromPosition: point)
            
            let centerDot = dotTiles.centerOfTile(atColumn: dotIndexColumn, row: dotIndexRow)
            
            savedCenter.append(point)
        }
        
        return savedCenter
    }
    
    func snapShapeToDot(points: [CGPoint]){
        minmaxFrame = centerOfEveryDot(points: points)
        print(minmaxFrame)
    }
    
}
