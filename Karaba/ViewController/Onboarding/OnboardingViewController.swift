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
    @IBOutlet weak var logoImg: UIImageView!{
        didSet{
            logoImg.alpha = 0.0
        }
    }
    @IBOutlet weak var circleView: UIView!{
        didSet{
            circleView.layer.cornerRadius = circleView.frame.size.height/2
            circleView.clipsToBounds = true
            circleView.alpha = 0.0
            circleView.backgroundColor = .black
        }
    }
    
    @IBOutlet weak var circleViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicPlayer.shared.startTutorialMusic()
        self.navigationController?.navigationBar.isHidden = true
        fadeOut()
        
    }
    
    func fadeOut(){
        self.view.needsUpdateConstraints()
        UIView.animate(withDuration: 5.0, animations: {
            self.quotesLbl.alpha = 0.0
            self.quotesOwnerLbl.alpha = 0.0
        }) { (finished) in
            UIView.animate(withDuration: 1.5, animations: {
                self.logoImg.alpha = 1.0
                self.circleView.isHidden = false
            }) { (finishTwo) in
                UIView.animate(withDuration: 2.0, animations: {
                    self.logoImg.alpha = 0.0
                    self.circleView.alpha = 1.0
                }) { (finishThree) in
                    UIView.animate(withDuration: 3.0, animations: {
                        self.circleViewTopConstraint.constant = 30.0
                        self.view.layoutIfNeeded()
                    }) { (finishFour) in
                        let gameSceneVC = GameViewController()
                        self.navigationController?.pushViewController(gameSceneVC, animated: true)
                    }
                }
            }
        }
    }
}
