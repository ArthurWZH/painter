//
//  WorkingStation.swift
//  PixelEditor
//
//  Created by 王子豪 on 2017/4/4.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class WorkingStation: SKScene{
    override func didMove(to view: SKView) {
        let view = UIImageView(image: filterforall.image)
        let height = (self.size.width/1.1)/(view.image?.size.width)!*(view.image?.size.height)!
        let frameForImage = CGRect(x: self.size.width/22, y: self.size.height/2, width: self.size.width/1.1, height: height)
        view.frame = frameForImage
        
        //filterforall.culcTheArc()
        //filterforall.blueFire()
        //filterforall.action()
        //filterforall.dePixelInRange(lowlimit: 100, highlimit: 255)
        //filterforall.initializeImageInfoData()
        filterforall.areaPresentor()
        view.image = filterforall.image
        self.view?.addSubview(view)
    }
}
