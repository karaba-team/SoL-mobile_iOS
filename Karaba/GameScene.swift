//
//  GameScene.swift
//  Karaba
//
//  Created by Rem Remy on 14/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import SpriteKit
import GameplayKit

struct xYCoor {
    var x = 0
    var y = 0
    var dotIndex = 0
    var dotSize = 5

    init(x : Int, y : Int, dotIndex : Int) {
        self.x = x
        self.y = y
        self.dotIndex = dotIndex
    }
}
var xy = [xYCoor]()

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var circle = [SKShapeNode]()
    
    override func didMove(to view: SKView) {
        
        let backgroundTexture = SKTexture(imageNamed: "dot.png")
        let backgroundDefinition = SKTileDefinition(texture: backgroundTexture)
        let backgroundGroup = SKTileGroup(tileDefinition: backgroundDefinition)
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.fontSize = CGFloat(integerLiteral: 80)
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
        var count = 1
        print(view.bounds.height)
        print(view.bounds.width)
        print(view.frame.height)
        print(view.frame.width)
        print(view.frame.maxX)
        print(view.frame.maxY)
        print(view.bounds.minX)
        print(view.bounds.minY)
        for y in stride(from: 55, to: view.bounds.height, by: (view.bounds.height-110)/11+5){
            for x in stride(from: 32, to: view.bounds.width-32, by: (view.bounds.width-94)/5+5){
                let newDot = xYCoor(x: Int(x), y: Int(y), dotIndex: count)
                xy.append(newDot)
                
                print("index \(newDot.x) \(newDot.y)")
                count += 1
            }
        }
        for data in xy{
           let frame = CGRect(x: data.x, y: data.y , width: 5, height: 5)
           if data.y == 55{
               for x in stride(from: 32, to: view.bounds.width-32, by: 8){
                   let frame = CGRect(x: x, y: 60 , width: 10, height: 10)
               }
           }
            let dot = SKShapeNode(circleOfRadius: 5)
            dot.position = frame.origin
            
           
           circle.append(dot)
       }
        for data in circle{
            data.fillColor = .gray
            self.addChild(data)
            print(data.frame.origin.x)
            print(data.frame.origin.y)
        }
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
