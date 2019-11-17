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
    
    var whichScene = 0
    // 0 game scene
    // 1 compound
    @IBOutlet weak var lbGuide: UILabel!{
        didSet{
            lbGuide.textAlignment = .center
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skView: SKView!
    
    let polygon = [CGPoint(x: 0, y: 0), CGPoint(x: 50, y: 0),CGPoint(x: 50, y: 50), CGPoint(x: 0, y: 0)]
    
    var chapter13Scene : Chapter13Scene?
    var chapter12Scene : Chapter12Scene?
    var compoundScene : CompoundScene?
    var gameScene : GameScene?
    var cornerScene : CornerScene?
    var surroundScene : SurroundScene?
    var savedShapes = Shapes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedShapes = ShapeBentuk.getAllShape()
        print("SHAPES:", savedShapes)
        
        
        configCollection()
//        gameScene = scene as? gameScene
//        self.view = SKView()
        lbGuide.text = "I am square and\n I've been alone all my life"
        if let view = skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as? GameScene
                gameScene!.gameVC = self
                whichScene = 0
                collectionView.isHidden = true
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
            view.setNeedsDisplay()
        }
    }
    
    func getShapeScale(points: [CGPoint]) -> Float{
        return 0
    }

    func configCollection(){
        collectionView.register(UINib(nibName: "DragNDropItemCell", bundle: nil), forCellWithReuseIdentifier: "dragNDropItemCell")
        collectionView.register(UINib(nibName: "Chapter1ItemCell", bundle: nil), forCellWithReuseIdentifier: "chapter1ItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func changeScene(sceneNo : Int){
        whichScene = sceneNo
        print("SCN:", "Change to scene", sceneNo)
        
        UIView.animate(withDuration: 5.0, animations: {
            self.lbGuide.alpha = 0.0
        })
        
        if sceneNo == 0{

        } else if sceneNo == 1 {
            self.lbGuide.text = "I dream big even\nthough I feel empty"
            collectionView.isHidden = false
        } else if sceneNo == 2 {
            self.lbGuide.text = "I feel so empty and alone, sometimes\nI just want to curl up in the corner"
            collectionView.isHidden = false
        } else if sceneNo == 3 {
            self.lbGuide.text = "Even though I am surrounded,\nI still feel alone"
            collectionView.isHidden = false
        } else if sceneNo == 4 {
            self.lbGuide.text = "I am square, and there are three of us"
            collectionView.isHidden = false
        } else if sceneNo == 5 {
            self.lbGuide.text = "One of us is the boss"
            collectionView.isHidden = false
        } else if sceneNo == 6 {
            self.lbGuide.text = "We are always beside our boss,\nboth left and right"
            collectionView.isHidden = false
        } else if sceneNo == 7 {
            self.lbGuide.text = "Sometimes, our boss pressure weight us"
            collectionView.isHidden = false
        } else if sceneNo == 8 {
            self.lbGuide.text = "But, our boss support us\n with power"
            collectionView.isHidden = false
        }
        UIView.animate(withDuration: 5.0, animations: {
            self.lbGuide.alpha = 1.0
        })
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
    func reloadCollection(){
        savedShapes = ShapeBentuk.getAllShape()
        collectionView.reloadData()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    var itemColor = ["#FF0000"]
    var viewInVC = [UIView]()
    func selectedItem(itemIndex:Int, frame : CGRect){
        let xZero = -200
        let yZero = 200
        let polygons = [
            [
                CGPoint(x: xZero, y: yZero),
                CGPoint(x: xZero - 80, y: yZero),
                CGPoint(x: xZero - 80, y: yZero + 80),
                CGPoint(x: xZero, y: yZero + 80),
            ],
            [
                CGPoint(x: xZero, y: yZero),
                CGPoint(x: xZero - 80, y: yZero),
                CGPoint(x: xZero - 80, y: yZero + 80),
                CGPoint(x: xZero, y: yZero + 80),
            ]
        ]
        
//        let path = CGMutablePath()
//        for saveShape in savedShapes! {
//            path.addLines(between: saveShape.path)
//            path.closeSubpath()
//            let child1 = SKShapeNode(path: saves)
//            child1.fillColor = UIColor.white
//            child1.name = "anakanak"
//            if whichScene == 0{
//                gameScene?.addChildFunc(shape: child1)
//            } else if whichScene == 1{
//                compoundScene?.addChildFunc(shape: child1)
//            } else if whichScene == 2{
//                cornerScene?.addChildFunc(shape: child1)
//            } else if whichScene == 3{
//                surroundScene?.addChildFunc(shape: child1)
//            }
//        }
        
//        var shapes = [[CGPoint]()]
        var oneShape = [CGPoint]()
        
        //untuk banyak shape
//        for shape in stride(from: 0, to: savedShapes.count, by: 1){
//            oneShape.removeAll()
//            for coordinate in stride(from: 0, to: savedShapes[shape].path.count, by: 1){
//                oneShape.append(CGPoint(x: savedShapes[shape].path[coordinate].x, y: savedShapes[shape].path[coordinate].y))
//            }
//            shapes.append(oneShape)
//        }

        oneShape.append(CGPoint(x: -40, y: 40))
        oneShape.append(CGPoint(x: 40, y: 40))
        oneShape.append(CGPoint(x: 40, y: -40))
        oneShape.append(CGPoint(x: -40, y: -40))
       
        
        let path = CGMutablePath()
        path.addLines(between: oneShape)
        path.closeSubpath()
//        for points in shapes {
//            path.addLines(between: points)
//            path.closeSubpath()
//        }
        let child1 = [SKShapeNode(path: path)]
        if whichScene == 0{
            for data in child1{
                data.fillColor = .white
                data.strokeColor = .black
                data.name = "anakanak"
                gameScene?.addChildFunc(shape: data)
            }
        } else if whichScene == 1{
            for data in child1{
                data.fillColor = .white
                data.strokeColor = .black
                data.name = "anakanak"
                compoundScene?.addChildFunc(shape: data)
                compoundScene?.currentFrameDots = oneShape
            }
        } else if whichScene == 2{
            for data in child1{
                data.fillColor = .white
                data.strokeColor = .black
                data.name = "anakanak"
                cornerScene?.addChildFunc(shape: data)
            }
        } else if whichScene == 3{
            for data in child1{
                if itemIndex == 1{
                    data.fillColor = .black
                    data.name = "user"
                }else{
                    data.fillColor = .white
                    data.name = "anakanak"
                }
                data.strokeColor = .black
                surroundScene?.addChildFunc(shape: data)
                
                let moveRect = SKAction.move(to: CGPoint(x: -240, y: 240), duration: 0)
                data.run(moveRect)
            }
        } else if whichScene == 5{
            for data in child1{
                data.fillColor = .blue
                data.name = "anakanak"
                data.strokeColor = .clear
                chapter12Scene?.addChildFunc(shape: data)
                
                let moveRect = SKAction.move(to: CGPoint(x: -240, y: 240), duration: 0)
                data.run(moveRect)
            }
        } else if whichScene == 6{
            for data in child1{
                data.fillColor = .blue
                data.name = "anakanak"
                data.strokeColor = .clear
                chapter13Scene?.addChildFunc(shape: data)
                
                let moveRect = SKAction.move(to: CGPoint(x: -240, y: 240), duration: 0)
                data.run(moveRect)
            }
        }
        
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
extension GameViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //ganti jadi count dari shape data yg disimpen
        return savedShapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if whichScene <= 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragNDropItemCell", for: indexPath) as! DragNDropItemCell

            let shape = savedShapes[indexPath.row]
            cell.setShape(shape, indexColor: indexPath.row)
    //        cell.drawShape(points: savedShapes[indexPath.row], scale: 0)

            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapter1ItemCell", for: indexPath) as! Chapter1ItemCell
//
//            let shape = savedShapes[indexPath.row]
//            cell.setShape(shape, indexColor: indexPath.row)
//    //        cell.drawShape(points: savedShapes[indexPath.row], scale: 0)
//
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem(itemIndex: indexPath.row, frame : collectionView.layoutAttributesForItem(at: indexPath)!.frame)
    }
    
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    
}
