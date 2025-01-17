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

    var gameVC = GameViewController()
    private var viewNode: SKView!
    private var dotTiles: SKTileMapNode!
    private var arrShape = [[[CGPoint]]]() //untuk simpen ke core data ini, formatnya [[obj1],[obj2],[titikberat]]
    private var minimal = CGPoint(x: 0, y: 0)
    private var maximal = CGPoint(x: 0, y: 0)
    private var titikBerat = CGPoint(x: 0, y: 0)
    private var node = SKShapeNode()
    private var otherNode = SKShapeNode()
    private var distance: [CGFloat] = [0,0]
    var currentFrameDots: [CGPoint] = [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0)] //untuk simpen koordinat frame 2 object
    private var lastFrameDots: [CGPoint] = [CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0),CGPoint(x: 0, y: 0)]
    private var checkScaleFromStart = 0
    var compoundSceneShapeNode = [SKShapeNode]()
    var selectedNode = SKNode()
    var tempCoor = [CGPoint]()
    
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
       
        
        lastFrameDots = polygons[1]  //harus diset sama ukuran yg disimpen di core data
        backgroundColor = .white

        guard let tileSet = SKTileSet(named: "dotTileSet") else {
            // hint: don't use the filename for named, use the tileset inside
            fatalError()
        }

        let tileSize = CGSize(width: 80, height: 80) // from image size
        dotTiles = SKTileMapNode(tileSet: tileSet, columns: 8, rows: 8, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        dotTiles.name = "dotTiles"
        dotTiles.fill(with: tileGroup) // fill or set by column/row
        addChild(dotTiles)
        
        //gambar titik di tiap pathnya
        let first = CGMutablePath()
        first.addLines(between: polygons[0]);
        first.closeSubpath()

        let second = CGMutablePath()
        second.addLines(between: polygons[1]);
        second.closeSubpath()
        

//        let child1 = SKShapeNode(path: first)
//        child1.fillColor = .red
//        child1.strokeColor = .black
//        child1.lineWidth = 2
//        node.addChild(child1)

//        let child = SKShapeNode(path: second)
//        child.fillColor = .red
//        child.strokeColor = .black
//        node.lineWidth = 2
//        node.name = "containerNode"
//        node.addChild(child)

//        let child2 = SKShapeNode(path: first)
//        child2.fillColor = .red
//        child2.strokeColor = .clear
//        node.lineWidth = 2
//        node.name = "containerNode"
//        node.addChild(child2)
        

        addChild(node)
//        node.removeFromParent()
        view.addGestureRecognizer(pinchGesture)
        
        addChild(otherNode)

        //simpen dalam 1 array hasil gabungan objectnya
        var tempArrShape : [[CGPoint]] = []
        
        for polygon in polygons{
            print("ini yang baru",polygon)
            tempArrShape.append(polygon)
        }
        
        titikBerat = cariTitikBerat(points: polygons[1])
        
        tempArrShape.append([titikBerat])
        
        arrShape.append(tempArrShape)
        print("arrshape nih", arrShape)
    }
    var previousTranslateX:CGFloat = 0.0
    var previousTranslateY:CGFloat = 0.0
    var tempX:CGFloat = 0.0
    var tempY:CGFloat = 0.0
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let positionInScene = touch.location(in: self)
//
//        selectNodeForTouch(touchLocation: positionInScene)
//    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }

    func selectNodeForTouch(touchLocation: CGPoint) {
      let touchedNode = self.nodes(at: touchLocation)
        if !selectedNode.isEqual(touchedNode) {
            selectedNode.removeAllActions()
            selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
            touchedNode.forEach { touchedNode in
                if touchedNode.name != "containerNode" && touchedNode.name != "dotTiles" {
                    selectedNode = touchedNode
//                    let sequence = SKAction.sequence([SKAction.rotate(byAngle: degToRad(degree: -4.0), duration: 0.1),
//                                                  SKAction.rotate(byAngle: 0.0, duration: 0.1),
//                                                  SKAction.rotate(byAngle: degToRad(degree: 4.0), duration: 0.1)])
//                    selectedNode.run(SKAction.repeatForever(sequence))
                }
            }
        }
    }
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
//        retval.x = CGFloat(max(retval.x, -(dotTiles.mapSize.width) + winSize.width))
//        retval.x = CGFloat(max(retval.x, dotTiles.mapSize.width))
        retval.y = self.position.y
      
        return retval
    }

