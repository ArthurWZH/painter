//
//  PainterStation.swift
//  PixelEditor
//
//  Created by Zihao Arthur Wang [STUDENT] on 2017/4/15.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import SpriteKit

import UIKit

class PainterStation: SKScene{
    var touchLocation: CGPoint = CGPoint(x: 0, y: 0)
   
    var whiteBoard = WhiteBoard(_frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    var boardView = [UIImageView(image: UIImage(named: "test"))]
    var lastTimeLocation: CGPoint? = nil
    var redValueSlider = UISlider(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    var greenValueSlider = UISlider(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    var blueValueSlider = UISlider(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    var alphaValueSlider = UISlider(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    var colorPresenterView = UIImageView(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
    
    override func didMove(to view: SKView){
        
        colorPresenterView.frame = CGRect(x: self.size.width*4/5, y:  self.size.height*16/20, width: self.size.width/6, height: self.size.height/6)
        self.view?.addSubview(colorPresenterView)
        
        boardView[0].image = whiteBoard.layers[0].image
        boardView[0].frame = CGRect(x: self.size.width/22, y: self.size.height/4, width: self.size.width/1.1, height: self.size.width/1.1)
        self.view?.addSubview(boardView[0])
        
        redValueSlider = UISlider(frame: CGRect(x: self.size.width/4, y: self.size.height*16/20, width: self.size.width/2, height: 3))
        redValueSlider.minimumValue = 0
        redValueSlider.maximumValue = 1
        redValueSlider.value = 0
        self.view?.addSubview(redValueSlider)
        
        greenValueSlider = UISlider(frame: CGRect(x: self.size.width/4, y: self.size.height*17/20, width: self.size.width/2, height: 3))
        greenValueSlider.minimumValue = 0
        greenValueSlider.maximumValue = 1
        greenValueSlider.value = 0
        self.view?.addSubview(greenValueSlider)
        
        blueValueSlider = UISlider(frame: CGRect(x: self.size.width/4, y: self.size.height*18/20, width: self.size.width/2, height: 3))
        blueValueSlider.minimumValue = 0
        blueValueSlider.maximumValue = 1
        blueValueSlider.value = 0
        self.view?.addSubview(blueValueSlider)
        
        alphaValueSlider = UISlider(frame: CGRect(x: self.size.width/4, y: self.size.height*19/20, width: self.size.width/2, height: 3))
        alphaValueSlider.minimumValue = 0
        alphaValueSlider.maximumValue = 1
        alphaValueSlider.value = 1
        self.view?.addSubview(alphaValueSlider)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouches = touches as NSSet
        let touch = myTouches.anyObject()
        var currentlocation = (touch as AnyObject).location(in: self)
        currentlocation = translateCoordinates(coordinates: currentlocation)
        whiteBoard.getPainted(x: Int(currentlocation.x), y: Int(currentlocation.y))
        lastTimeLocation = currentlocation

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouches = touches as NSSet
        let touch = myTouches.anyObject()
        var currentlocation = (touch as AnyObject).location(in: self)
        currentlocation = translateCoordinates(coordinates: currentlocation)
        print(currentlocation)
        if(lastTimeLocation == nil){
            whiteBoard.getPainted(x: Int(currentlocation.x), y: Int(currentlocation.y))
        }
        else{
            lineUp(pointOne: lastTimeLocation!, pointTwo: currentlocation)
        }
        lastTimeLocation = currentlocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTimeLocation = nil
    }
    
    func lineUp(pointOne: CGPoint, pointTwo: CGPoint){
        let gradient = (pointTwo.y-pointOne.y)/(pointTwo.x-pointOne.x)
        let constent = pointOne.y-gradient*pointOne.x
        print(Int(pointOne.x))
        print(Int(pointTwo.x))
        print(Int(pointOne.y))
        print(Int(pointTwo.y))
        if(pointTwo.x-pointOne.x == 0){
            if(Int(pointOne.y) > Int(pointTwo.y)){
                for y in Int(pointTwo.y)...Int(pointOne.y){
                    whiteBoard.getPainted(x: Int(pointTwo.x), y: y)
                }
            }
            else{
                for y in Int(pointOne.y)...Int(pointTwo.y){
                    whiteBoard.getPainted(x: Int(pointTwo.x), y: y)
                }
            }
            print(true)
        }
        else if(pointTwo.y==pointOne.y){
            if(Int(pointOne.x) > Int(pointTwo.x)){
                for x in Int(pointTwo.x)...Int(pointOne.x){
                    print(Int(pointOne.x*gradient+constent))
                    whiteBoard.getPainted(x: x, y: Int(pointTwo.y))
                }
            }
            else{
                for x in Int(pointOne.x)...Int(pointTwo.x){
                    print(Int(pointOne.x*gradient+constent))
                    whiteBoard.getPainted(x: x, y: Int(pointTwo.y))
                }
            }
        }
        else{
            if(Int(pointOne.x) > Int(pointTwo.x)){
                for x in Int(pointTwo.x)...Int(pointOne.x){
                    print(x, Int(CGFloat(x)*gradient+constent))
                    whiteBoard.getPainted(x: x, y: Int(CGFloat(x)*gradient+constent))
                }
            }
            else{
                for x in Int(pointOne.x)...Int(pointTwo.x){
                    print(x, Int(CGFloat(x)*gradient+constent))
                    whiteBoard.getPainted(x: x, y: Int(CGFloat(x)*gradient+constent))
                }
            }
            if(Int(pointOne.y) > Int(pointTwo.y)){
                for y in Int(pointTwo.y)...Int(pointOne.y){
                    print(Int((CGFloat(y)-constent)/gradient), y)
                    whiteBoard.getPainted(x: Int((CGFloat(y)-constent)/gradient), y: y)
                }
            }
            else{
                for y in Int(pointOne.y)...Int(pointTwo.y){
                    print(Int((pointOne.y-constent)/gradient), y)
                    whiteBoard.getPainted(x: Int((CGFloat(y)-constent)/gradient), y: y)
                }
            }
        }
    }
    
    func translateCoordinates(coordinates: CGPoint)->CGPoint{
        var translated = coordinates
        translated.x = coordinates.x-self.boardView[0].frame.origin.x
        translated.x = translated.x*500/(self.size.width/1.1)
        translated.y = coordinates.y-self.boardView[0].frame.origin.y
        translated.y = 500-translated.y*500/(self.size.width/1.1)
        return translated
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        boardView[0].image = whiteBoard.layers[0].image
        whiteBoard.boardPen.currentColor = UIColor(colorLiteralRed: redValueSlider.value, green: greenValueSlider.value, blue: blueValueSlider.value, alpha: alphaValueSlider.value)
        
        colorPresenterView.backgroundColor = UIColor(colorLiteralRed: redValueSlider.value, green: greenValueSlider.value, blue: blueValueSlider.value, alpha: 1)
    }
}




















