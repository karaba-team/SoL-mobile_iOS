//
//  Chapter11Scene.swift
//  Karaba
//
//  Created by Andika Leonardo on 18/11/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData

class Chapter11Scene: SKScene, SKPhysicsContactDelegate{
    
    var gameVC = GameViewController()
    private var dotTiles: SKTileMapNode!
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var firstDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var lastDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var drawLayer: SKNode!
    private var previewLayer: SKNode!
    private var savedPoints = [CGPoint]()
    private var pointsToBeSend = [CGPoint]() //yg disimpen ke core data yg ini
    private var squareCount = 0
    private var drawedLineNode: SKShapeNode?
    var container: NSPersistentContainer!
    // State
    private var drawingStateChap1 = DrawingState.disabled
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        guard let tileSet = SKTileSet(named: "dotTileSet") else {
            // hint: don't use the filename for named, use the tileset inside
            fatalError()
        }
        
        let tileSize = CGSize(width: 80, height: 80) // from image size
        dotTiles = SKTileMapNode(tileSet: tileSet, columns: 8, rows: 8, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        dotTiles.fill(with: tileGroup) // fill or set by column/row
        self.addChild(dotTiles)
        
        drawLayer = SKNode()
        drawLayer.name = "drawLayer"
        
        previewLayer = SKNode()
        previewLayer.name = "previewLayer"
        
        print("Tile def")
        
        addChild(previewLayer)
        addChild(drawLayer)
        
    }
    
    func test(point: CGPoint) {
        let dotIndexColumn = dotTiles.tileColumnIndex(fromPosition: point)
        let dotIndexRow = dotTiles.tileRowIndex(fromPosition: point)
        
        let centerDot = dotTiles.centerOfTile(atColumn: dotIndexColumn, row: dotIndexRow)
        print("column", dotIndexColumn, "row", dotIndexRow,"test ", centerDot)
    }
    
    func getCenterOfDot(point: CGPoint) -> CGPoint{
        let dotIndexColumn = dotTiles.tileColumnIndex(fromPosition: point)
        let dotIndexRow = dotTiles.tileRowIndex(fromPosition: point)
        
        let centerDot = dotTiles.centerOfTile(atColumn: dotIndexColumn, row: dotIndexRow)
        
        return centerDot
    }
    
    func checkTouchIsCenter(point: CGPoint, tolerance: CGFloat = 20) -> Bool {
        let centerPoint = getCenterOfDot(point: point)
        let deltaX = abs(centerPoint.x - point.x)
        let deltaY = abs(centerPoint.y - point.y)
        let intersectedX = deltaX < tolerance
        let intersectedY = deltaY < tolerance
        let intersected = intersectedX && intersectedY
        
        return intersected
    }
    
