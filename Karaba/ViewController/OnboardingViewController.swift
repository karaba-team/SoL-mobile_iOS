//
//  OnboardingViewController.swift
//  Karaba
//
//  Created by Rem Remy on 18/10/19.
//  Copyright © 2019 Rem Remy. All rights reserved.
//

import UIKit
import SceneKit
import GameplayKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var quotesLbl: UILabel!{
        didSet{
            quotesLbl.numberOfLines = 0
            quotesLbl.text = "\"Design can be art.\nDesign can be aesthetics.\nDesign is so simple,\nthat's why\nit is so complicated.\""
            quotesLbl.font = UIFont.systemFont(ofSize: 22)
        }
    }
    @IBOutlet weak var quotesOwnerLbl: UILabel!{
        didSet{
            quotesOwnerLbl.numberOfLines = 0
            quotesOwnerLbl.text = "Paul Rand\ngraphic designer"
            quotesOwnerLbl.font = UIFont.systemFont(ofSize: 14)
        }
    }
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var circleView: UIView!{
        didSet{
            circleView.layer.cornerRadius = circleView.frame.size.height/2
            circleView.clipsToBounds = true
            circleView.isHidden = true
            circleView.backgroundColor = .black
        }
    }
    
    
    
    @IBOutlet weak var circleViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        fadeOut()
    }
    
    func fadeOut(){
        self.circleViewTopConstraint.constant = self.logoImg.frame.origin.y  + self.logoImg.frame.height/2 + self.circleView.frame.size.height
        self.view.needsUpdateConstraints()
        UIView.animate(withDuration: 3.0, animations: {
            self.quotesLbl.alpha = 0.0
            self.quotesOwnerLbl.alpha = 0.0
        }) { (finished) in
            UIView.animate(withDuration: 1.0, animations: {
                self.logoImg.alpha = 0.0
                self.circleView.isHidden = false
            }) { (finishTwo) in
                self.quotesLbl.isHidden = true
                self.quotesOwnerLbl.isHidden = true
                self.logoImg.isHidden = true
                UIView.animate(withDuration: 3.0, animations: { //GANTI DISINI JADI 3 DETIK WKKKWKWKKWKWKWK BOMAT
                    self.circleViewTopConstraint.constant = 15.0
                    self.view.layoutIfNeeded()
                }) { (finishThree) in
                    let gameSceneVC = GameViewController()
                    gameSceneVC.view = SKView()
                    self.navigationController?.pushViewController(gameSceneVC, animated: true)
                }
            } 
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
