//
//  GameScene.swift
//  Karaba
//
//  Created by Rem Remy on 14/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit


enum CanvasState {
    case touch(T)
    case draw(D)
    case dot(DD)
    
    enum D {
        case enabled
        case disabled
    }
    
    enum DD {
        case touched
        case untouched
    }
    
    enum T {
        case begin
        case move
        case end
    }
}

enum EndDrawingState{
    case enabled
    case disabled
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    private var dotTiles: SKTileMapNode!
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var firstDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var lastDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var regionLayer: SKNode!
    private var drawLayer: SKNode!
    private var previewLayer: SKNode!
    private var tempLineNode: SKShapeNode!
    private var drawedLineNode: SKShapeNode!
    private var dotRegion: SKRegion!
    private var fieldNode: SKFieldNode!
    private var canvasState: CanvasState!
    private var savedPoints = [CGPoint]()
    
    override func didMove(to view: SKView) {

//        backgroundColor = .white
        guard let tileSet = SKTileSet(named: "dotTileSet") else {
            // hint: don't use the filename for named, use the tileset inside
            fatalError()
        }

        let tileSize = CGSize(width: 100, height: 100) // from image size
        dotTiles = SKTileMapNode(tileSet: tileSet, columns: 10, rows: 10, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        dotTiles.fill(with: tileGroup) // fill or set by column/row
        //tileMap.setTileGroup(tileGroup, forColumn: 5, row: 5)
        self.addChild(dotTiles)
        
//        regionLayer
    
        drawLayer = SKNode()
        drawLayer.name = "drawLayer"
        
        previewLayer = SKNode()
        previewLayer.name = "previewLayer"
        
        
//        print("Tile size", dotTiles.tileSize)
        print("Tile def")
        
        addChild(previewLayer)
        addChild(drawLayer)
    }
    
    func getCenterOfDot(point: CGPoint) -> CGPoint{
        let dotIndexColumn = dotTiles.tileColumnIndex(fromPosition: point)
        let dotIndexRow = dotTiles.tileRowIndex(fromPosition: point)
        
//        print("column-row", dotIndexColumn, dotIndexRow)
        
        let centerDot = dotTiles.centerOfTile(atColumn: dotIndexColumn, row: dotIndexRow)
//        print("center", centerDot)
        
        return centerDot
    }
    
    func checkTouchIsCenter(point: CGPoint, tolerance: CGFloat = 10) -> Bool {
        let centerPoint = getCenterOfDot(point: point)
        let deltaX = abs(centerPoint.x - point.x)
        let deltaY = abs(centerPoint.y - point.y)
        let intersectedX = deltaX < tolerance
        let intersectedY = deltaY < tolerance
        let intersected = intersectedX || intersectedY
//
//        print("center: \(centerPoint)", "touch: ", String(format: "(%.3f, %.3f)", point.x, point.y))
//        print("deltax:", String(format: "%.3f", deltaX), "deltay:", String(format: "%.3f", deltaY))
        print("intersectedX: \(intersectedX)", "intersectedY: \(intersectedY)")
        
        return intersected
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        startPoint = touch.location(in: self)
        
        if checkTouchIsCenter(point: startPoint){
            canvasState = .draw(.enabled)
//            canvasState = .touch(.begin)
            
            firstDrawPoint = getCenterOfDot(point: CGPoint(x: touch.location(in: self).x - 0.25, y: touch.location(in: self).y - 0.25) )
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        switch canvasState {
        case .draw(.enabled):
//            canvasState = .touch(.move)


            let currentPoint = touches.first!.location(in: self)
            let points = [firstDrawPoint,currentPoint]
            let lineNode = SKShapeNode()
            let linePath = CGMutablePath()

            checkTouchIsCenter(point: currentPoint)

            linePath.addLines(between: points)
            lineNode.path = linePath
            lineNode.lineWidth = 5
            lineNode.strokeColor = .black
            
            

            previewLayer.removeAllChildren()
            previewLayer.addChild(lineNode)

            tempLineNode = lineNode
        default:
            print(canvasState)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        let touch = touches.first!
        lastDrawPoint = getCenterOfDot(point: currentPoint)

        let points = [firstDrawPoint,lastDrawPoint]

        switch canvasState {
        case .draw(.enabled):
//
            if checkTouchIsCenter(point: currentPoint){
                canvasState = .draw(.disabled)
                canvasState = .touch(.end)

//                let lineNode = SKShapeNode()
                let linePath = CGMutablePath()

                linePath.addLines(between: points)
                tempLineNode.path = linePath
                tempLineNode.lineWidth = 5
                tempLineNode.strokeColor = .black
                
                savedPoints.append(firstDrawPoint)
                savedPoints.append(lastDrawPoint)
                print(savedPoints)
                
                
                
                drawedLineNode = tempLineNode
//                previewLayer.removeAllChildren()
//                previewLayer.addChild(lineNode)

                previewLayer.removeAllChildren()
                drawLayer.addChild(drawedLineNode)
                print("yey kegambar")

                tempLineNode = nil
            }
        default:
            print("draw default")
        }
    }
    
}
