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
class GameViewController: UIViewController, SKViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skView: SKView!
    
    var gameScene : CompoundScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollection()
//        self.view = SKView()
        if let view = skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "CompoundScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as? CompoundScene
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.setNeedsDisplay()
        }
    }

    func configCollection(){
        collectionView.register(UINib(nibName: "DragNDropItemCell", bundle: nil), forCellWithReuseIdentifier: "dragNDropItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
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
    var itemColor = ["#FA8072","#B22222","#008080","#DEB887","#8B0000","#00FA9A","#A0522D","#FFF8DC","#7B68EE","#D2691E"]
    var viewInVC = [UIView]()
//    func selectedItem(itemIndex:Int, frame : CGRect){
//        itemColor.remove(at: itemIndex)
//       collectionView.reloadData()
//
//        let ySelect = frame.origin.y + collectionView.frame.origin.y - 5
//        let xSelect = frame.origin.x + 5
//        let view = UIView(frame: CGRect(origin: CGPoint(x: xSelect, y: ySelect), size: frame.size))
//        view.backgroundColor = UIColor(hexString: itemColor[itemIndex])
//        view.alpha = 0
//        UIView.animate(withDuration: 0.1) {
//            view.alpha = 1.0
//        }
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
//        self.view.addSubview(view)
//    }
    func selectedItem(itemIndex:Int, frame : CGRect){
//        let ySelect = ((frame.origin.y + collectionView.frame.origin.y - 5) / 2) + skView.frame.origin.y
//        let xSelect = (frame.origin.x + 5) / 2 + skView.frame.origin.x
//        let frameHeight = frame.size.height
//        let frameWidth = frame.size.width
//        let polygons = [
//            [
//                CGPoint(x: xSelect, y: ySelect),
//                CGPoint(x: xSelect + frameWidth, y: ySelect),
//                CGPoint(x: xSelect + frameWidth, y: ySelect + frameHeight),
//                CGPoint(x: xSelect, y: ySelect + frameHeight),
//            ]
//        ]
        let xZero = (gameScene?.frame.minX)!
        let yZero = (gameScene?.frame.minY)! / 2 * -1
        let polygons = [
            [
                CGPoint(x: xZero, y: yZero),
                CGPoint(x: xZero + 80, y: yZero),
                CGPoint(x: xZero + 80, y: yZero + 80),
                CGPoint(x: xZero, y: yZero + 80),
            ]
        ]
        let path = CGMutablePath()
        for points in polygons {
            path.addLines(between: points)
            path.closeSubpath()
        }
        let child1 = SKShapeNode(path: path)
        child1.fillColor = UIColor(hexString: itemColor[itemIndex])!
//        gameScene?.selectedNode = child1
//        for points in polygons.first!{
//            gameScene?.tempCoor.append(points)
//        }
//        gameScene?.compoundSceneShapeNode.append(gameScene!.selectedNode)
        gameScene?.addChildFunc(shape: child1)
    }
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.y)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        } else if gestureRecognizer.state == UIGestureRecognizer.State.ended && (gestureRecognizer.view!.center.x < skView.frame.minX  || gestureRecognizer.view!.center.x > skView.frame.maxX || gestureRecognizer.view!.center.y < skView.frame.minY  || gestureRecognizer.view!.center.y > skView.frame.maxY){
            gestureRecognizer.view!.removeFromSuperview()
        }
    }
}


