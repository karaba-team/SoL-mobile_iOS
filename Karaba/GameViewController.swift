//
//  GameViewController.swift
//  Karaba
//
//  Created by Rem Remy on 14/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var circle = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            view.setNeedsDisplay()
                    
                    print(view.frame.maxX)
                    print(view.frame.maxY)
                    print((view.frame.maxX-44-20*6)/5)
                    print(view.frame.maxX-44-20*6)
                    var count = 1
                    for y in stride(from: 55, to: view.frame.maxY, by: (view.frame.maxY-110)/11+5){
                        for x in stride(from: 32, to: view.frame.maxX-32, by: (view.frame.maxX-94)/5+5){
                            let newDot = xYCoor(x: Int(x), y: Int(y), dotIndex: count)
                            xy.append(newDot)
                            
                            print("index \(newDot.x) \(newDot.y)")
                            count += 1
                        }
                    }
            //        DemoView().dotCoor = xy
            //        demo.dotCoor = xy
                    print("xy punya \(xy)")
                    for data in xy{
                        let frame = CGRect(x: data.x, y: data.y , width: 5, height: 5)
                        if data.y == 55{
                            for x in stride(from: 32, to: view.frame.maxX-32, by: 8){
                                let frame = CGRect(x: x, y: 60 , width: 10, height: 10)
                            }
                        }
                        let dot = UIView()
                        dot.frame = frame
                        dot.backgroundColor = .red
                        
                        circle.append(dot)
                    }
                    for data in circle{
                        data.backgroundColor = .gray
                        data.layer.cornerRadius = data.frame.size.width/2
//                        view.addSubview(data)
                    }
            //        for data in rect{
            //            data.backgroundColor = .black
            //            view.addSubview(data)
            //        }
                    let width: CGFloat = 414.0
                    let height: CGFloat = 896.0
                
                    let demoView = DemoView(frame: CGRect(x: self.view.frame.size.width/2 - width/2, y: self.view.frame.size.height/2 - height/2, width: width, height: height))
                        
                    self.view.addSubview(demoView)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
