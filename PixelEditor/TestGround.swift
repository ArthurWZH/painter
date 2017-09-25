//
//  testGround.swift
//  PixelEditor
//
//  Created by 王子豪 on 2017/5/20.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import SceneKit

class TestGround: SKScene{
    override func didMove(to view: SKView) {
        var image = UIImage(named: "3")
        
        let aPiece = LargePiece(image: image!, coordinate: Point(x: 0, y: 0))
        
        let bPiece = LargePiece(image: image!, coordinate: Point(x: 32, y: 0))
        var isLinked = true
        var linkedTimes = 0
        var linkedAreaID = 0
        
        var newAreaIDX = [Int]()
        var newAreaIDY = [Int]()
        var areaIDX = [Int]()
        var areaIDY = [Int]()
        var fistTimeAddElementID = true
        // initialize newAreasID
        for index in 0...31{
            if(fistTimeAddElementID){
                fistTimeAddElementID = false
                newAreaIDX.append(bPiece.midInputPixelsAreaID[0][index])
            }
            else{
                var isSame = false
                for k in 0...newAreaIDX.count-1{
                    isSame = isSame || newAreaIDX[k] == bPiece.midInputPixelsAreaID[0][index]
                }
                if(!isSame){
                    newAreaIDX.append(bPiece.midInputPixelsAreaID[0][index])
                }
            }
        }
        
        
        //initialize areasID,
        
        fistTimeAddElementID = true
        
        for index in 0...31{
            if(fistTimeAddElementID){
                fistTimeAddElementID = false
                areaIDX.append(aPiece.outputPixelsAreaID[0][index])
            }
            else{
                var isSame = false
                for k in 0...areaIDX.count-1{
                    isSame = isSame || areaIDX[k] == aPiece.outputPixelsAreaID[0][index]
                }
                if(!isSame){
                    areaIDX.append(aPiece.outputPixelsAreaID[0][index])
                }
            }
        }
        
        print(areaIDX.count, newAreaIDX.count)
    }
}
