//
//  GameScene.swift
//  Karaba
//
//  Created by Rem Remy on 14/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData

enum DrawingState {
    case enabled
    case disabled
}

enum TouchState {
    case begin
    case mov
    case end
    case idle
}
class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameVC = GameViewController()
    private var dotTiles: SKTileMapNode!
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var firstDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var lastDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var drawLayer: SKNode!
    private var previewLayer: SKNode!
    private var savedPoints = [CGPoint]()
    private var pointsToBeSend = [CGPoint]() //yg disimpen ke core data yg ini
    var container: NSPersistentContainer!
    // State
    private var drawingState = DrawingState.disabled
    private var touchState = TouchState.idle
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
        if savedPoints.count >= 6 && savedPoints.first == savedPoints.last{
            reset()
        }else if savedPoints.first != savedPoints.last{
            reset()
        }
        
        let touch = touches.first!
        startPoint = touch.location(in: self)
        
        if checkTouchIsCenter(point: startPoint){
            drawingState = .enabled
            //            touchState = .begin
            
            firstDrawPoint = getCenterOfDot(point: CGPoint(x: touch.location(in: self).x - 0.5, y: touch.location(in: self).y - 0.5) )
        }
        
        test(point: firstDrawPoint)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch drawingState {
        case .enabled:
            var currentPoint = touches.first!.location(in: self)
            let points = [firstDrawPoint,currentPoint]
            let lineNode = SKShapeNode()
            var drawedLineNode = SKShapeNode()
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
                        
                        drawedLineNode.path = linePathToBeDraw
                        drawedLineNode.lineWidth = 5
                        drawedLineNode.strokeColor = .black
                        drawedLineNode.name = "savedLine"
                        
                        savedPoints.append(firstDrawPoint)
                        savedPoints.append(lastDrawPoint)
                        pointsToBeSend.append(firstDrawPoint)
                        
                        if savedPoints.count >= 6 && savedPoints.first == savedPoints.last{
                            print("points ke core : ", pointsToBeSend)
                            if isItARectangle(points: pointsToBeSend){
                                //next scene
                                
                                print("SAVING:", "Trying to save")
                                
                                let shape = ShapeModel(path: pointsToBeSend)
                                print("SAVING:", shape)
                                
                                let d = ShapeBentuk(newModel: shape)
                                
                                d.insert()
                                
                                
                                if let view = gameVC.skView {
                                    // Load the SKScene from 'GameScene.sks'
                                    if let scene = SKScene(fileNamed: "CompoundScene") as? CompoundScene {
                                        // Set the scale mode to scale to fit the window
                                        
                                        let transition = SKTransition.fade(with: .white, duration: 2.5)
                                        scene.scaleMode = .aspectFill
                                        scene.gameVC = gameVC
                                        scene.gameVC.compoundScene = scene as CompoundScene
                                        // Present the scene
                                        view.presentScene(scene, transition: transition)
                                        gameVC.reloadCollection()
                                        gameVC.changeScene(sceneNo: 1)  
                                    }
                                    view.ignoresSiblingOrder = true
                                    view.setNeedsDisplay()
                                }
                            }
                        }
                        previewLayer.removeAllChildren()
                        drawLayer.addChild(drawedLineNode)
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
        previewLayer.removeAllChildren()
        
    }
    
    func addChildFunc(shape : SKShapeNode) {
        addChild(shape)
    }
    
    func reset(){
        drawLayer.removeAllChildren()
        savedPoints.removeAll()
        pointsToBeSend.removeAll()
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
