//
//  whiteBoard.swift
//  PixelEditor
//
//  Created by Zihao Arthur Wang [STUDENT] on 2017/4/13.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import SpriteKit
import Foundation
import UIKit

struct Layer {
    var image = UIImage(named: "white")
    var frame = CGRect(x: 1, y: 1, width: 1, height: 1)
    var context = UIGraphicsGetCurrentContext(UIGraphicsBeginImageContext(CGSize(width: 1, height: 1)))
}

class WhiteBoard{
    var boardPen = BoerdPen()
    var layerLevel = 0
    var layers = [Layer()]
    var frame = CGRect(x: 1, y: 1, width: 1, height: 1)
    init(_frame: CGRect){
        
        self.frame = _frame
        layers[0].context = UIGraphicsGetCurrentContext(UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: self.frame.height)))
        for x in 0...Int(self.frame.width){
            for y in 0...Int(self.frame.height){
                layers[layerLevel].context!.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
                layers[layerLevel].context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
        }
        layers[0].context!.saveGState()
        layers[0].context!.restoreGState()
        layers[0].image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func getPainted(x: Int, y: Int){
        layers[layerLevel].context!.setFillColor(red: boardPen.currentColor.components.red, green: boardPen.currentColor.components.green, blue: boardPen.currentColor.components.blue, alpha: boardPen.currentColor.components.alpha)
        layers[layerLevel].context!.fill(CGRect(x: x, y: y, width: 3, height: 3))
        layers[0].context!.saveGState()
        layers[0].context!.restoreGState()
        layers[0].image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func ourComingImage()->UIImage{
        return layers[0].image!
    }
}
















































