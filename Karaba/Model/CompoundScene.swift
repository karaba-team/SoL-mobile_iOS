//
//  CompoundScene.swift
//  Karaba
//
//  Created by Rem Remy on 25/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class CompoundScene: SKScene{

    private var viewNode: SKView!
    private var dotTiles: SKTileMapNode!
    private var arrShape = [[[CGPoint]]]()
    private var minimal = CGPoint(x: 0, y: 0)
    private var maximal = CGPoint(x: 0, y: 0)
    private var titikBerat = CGPoint(x: 0, y: 0)
    private var node = SKShapeNode()
    private var distance: [CGFloat] = [0,0]
    private var currentFrameDots: [CGPoint] = [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0)] //untuk simpen koordinat frame 2 object
    private var lastFrameDots: [CGPoint] = [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0)]
    private var checkScaleFromStart = 0
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = true
//        node.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(_:)))
        
        //simpen titik"nya
        let polygons = [
            [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 40, y: 40),
                CGPoint(x: 40, y: 0)
            ],
            [
                CGPoint(x: -40, y: 40),
                CGPoint(x: 40, y: 40),
                CGPoint(x: 40, y: -40),
                CGPoint(x: -40, y: -40)

            ]
        ]
        lastFrameDots = polygons[1]
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
        

        let child1 = SKShapeNode(path: first)
        child1.fillColor = .red
        child1.strokeColor = .black
        child1.lineWidth = 2
        node.addChild(child1)
        
//        node = SKShapeNode(path: first)
//        node.fillColor = .red
//        node.strokeColor = .black
//        node.lineWidth = 2

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
        node.name = "containerNode"

