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
protocol GameViewControllerDelegate : class{
    func sendSKShapeNode(shape : SKShapeNode)
}
class GameViewController: UIViewController, SKViewDelegate{
    
    weak var delegate : GameViewControllerDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skView: SKView!
    
    var gameScene : GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollection()
//        self.view = SKView()
        if let view = skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as! GameScene
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
////        itemColor.remove(at: itemIndex)
////       collectionView.reloadData()
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
        let ySelect = ((frame.origin.y + collectionView.frame.origin.y - 5) / 2) + skView.frame.origin.y
        let xSelect = (frame.origin.x + 5) / 2 + skView.frame.origin.x
        let frameHeight = frame.size.height
        let frameWidth = frame.size.width
//        let polygons = [
//            [
//                CGPoint(x: xSelect, y: ySelect),
//                CGPoint(x: xSelect + frameWidth, y: ySelect),
//                CGPoint(x: xSelect + frameWidth, y: ySelect + frameHeight),
//                CGPoint(x: xSelect, y: ySelect + frameHeight),
//            ]
//        ]
        let polygons = [
            [
                CGPoint(x: 40, y: 40),
                CGPoint(x: 80, y: 40),
                CGPoint(x: 80, y: 80),
                CGPoint(x: 40, y: 80),
            ]
        ]
        let path = CGMutablePath()
        for points in polygons {
            path.addLines(between: points)
            path.closeSubpath()
        }
        let child1 = SKShapeNode(path: path)
//        child1.fillColor = UIColor(hexString: itemColor[itemIndex])!
        child1.fillColor = .red
        child1.strokeColor = .black
        child1.lineWidth = 0.5
//        self.delegate?.sendSKShapeNode(shape: child1)
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
extension GameViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragNDropItemCell", for: indexPath) as! DragNDropItemCell
        cell.testView.backgroundColor = UIColor(hexString: itemColor[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem(itemIndex: indexPath.row, frame : collectionView.layoutAttributesForItem(at: indexPath)!.frame)
    }
    
}
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
