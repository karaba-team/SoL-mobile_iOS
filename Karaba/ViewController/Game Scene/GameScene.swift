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
    case move
    case end
    case idle
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    private var dotTiles: SKTileMapNode!
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var firstDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var lastDrawPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var drawLayer: SKNode!
    private var previewLayer: SKNode!
    private var savedPoints = [CGPoint]()
    var container: NSPersistentContainer!
    
    // State
    private var drawingState = DrawingState.disabled
    private var touchState = TouchState.idle
    
    override func didMove(to view: SKView) {
        backgroundColor = .gray

        guard let tileSet = SKTileSet(named: "dotTileSet") else {
            fatalError()
        }
        

        let tileSize = CGSize(width: 80, height: 80) // from image size
        dotTiles = SKTileMapNode(tileSet: tileSet, columns: 8, rows: 8, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        dotTiles.fill(with: tileGroup) // fill or set by column/row
        dotTiles.position = .zero
        
        drawLayer = SKNode()
        drawLayer.name = "drawLayer"
        
        previewLayer = SKNode()
        previewLayer.name = "previewLayer"
        
        
        print("Tile def")
        addChild(dotTiles)
        addChild(previewLayer)
        addChild(drawLayer)
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
//
//        print("center: \(centerPoint)", "touch: ", String(format: "(%.3f, %.3f)", point.x, point.y))
//        print("deltax:", String(format: "%.3f", deltaX), "deltay:", String(format: "%.3f", deltaY))
//        print("intersectedX: \(intersectedX)", "intersectedY: \(intersectedY)")
        
        return intersected
    }
    
    //CoreData Function
    func createData(){
        let managedContext = container.viewContext
        
        guard let userEntity = NSEntityDescription.entity(forEntityName: "Shape", in: managedContext) else { return  }
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue("\(savedPoints)", forKey: "arrDot")
        user.setValue("coba", forKey: "name")
        user.setValue("1", forKey: "shapeID")
        
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retriveData(){
        let managedContext = container.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shape")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "arrDot") as! String)
            }
        } catch{
            print("Failed")
        }
    }
    
    func updateData(){
        let managedContext = container.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Shape")
        fetchRequest.predicate = NSPredicate(format: "shapeID = 1", "1")//yg 1 ubah jadi variable
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("\(savedPoints)", forKey: "arrDot")
            objectUpdate.setValue("baru", forKey: "name")
            objectUpdate.setValue("1", forKey: "shapeID")
            do{
                try managedContext.save()
            } catch{
                print(error)
            }
        } catch{
            print(error)
        }
    }
    
    func deleteData(){
        let managedContext = container.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Shape")
        fetchRequest.predicate = NSPredicate(format: "shapeID = 1", "1")
        
        do{
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            } catch{
                print(error)
            }
        } catch{
            print(error)
        }
    }
    //end of CoreData function
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if savedPoints.count >= 6 && savedPoints.first == savedPoints.last{
            drawLayer.removeAllChildren()
            savedPoints.removeAll()
        }else if savedPoints.first != savedPoints.last{
            drawLayer.removeAllChildren()
            savedPoints.removeAll()
        }
        
        let touch = touches.first!
        startPoint = touch.location(in: self)
        
        if checkTouchIsCenter(point: startPoint){
            drawingState = .enabled
//            touchState = .begin
            
            firstDrawPoint = getCenterOfDot(point: CGPoint(x: touch.location(in: self).x - 0.5, y: touch.location(in: self).y - 0.5) )
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch drawingState {
        case .enabled:
//            canvasState = .touch(.move)
//            print("masuk draw enabled")
            let currentPoint = touches.first!.location(in: self)
            let points = [firstDrawPoint,currentPoint]
            let lineNode = SKShapeNode()
            var drawedLineNode = SKShapeNode()
            let linePath = CGMutablePath()

//            print("point, ",points)
            if points[0] == points[1]{
//                print("gagal")
            }else{
//                print("berhasil")
                linePath.addLines(between: points)
                lineNode.path = linePath
                lineNode.lineWidth = 5
                lineNode.strokeColor = .black

                previewLayer.removeAllChildren()
                previewLayer.addChild(lineNode)

                //            tempLineNode = lineNode
                lastDrawPoint = getCenterOfDot(point: currentPoint)

                let pointsToBeDraw = [firstDrawPoint,lastDrawPoint]
                
                if checkTouchIsCenter(point: currentPoint){
//                    drawingState = .disabled
    //                touchState = .move

    //                let lineNode = SKShapeNode()
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

                        if savedPoints.count >= 6 && savedPoints.first == savedPoints.last{
                            print("hiphiphura")
                        }

                        print("saved, ", savedPoints)

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

}