//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let positionInScene = touch.location(in: self)
//        let previousPosition = touch.previousLocation(in: self)
//        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
//        panForTranslation(translation: translation)
//    }
//
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        let pinch = SKAction.scale(by: sender.scale, duration: 0.0)
        let uiposition = sender.location(in: view)
        let sceneposition = convertPoint(fromView: uiposition)
        currentFrameDots = susunTitik(points: currentFrameDots)
        
        let selectedNodes = nodes(at: sceneposition)
        selectedNodes.forEach { selectedNode in
            if selectedNode.name != "dotTiles" {
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
                    if reachMinimal(points: currentFrameDots){
                        currentFrameDots = minimalBoundary(points: currentFrameDots)
                        
                        snapShapeToDot(points: currentFrameDots)
                        
                        //bkin snap sendiri
                        scaleToMinOrMax(current: currentFrameDots[1], temp: tempLastFrame[1], position: sceneposition)
                    }
                    
                    if reachMaximal(points: currentFrameDots){
                        currentFrameDots = maximalBoundary(points: currentFrameDots)
                        
                        snapShapeToDot(points: currentFrameDots)
                        
                        //bkin snap sendiri
                        scaleToMinOrMax(current: currentFrameDots[1], temp: tempLastFrame[1], position: sceneposition)
                    }
                    
                    
                    sender.scale = 1.0
                }
            }
        }
        
        //validasi untuk state selesai
        if sender.state == .ended {
            let tempLastFrame = currentFrameDots
            snapShapeToDot(points: currentFrameDots)
            
            let scale = CGFloat(currentFrameDots[1].y/tempLastFrame[1].y)
            let finalPinch = SKAction.scale(by: scale, duration: 0.5)
            
            let snapSelectedNodes = nodes(at: sceneposition)
            snapSelectedNodes.forEach { snapSelectedNode in
                if snapSelectedNode == dotTiles{
                    return
                }else if snapSelectedNode.name != "dotTiles"{
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
            
            if isThePinchBigEnough(points: currentFrameDots){
                //validasi tutorial stage 2
                if let scene = SKScene(fileNamed: "CornerScene") as? CornerScene {
                    // Set the scale mode to scale to fit the window
                    gameVC.changeScene(sceneNo: 2)
                    let transition = SKTransition.fade(with: .white, duration: 2.5)
                    scene.scaleMode = .aspectFill
                    scene.gameVC = gameVC
                    scene.gameVC.cornerScene = scene as CornerScene
        
                    print("SCN:", scene)
                    view?.presentScene(scene, transition: transition)
                }
        
            }
        }
        sender.scale = 1.0
        
    }
    
    func susunTitik(points: [CGPoint]) -> [CGPoint]{
        var newPoints = points
        
        //kuadran 2
        if points[0].x < points[1].x && points[0].y > points[3].y{
            
        }
        
        //kuadran 1
        if points[0].x > points[3].x && points[0].y > points[1].y {
            newPoints[0] = points[3]
            newPoints[1] = points[0]
            newPoints[2] = points[1]
            newPoints[3] = points[2]
        }
        
        //kuadran 4
        if points[0].x > points[1].x && points[0].y < points[3].y{
            newPoints[0] = points[2]
            newPoints[2] = points[0]
            newPoints[3] = points[1]
            newPoints[1] = points[3]
        }
        
        //kuadran 3
        if points[0].x < points[3].x && points[0].y < points[1].y{
            newPoints[0] = points[1]
            newPoints[1] = points[2]
            newPoints[2] = points[3]
            newPoints[3] = points[0]
        }
        
        print("cek newpoint", newPoints)
        
        return newPoints
    }
    
    func scaleToMinOrMax(current: CGPoint, temp: CGPoint, position: CGPoint){
        let scale = CGFloat(current.y/temp.y)
        let minmaxPinch = SKAction.scale(by: scale, duration: 0.1)

        let snapnodes = nodes(at: position)
        snapnodes.forEach { snapnode in
            if snapnode.name != "dotTiles"{
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
    
    func centerDot(points: CGPoint) -> CGPoint{
        var savedCenter = CGPoint()
    
        let dotIndexColumn = dotTiles.tileColumnIndex(fromPosition: points)
        let dotIndexRow = dotTiles.tileRowIndex(fromPosition: points)
        let centerDot = dotTiles.centerOfTile(atColumn: dotIndexColumn, row: dotIndexRow)
        //itung berapa titiknya biar scalenya pas di titik tngh
        
        savedCenter = CGPoint(x: centerDot.x + 40, y: centerDot.y + 40)
        print(savedCenter)
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
    
    func createObjFromUser(points: [CGPoint]){
        let path = CGMutablePath()
        path.addLines(between: points)
        path.closeSubpath()
        
        let object = SKShapeNode(path: path)
        object.fillColor = .clear
        object.strokeColor = .black
        object.lineWidth = 2
        object.name = "anakanak"
        addChild(object)
    }
    
    func maximalBoundary(points: [CGPoint]) -> [CGPoint]{
        var newPoints = points
        
        if (points[0].x < CGFloat(-281) && points[0].y > CGFloat(281)) && (points[1].x > CGFloat(281) && points[1].y > CGFloat(281)) && (points[2].x > CGFloat(281) && points[2].y < CGFloat(-281)) && (points[3].x < CGFloat(-281) && points[3].y < CGFloat(-281)){
            print("masuk kesini ga")
            //HARUS DIGANTI BERDASARKAN SCALE MAX DARI UKURAN ASLI CORE DATA
            newPoints[0] = CGPoint(x: CGFloat(-280.5), y: CGFloat(280.5))
            newPoints[1] = CGPoint(x: CGFloat(280.5), y: CGFloat(280.5))
            newPoints[2] = CGPoint(x: CGFloat(280.5), y: CGFloat(-280.5))
            newPoints[3] = CGPoint(x: CGFloat(-280.5), y: CGFloat(-280.5))
        }else if (points[0].x < CGFloat(-281) && points[0].y > CGFloat(281)) && (points[1].x > CGFloat(281) && points[1].y > CGFloat(281)){
            print("atas kanan kiri")
            newPoints[0] = CGPoint(x: CGFloat(-280.5), y: CGFloat(280.5))
            newPoints[1] = CGPoint(x: CGFloat(280.5), y: CGFloat(280.5))
            newPoints[2] = CGPoint(x: newPoints[0].x, y: points[2].y)
            newPoints[3] = CGPoint(x: newPoints[1].x, y: points[3].y)
        }else if (points[1].x > CGFloat(281) && points[1].y > CGFloat(281)) && (points[2].x > CGFloat(281) && points[2].y < CGFloat(-281)){
            print("kanan atas bawah")
            newPoints[1] = CGPoint(x: CGFloat(280.5), y: CGFloat(280.5))
            newPoints[2] = CGPoint(x: CGFloat(280.5), y: CGFloat(280.5))
            newPoints[3] = CGPoint(x: points[3].x, y: newPoints[2].y)
            newPoints[0] = CGPoint(x: points[0].x, y: newPoints[1].y)
        }else if (points[2].x > CGFloat(281) && points[2].y < CGFloat(-281)) && (points[3].x < CGFloat(-281) && points[3].y < CGFloat(-281)){
            print("bawah kanan kiri")
            newPoints[2] = CGPoint(x: CGFloat(280.5), y: CGFloat(-280.5))
            newPoints[3] = CGPoint(x: CGFloat(-280.5), y: CGFloat(-280.5))
            newPoints[0] = CGPoint(x: newPoints[3].x, y: points[0].y)
            newPoints[1] = CGPoint(x: newPoints[2].x, y: points[1].y)
        }else if (points[3].x < CGFloat(-281) && points[3].y < CGFloat(-281)) && (points[0].x < CGFloat(-281) && points[0].y > CGFloat(281)){
            print("kiri atas bawah")
            newPoints[0] = CGPoint(x: CGFloat(-280.5), y: CGFloat(280.5))
            newPoints[3] = CGPoint(x: CGFloat(-280.5), y: CGFloat(-280.5))
            newPoints[1] = CGPoint(x: points[1].x, y: newPoints[0].y)
            newPoints[2] = CGPoint(x: points[2].x, y: newPoints[3].y)
        }else if points[0].x < CGFloat(-281) && points[0].y > CGFloat(281){
            print("kiri atas")
            newPoints[0] = CGPoint(x: CGFloat(-280.5), y: CGFloat(280.5))
            newPoints[1] = CGPoint(x: points[1].x, y: newPoints[0].y)
            newPoints[2] = CGPoint(x: points[2].x, y: points[2].y)
            newPoints[3] = CGPoint(x: newPoints[0].x, y: points[3].y)
        }else if points[1].x > CGFloat(281) && points[1].y > CGFloat(281){
            print("atas kanan")
            newPoints[1] = CGPoint(x: CGFloat(280.5), y: CGFloat(280.5))
            newPoints[2] = CGPoint(x: newPoints[1].x, y: points[2].y)
            newPoints[3] = CGPoint(x: points[3].x, y: points[3].y)
            newPoints[0] = CGPoint(x: points[0].x, y: newPoints[1].y)
        }else if points[2].x > CGFloat(281) && points[2].y < CGFloat(-281){
            print("bawah kanan")
            newPoints[2] = CGPoint(x: CGFloat(280.5), y: CGFloat(-280.5))
            newPoints[3] = CGPoint(x: points[3].x, y: newPoints[2].y)
            newPoints[0] = CGPoint(x: points[0].x, y: points[0].y)
            newPoints[1] = CGPoint(x: newPoints[2].x, y: points[1].y)
        }else if points[3].x < CGFloat(-281) && points[3].y < CGFloat(-281){
            print("kiri bawah")
            newPoints[3] = CGPoint(x: CGFloat(-280.5), y: CGFloat(-280.5))
            newPoints[0] = CGPoint(x: newPoints[3].x, y: points[0].y)
            newPoints[1] = CGPoint(x: points[1].x, y: points[1].y)
            newPoints[2] = CGPoint(x: points[2].x, y: newPoints[3].y)
        }else if points[0].y > CGFloat(281) || points[1].y > CGFloat(281){
            print("atas")
            newPoints[0] = CGPoint(x: points[0].x, y: CGFloat(280.5))
            newPoints[1] = CGPoint(x: points[1].x, y: CGFloat(280.5))
            newPoints[2] = CGPoint(x: points[2].x, y: points[2].y)
            newPoints[3] = CGPoint(x: points[3].x, y: points[3].y)
        }else if points[1].x > CGFloat(281) || points[2].x > CGFloat(281){
            print("kanan")
            newPoints[1] = CGPoint(x: CGFloat(280.5), y: points[1].y)
            newPoints[2] = CGPoint(x: CGFloat(280.5), y: points[2].y)
            newPoints[3] = CGPoint(x: points[3].x, y: points[3].y)
            newPoints[0] = CGPoint(x: points[0].x, y: points[0].y)
        }else if points[2].y < CGFloat(-281) || points[3].y < CGFloat(-281){
            print("bawah")
            newPoints[2] = CGPoint(x: points[2].x, y: CGFloat(-280.5))
            newPoints[3] = CGPoint(x: points[3].x, y: CGFloat(-280.5))
            newPoints[0] = CGPoint(x: points[0].x, y: points[0].y)
            newPoints[1] = CGPoint(x: points[1].x, y: points[1].y)
        }else if points[3].x < CGFloat(-281) || points[0].x < CGFloat(-281){
            print("kiri")
            newPoints[3] = CGPoint(x: CGFloat(-280.5), y: points[3].y)
            newPoints[0] = CGPoint(x: CGFloat(-280.5), y: points[0].y)
            newPoints[1] = CGPoint(x: points[1].x, y: points[1].y)
            newPoints[2] = CGPoint(x: points[2].x, y: points[2].y)
        }
        
        return newPoints
    }
    
    func minimalBoundary(points: [CGPoint]) -> [CGPoint]{
        var newPoints = points
        
        if countDistance(dot1: points[0], dot2: points[1]) < CGFloat(80) && countDistance(dot1: points[1], dot2: points[2]) < CGFloat(80) && countDistance(dot1: points[2], dot2: points[3]) < CGFloat(80) && countDistance(dot1: points[3], dot2: points[0]) < CGFloat(80){
            //HARUS DIGANTI BERDASARKAN UKURAN ASLI DARI CORE DATA
            print("kecil semua sisinya")
            newPoints[0] = CGPoint(x: CGFloat(-40.5), y: CGFloat(40.5))
            newPoints[1] = CGPoint(x: CGFloat(40.5), y: CGFloat(40.5))
            newPoints[2] = CGPoint(x: CGFloat(40.5), y: CGFloat(-40.5))
            newPoints[3] = CGPoint(x: CGFloat(-40.5), y: CGFloat(-40.5))
        }
        
        if countDistance(dot1: points[0], dot2: points[1]) < CGFloat(80) && countDistance(dot1: points[2], dot2: points[3]) < CGFloat(80){
            print("lebarnya kekecilan")
            newPoints[0] = CGPoint(x: CGFloat(-40.5), y: points[0].y)
            newPoints[1] = CGPoint(x: CGFloat(40.5), y: points[1].y)
            newPoints[2] = CGPoint(x: CGFloat(40.5), y: points[2].y)
            newPoints[3] = CGPoint(x: CGFloat(-40.5), y: points[3].y)
        }
        
        if countDistance(dot1: points[0], dot2: points[3]) < CGFloat(80) && countDistance(dot1: points[1], dot2: points[2]) < CGFloat(80){
            print("lebarnya kekecilan")
            newPoints[0] = CGPoint(x: points[0].y, y: CGFloat(40.5))
            newPoints[1] = CGPoint(x: points[1].y, y: CGFloat(40.5))
            newPoints[2] = CGPoint(x: points[2].y, y: CGFloat(-40.5))
            newPoints[3] = CGPoint(x: points[3].y, y: CGFloat(-40.5))
        }
        
        return newPoints
    }
    
    func reachMaximal(points: [CGPoint]) -> Bool{
        if (points[0].x < CGFloat(-281) || points[0].y > CGFloat(281)) || (points[1].x > CGFloat(281) || points[1].y > CGFloat(281)) || (points[2].x > CGFloat(281) || points[2].y < CGFloat(-281)) || (points[3].x < CGFloat(-281) || points[3].y < CGFloat(-281)){
            return true
        }else{
            return false
        }
    }
    
    func reachMinimal(points: [CGPoint]) -> Bool{
        if countDistance(dot1: points[0], dot2: points[1]) < CGFloat(80) || countDistance(dot1: points[1], dot2: points[2]) < CGFloat(80) || countDistance(dot1: points[2], dot2: points[3]) < CGFloat(80) || countDistance(dot1: points[3], dot2: points[0]) < CGFloat(80){
            return true
        }else{
            return false
        }
    }
}