    func boundaryScene(point: CGPoint) -> CGPoint{
        var newPoint = CGPoint(x: 0, y: 0)
        
        if point.x > CGFloat(280.5){
            newPoint.x = CGFloat(280)
            newPoint.y = point.y
        }
        
        if point.x < CGFloat(-280.5){
            newPoint.x = CGFloat(-280)
            newPoint.y = point.y
        }
        
        if point.y > CGFloat(280.5){
            newPoint.y = CGFloat(280)
            newPoint.x = point.x
        }
        
        if point.y < CGFloat(-280.5){
            newPoint.y = CGFloat(-280)
            newPoint.x = point.x
        }
        
        return newPoint
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if savedPoints.count >= 6 && savedPoints.first == savedPoints.last{
//            reset()
//        }else if savedPoints.first != savedPoints.last{
//            reset()
//        }
        drawLayer.removeAllChildren()
        pointsToBeSend = [CGPoint]()
        savedPoints = [CGPoint]()
        
        let touch = touches.first!
        startPoint = touch.location(in: self)
        
        if checkTouchIsCenter(point: startPoint){
            drawingStateChap1 = .enabled
            //            touchState = .begin
            
            firstDrawPoint = getCenterOfDot(point: CGPoint(x: touch.location(in: self).x - 0.5, y: touch.location(in: self).y - 0.5) )
        }
        
        test(point: firstDrawPoint)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch drawingStateChap1 {
        case .enabled:
            var currentPoint = touches.first!.location(in: self)
            let points = [firstDrawPoint,currentPoint]
            let lineNode = SKShapeNode()
            drawedLineNode = SKShapeNode()
            let linePath = CGMutablePath()
            
            if points[0] == points[1]{
                
            }else{
                linePath.addLines(between: points)
                lineNode.path = linePath
                lineNode.lineWidth = 5
                lineNode.strokeColor = .black
                
                if currentPoint.x > CGFloat(280.5) || currentPoint.x < CGFloat(-280.5) || currentPoint.y > CGFloat(280.5) || currentPoint.y < CGFloat(-280.5){
                    currentPoint = boundaryScene(point: currentPoint)
                }
                
                previewLayer.removeAllChildren()
                previewLayer.addChild(lineNode)
                
                lastDrawPoint = getCenterOfDot(point: currentPoint)
                
                let pointsToBeDraw = [firstDrawPoint,lastDrawPoint]
                if checkTouchIsCenter(point: currentPoint){
                    if pointsToBeDraw[0] == pointsToBeDraw[1]{
                        
                    }else{
                        
                        let linePathToBeDraw = CGMutablePath()
                        
                        linePathToBeDraw.addLines(between: pointsToBeDraw)
                        print(linePathToBeDraw, drawedLineNode)
                        
                        if let shapeNode = drawedLineNode {
                            shapeNode.path = linePathToBeDraw
                            shapeNode.lineWidth = 5
                            shapeNode.strokeColor = .black
                            shapeNode.name = "savedLine"
                        }
                        
                        savedPoints.append(firstDrawPoint)
                        savedPoints.append(lastDrawPoint)
                        pointsToBeSend.append(firstDrawPoint)
//                        previewLayer.removeAllChildren()
//                        drawLayer.addChild(drawedLineNode!)
//                        firstDrawPoint = lastDrawPoint
                        
//                        drawedLineNode = SKShapeNode()
                        if savedPoints.count >= 6 && savedPoints.first == savedPoints.last{
                            print("points ke core : ", pointsToBeSend)
                            if isItARectangle(points: pointsToBeSend){
                                
                                squareCount += 1
                                print("squarecount : ", squareCount)
                                
                                //bkin kotak disini
                                let path = CGMutablePath()
                                path.addLines(between: pointsToBeSend)
                                path.closeSubpath()
                                
                                let child = SKShapeNode(path: path)
                                child.fillColor = .blue
                                child.strokeColor = .clear
                                addChild(child)
                            }
                        }
                        previewLayer.removeAllChildren()
                        drawLayer.addChild(drawedLineNode!)
                        firstDrawPoint = lastDrawPoint
                        
                        drawedLineNode = SKShapeNode()
                    }
            
                }
            }
            
        default:
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("END: POINT TO BE SAVED", pointsToBeSend.count, pointsToBeSend)
        previewLayer.removeAllChildren()
        
        if squareCount == 3 {
                // Load the SKScene from 'GameScene.sks'
            let shape = ShapeModel(path: pointsToBeSend)
            print("SAVING:", shape)
            
            let d = ShapeBentuk(newModel: shape)
            
//            d.deleteAllShape()
            d.insert()
            
            if let scene = SKScene(fileNamed: "Chapter12Scene") as? Chapter12Scene {
                // Set the scale mode to scale to fit the window
                gameVC.changeScene(sceneNo: 5)
                print("CHANGE SCENE")
                let transition = SKTransition.fade(with: .white, duration: 2.5)
                scene.scaleMode = .aspectFill
                scene.gameVC = gameVC
                scene.gameVC.chapter12Scene = scene as Chapter12Scene
                // Present the scene
                gameVC.reloadCollection()
                view?.presentScene(scene, transition: transition)
            }
        }
    }
    func addChildFunc(shape : SKShapeNode) {
        addChild(shape)
    }
    
    func countDistance(dot1: CGPoint, dot2: CGPoint) -> CGFloat{
        return sqrt(((dot2.x-dot1.x)*(dot2.x-dot1.x))+((dot2.y-dot1.y)*(dot2.y-dot1.y)))
    }
    
    func isItARectangle(points: [CGPoint]) -> Bool{
        if points.count != 4{
            return false
        }
        
        let distance1 = countDistance(dot1: points[0], dot2: points[1])
        let distance2 = countDistance(dot1: points[1], dot2: points[2])
        let distance3 = countDistance(dot1: points[2], dot2: points[3])
        let distance4 = countDistance(dot1: points[3], dot2: points[0])
        
        if distance1 == CGFloat(80) && distance2 == CGFloat(80) && distance3 == CGFloat(80) && distance4 == CGFloat(80) {
            return true
        }else{
            return false
        }
    }
}
