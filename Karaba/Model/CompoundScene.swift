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
    private var arrShape = [[[CGPoint]]]() //untuk simpen ke core data ini, formatnya [[obj1],[obj2],[titikberat]]
    private var minimal = CGPoint(x: 0, y: 0)
    private var maximal = CGPoint(x: 0, y: 0)
    private var titikBerat = CGPoint(x: 0, y: 0)
    private var node = SKShapeNode()
    private var otherNode = SKShapeNode()
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
                CGPoint(x: 40, y: 40),
                CGPoint(x: 40, y: -40),
                CGPoint(x: -40, y: -40)
            ],
            [
                CGPoint(x: -40, y: 40),
                CGPoint(x: 40, y: 40),
                CGPoint(x: 40, y: -40),
                CGPoint(x: -40, y: -40)
            ]
        ]
        
        //persegi yang laen urutannya kuadran 2, kuadran 1, kuadran 4, kuadran 3
        let otherPolygons = [
            [
                CGPoint(x: -280, y: 280),
                CGPoint(x: -200, y: 280),
                CGPoint(x: -200, y: 200),
                CGPoint(x: -280, y: 200)
            ],
            [
                CGPoint(x: 200, y: 280),
                CGPoint(x: 280, y: 280),
                CGPoint(x: 280, y: 200),
                CGPoint(x: 200, y: 200)
            ],
            [
                CGPoint(x: 200, y: -280),
                CGPoint(x: 280, y: -280),
                CGPoint(x: 280, y: -200),
                CGPoint(x: 200, y: -200)
            ],
            [
                CGPoint(x: -280, y: -200),
                CGPoint(x: -200, y: -200),
                CGPoint(x: -200, y: -280),
                CGPoint(x: -280, y: -280)
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
//        var childPath = [CGMutablePath]()
//
//        for points in otherPolygons {
//            let path = CGMutablePath()
//            path.addLines(between: points)
//            path.closeSubpath()
//            childPath.append(path)
//        }
//
//        let otherChild1 = SKShapeNode(path: childPath[0])
//        otherChild1.fillColor = .clear
//        otherChild1.strokeColor = .black
//        otherChild1.lineWidth = 2
//        otherChild1.name = "anakanak"
//        addChild(otherChild1)
//
//        let otherChild2 = SKShapeNode(path: childPath[1])
//        otherChild2.fillColor = .clear
//        otherChild2.strokeColor = .black
//        otherChild2.lineWidth = 2
//        otherChild2.name = "anakanak"
//        addChild(otherChild2)
//
//        let otherChild3 = SKShapeNode(path: childPath[2])
//        otherChild3.fillColor = .clear
//        otherChild3.strokeColor = .black
//        otherChild3.lineWidth = 2
//        otherChild3.name = "anakanak"
//        addChild(otherChild3)
//
//        let otherChild4 = SKShapeNode(path: childPath[3])
//        otherChild4.fillColor = .clear
//        otherChild4.strokeColor = .black
//        otherChild4.lineWidth = 2
//        otherChild4.name = "anakanak"
//        addChild(otherChild4)

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
        addChild(otherNode)
//        node.removeFromParent()
        self.view?.addGestureRecognizer(pinchGesture)

        //simpen dalam 1 array hasil gabungan objectnya
        var tempArrShape : [[CGPoint]] = []
        
        for polygon in polygons{
            print("ini yang baru",polygon)
            tempArrShape.append(polygon)
        }
        
        titikBerat = cariTitikBerat(points: polygons[1])
        
        tempArrShape.append([titikBerat])
        
        //formatnya [[obj1], [obj2], [titik berat]] jadinya
        arrShape.append(tempArrShape)
        print("arrshape nih", arrShape)
        
        //validasi tutorial stage 3
        if isTheObjAtTheCorner(point: arrShape[0].last!){
            print("udah dicorner yey")
        }
        
        if isTheObjGetSurrounded(){
            print("dikelilingin dong horee ")
        }
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        let pinch = SKAction.scale(by: sender.scale, duration: 0.0)
        let uiposition = sender.location(in: view)
        let sceneposition = convertPoint(fromView: uiposition)
        susunTitik()
        
        let selectedNodes = nodes(at: sceneposition)
        selectedNodes.forEach { selectedNode in

            if selectedNode == dotTiles {
                return
            }else if selectedNode.name == "containerNode" {
                selectedNode.run(pinch)
            
                let frameSize = selectedNode.calculateAccumulatedFrame()
                
                //validasi ketika gerak
                if sender.state == .changed{
                    currentFrameDots[0] = CGPoint(x: frameSize.minX, y: frameSize.minY)
                    currentFrameDots[1] = CGPoint(x: frameSize.minX, y: frameSize.maxY)
                    currentFrameDots[2] = CGPoint(x: frameSize.maxX, y: frameSize.maxY)
                    currentFrameDots[3] = CGPoint(x: frameSize.maxX, y: frameSize.minY)
                    
                    let tempLastFrame = currentFrameDots
                    
                    //bates minimal
                    if countDistance(dot1: currentFrameDots[0], dot2: currentFrameDots[1]) < CGFloat(80) || countDistance(dot1: currentFrameDots[1], dot2: currentFrameDots[2]) < CGFloat(80) || countDistance(dot1: currentFrameDots[2], dot2: currentFrameDots[3]) < CGFloat(80) || countDistance(dot1: currentFrameDots[3], dot2: currentFrameDots[0]) < CGFloat(80){
                        //HARUS DIGANTI BERDASARKAN UKURAN ASLI DARI CORE DATA
                        currentFrameDots[0] = CGPoint(x: -40.5, y: 40.5)
                        currentFrameDots[1] = CGPoint(x: 40.5, y: 40.5)
                        currentFrameDots[2] = CGPoint(x: 40.5, y: -40.5)
                        currentFrameDots[3] = CGPoint(x: -40.5, y: -40.5)
                        
                        //bkin snap sendiri
                        scaleToMinOrMax(current: currentFrameDots[1], temp: tempLastFrame[1], position: sceneposition)
                    }
                    
                    //bates maksimal
                    currentFrameDots.forEach { currentFrameDot in
                        if currentFrameDot.x < CGFloat(-281) || currentFrameDot.x > CGFloat(281) || currentFrameDot.y < CGFloat(-281) || currentFrameDot.y > CGFloat(281){
                            
                            //HARUS DIGANTI BERDASARKAN SCALE MAX DARI UKURAN ASLI CORE DATA
                            currentFrameDots[0] = CGPoint(x: -280.5, y: 280.5)
                            currentFrameDots[1] = CGPoint(x: 280.5, y: 280.5)
                            currentFrameDots[2] = CGPoint(x: 280.5, y: -280.5)
                            currentFrameDots[3] = CGPoint(x: -280.5, y: -280.5)
                            
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
        
        //validasi untuk state selesai
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
        if isThePinchBigEnough(points: currentFrameDots){
            //validasi tutorial stage 2
            print("validasi berhasil dari ended")
        }
    }
    
    func susunTitik(){
        //kuadran 2
        if currentFrameDots[0].x < currentFrameDots[1].x && currentFrameDots[0].y > currentFrameDots[3].y{
            
        }
        
        //kuadran 1
        if currentFrameDots[0].x > currentFrameDots[3].x && currentFrameDots[0].y > currentFrameDots[1].y {
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
        if currentFrameDots[0].x < currentFrameDots[3].x && currentFrameDots[0].y < currentFrameDots[1].y{
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
    
    func cariTitikBerat(points: [CGPoint]) -> CGPoint{
        //buat frame dari object gabungan
        minimal = points[0]
        maximal = points[0]
        
        for point in points{
            if maximal.x < point.x{
                maximal.x = point.x
            }
            if maximal.y < point.y{
                maximal.y = point.y
            }
            if minimal.x > point.x{
                minimal.x = point.x
            }
            if minimal.y > point.y{
                minimal.y = point.y
            }
        }
        //dapetin titik berat dari framenya
        return CGPoint(x: maximal.x-abs(maximal.x-minimal.x)/2, y: maximal.y-abs(maximal.y-minimal.y)/2)
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
    
    func addChildFunc(shape : SKShapeNode) {
        addChild(shape)
    }
    
    func snapShapeToDot(points: [CGPoint]){
        currentFrameDots = centerOfEveryDot(points: points)
    }
    
    func isThePinchBigEnough(points: [CGPoint]) -> Bool{
        if points[0].x < CGFloat(-210) && points[0].y > CGFloat(210) && points[1].x > CGFloat(210) && points[1].y > CGFloat(210) && points[2].x > CGFloat(210) && points[2].y < CGFloat(-210) && points[3].x < CGFloat(-210) && points[3].y < CGFloat(-210) {
            
            return true
        }else{
            return false
        }
    }
    
    func isTheObjAtTheCorner(point: [CGPoint]) -> Bool{
        if (point[0].x < CGFloat(-200) && point[0].y > CGFloat(200)) || (point[0].x > CGFloat(200) && point[0].y > CGFloat(200)) || (point[0].x > CGFloat(200) && point[0].y < CGFloat(-200)) || (point[0].x < CGFloat(-200) && point[0].y < CGFloat(-200)){
            return true
        }else{
            return false
        }
    }
    
    func isTheObjGetSurrounded() -> Bool{
//        var flag = 0
//        
//        let checkNodes = nodes(at: <#T##CGPoint#>)
//        checkNodes.forEach() { checkNode in
//            if checkNode.position.x < CGFloat(0) && checkNode.position.y > CGFloat(0){
//                flag += 1
//            }
//            if checkNode.position.x > CGFloat(0) && checkNode.position.y > CGFloat(0){
//                flag += 1
//            }
//            if checkNode.position.x > CGFloat(0) && checkNode.position.y < CGFloat(0){
//                flag += 1
//            }
//            if checkNode.position.x < CGFloat(0) && checkNode.position.y < CGFloat(0){
//                flag += 1
//            }
//        }
//        
//        print("posisi other node : ", otherNode.position.x, otherNode.position.y)
//        
//        print("flag :", flag)
//        
//        if flag == 4{
//            return true
//        }else{
//            return false
//        }
    }
}
