//
//  GameScene.swift
//  Karaba
//
//  Created by Rem Remy on 14/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var dotTiles: SKTileMapNode!
    private var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var drawLayer: SKNode!
    private var previewLayer: SKNode!
    private var tempLineNode: SKShapeNode!
    
    override func didMove(to view: SKView) {
//        dotTiles = childNode(withName: "tiledots") as! SKTileMapNode
//        let backgroundTexture = SKTexture(imageNamed: "dot.png")
//        let backgroundDefinition = SKTileDefinition(texture: backgroundTexture)
//        let backgroundGroup = SKTileGroup(tileDefinition: backgroundDefinition)
    
        drawLayer = SKNode()
        drawLayer.name = "drawLayer"
        
        previewLayer = SKNode()
        previewLayer.name = "previewLayer"
        
        addChild(previewLayer)
        addChild(drawLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        startPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        let points = [startPoint,currentPoint]
        
        let lineNode = SKShapeNode()
        let linePath = CGMutablePath()
        
        linePath.addLines(between: points)
        lineNode.path = linePath
        lineNode.lineWidth = 5
        lineNode.strokeColor = .black
        
        previewLayer.removeAllChildren()
        previewLayer.addChild(lineNode)
        
        tempLineNode = lineNode
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previewLayer.removeAllChildren()
        drawLayer.addChild(tempLineNode)
        
        tempLineNode = nil
    }
    
}
