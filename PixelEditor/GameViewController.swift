//
//  GameViewController.swift
//  PixelEditor
//
//  Created by 王子豪 on 2017/4/3.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        let scene = PainterStation(size: skView.bounds.size)
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