//        finalNode.fillColor = .red
//        finalNode.strokeColor = .black
//        finalNode.lineWidth = 2
//        finalNode.addChild(node)

        addChild(node)
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
        selectedNodes.forEach { selectedNode in

            if selectedNode == dotTiles {
                return
            }else if selectedNode.name == "containerNode" {
                selectedNode.run(pinch)
            
                let frameSize = selectedNode.calculateAccumulatedFrame()
                
                if sender.state == .changed{
                    currentFrameDots[0] = CGPoint(x: frameSize.minX, y: frameSize.minY)
                    currentFrameDots[1] = CGPoint(x: frameSize.minX, y: frameSize.maxY)
                    currentFrameDots[2] = CGPoint(x: frameSize.maxX, y: frameSize.maxY)
                    currentFrameDots[3] = CGPoint(x: frameSize.maxX, y: frameSize.minY)
                    
                    let tempLastFrame = currentFrameDots
                    
                    susunTitik()
                    
                    //bates minimal
                    if countDistance(dot1: currentFrameDots[0], dot2: currentFrameDots[1]) < CGFloat(40) || countDistance(dot1: currentFrameDots[1], dot2: currentFrameDots[2]) < CGFloat(40) || countDistance(dot1: currentFrameDots[2], dot2: currentFrameDots[3]) < CGFloat(40) || countDistance(dot1: currentFrameDots[3], dot2: currentFrameDots[0]) < CGFloat(40){
                        //harus diganti sama ukuran minimal aslinya
                        currentFrameDots[0] = CGPoint(x: -40.5, y: 40.5)
                        currentFrameDots[1] = CGPoint(x: 40.5, y: 40.5)
                        currentFrameDots[2] = CGPoint(x: 40.5, y: 40.5)
                        currentFrameDots[3] = CGPoint(x: 40.5, y: -40.5)
                        
                        //bkin snap sendiri
                        scaleToMinOrMax(current: currentFrameDots[1], temp: tempLastFrame[1], position: sceneposition)
                    }
                    
                    //bates maksimal
                    currentFrameDots.forEach { currentFrameDot in
                        if currentFrameDot.x < CGFloat(-280) || currentFrameDot.x > CGFloat(280) || currentFrameDot.y < CGFloat(-280) || currentFrameDot.y > CGFloat(280){
                            
                            //harus diganti berdasarkan maksimal scalenya bisa brp kali
                            currentFrameDots[0] = CGPoint(x: -279.5, y: -279.5)
                            currentFrameDots[1] = CGPoint(x: -279.5, y: 279.5)
                            currentFrameDots[2] = CGPoint(x: 279.5, y: 279.5)
                            currentFrameDots[3] = CGPoint(x: 279.5, y: -279.5)
                            
                            //bkin snap sendiri
                            scaleToMinOrMax(current: currentFrameDots[1], temp: tempLastFrame[1], position: sceneposition)
                        }
                    }
                    
//                    lastFrameDots = currentFrameDots
                    sender.scale = 1.0
                    return
                    //bates minmax selesai
                }
            }
        }
        
        if sender.state == .ended {
            let tempLastFrame = currentFrameDots
            snapShapeToDot(points: currentFrameDots)
            
            var scale = CGFloat(currentFrameDots[1].y/tempLastFrame[1].y)
            let finalPinch = SKAction.scale(by: scale, duration: 0.5)
            
            let snapSelectedNodes = nodes(at: sceneposition)
            snapSelectedNodes.forEach { snapSelectedNode in
                if snapSelectedNode == dotTiles{
                    return
                }else if snapSelectedNode.name == "containerNode"{
                    //untuk cari tahu udah scale brp kali gede/kecilnya dari scale pertamanya
                    print("cek lastframe : ", lastFrameDots)
                    if lastFrameDots[1].y<currentFrameDots[1].y{
                        if (Int(abs(lastFrameDots[1].y-tempLastFrame[1].y))/75) == 1{
                            checkScaleFromStart = -1
                        }else if (Int(abs(lastFrameDots[1].y-tempLastFrame[1].y))/75) == 2{
                            checkScaleFromStart = -2
                        }else if (Int(abs(lastFrameDots[1].y-tempLastFrame[1].y))/75) == 3{
                            checkScaleFromStart = -3
                        }
                    }else if lastFrameDots[1].y>currentFrameDots[1].y{
                        print(Int(abs(tempLastFrame[1].y-lastFrameDots[1].y))/75)
                        print("tempnya : ", tempLastFrame[1].y, "lastnya : ", lastFrameDots[1].y)
                        if (Int(abs(tempLastFrame[1].y-lastFrameDots[1].y))/75) == 1{
                            checkScaleFromStart = 2
                        }else if (Int(abs(tempLastFrame[1].y-lastFrameDots[1].y))/75) == 2{
                            checkScaleFromStart = 1
                        }else if (Int(abs(tempLastFrame[1].y-lastFrameDots[1].y))/75) == 3{
                            checkScaleFromStart = 0
                        }
                    }
                    print("scale brp kali", checkScaleFromStart)
                    snapSelectedNode.run(finalPinch)
                }
            }
            lastFrameDots = currentFrameDots
        }
        sender.scale = 1.0
    }
    
    func susunTitik(){
        //kuadran 2
        if currentFrameDots[0].x < currentFrameDots[1].x && currentFrameDots[0].y > currentFrameDots[3].y{
            
        }
        
        //kuadran 1
        if currentFrameDots[0].x > currentFrameDots[1].x && currentFrameDots[0].y > currentFrameDots[3].y {
            var tempDot = currentFrameDots[0]
            currentFrameDots[0] = currentFrameDots[1]
            currentFrameDots[1] = currentFrameDots[2]
            currentFrameDots[2] = currentFrameDots[3]
            currentFrameDots[3] = tempDot
        }
        
        //kuadran 4
        if currentFrameDots[0].x > currentFrameDots[1].x && currentFrameDots[0].y < currentFrameDots[3].y{
            var tempDot = currentFrameDots[0]
            currentFrameDots[0] = currentFrameDots[2]
            currentFrameDots[2] = tempDot
            tempDot = currentFrameDots[3]
            currentFrameDots[3] = currentFrameDots[1]
            currentFrameDots[1] = tempDot
        }
        
        //kuadran 3
        if currentFrameDots[0].x < currentFrameDots[1].x && currentFrameDots[0].y < currentFrameDots[3].y{
            var tempDot = currentFrameDots[1]
            currentFrameDots[1] = currentFrameDots[0]
            currentFrameDots[0] = currentFrameDots[3]
            currentFrameDots[3] = currentFrameDots[2]
            currentFrameDots[2] = tempDot
        }
    }
    
    func scaleToMinOrMax(current: CGPoint, temp: CGPoint, position: CGPoint){
        var scale = CGFloat(current.y/temp.y)
        let minmaxPinch = SKAction.scale(by: scale, duration: 0.1)

        let snapnodes = nodes(at: position)
        snapnodes.forEach { snapnode in
            if snapnode == dotTiles{
                return
            }else if snapnode.name == "containerNode"{
                snapnode.run(minmaxPinch)
            }
        }
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
            
            //itung berapa titiknya biar scalenya pas di titik tngh
            if checkScaleFromStart == 0{
                savedCenter.append(CGPoint(x: centerDot.x-CGFloat(checkScaleFromStart)-0.5, y: centerDot.y-CGFloat(checkScaleFromStart)-0.5))
            }else if checkScaleFromStart == 1 ||  checkScaleFromStart == 2 ||  checkScaleFromStart == 3{
                savedCenter.append(CGPoint(x: centerDot.x-CGFloat(checkScaleFromStart)*2-0.5, y: centerDot.y-CGFloat(checkScaleFromStart)*2-0.5))
            }else if checkScaleFromStart == -1 || checkScaleFromStart == -2 || checkScaleFromStart == -3{
                savedCenter.append(CGPoint(x: centerDot.x-CGFloat(checkScaleFromStart)*2+0.5, y: centerDot.y+CGFloat(abs(checkScaleFromStart))*2+0.5))
            }
            
        }

        return savedCenter
    }
    
    func snapShapeToDot(points: [CGPoint]){
        currentFrameDots = centerOfEveryDot(points: points)
    }
    
}
