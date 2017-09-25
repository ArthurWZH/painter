//
//  FilterForAll.swift
//  PixelEditor
//
//  Created by 王子豪 on 2017/4/4.
//  Copyright © 2017年 王子豪. All rights reserved.
//


import SpriteKit

import UIKit

extension CALayer {
    
    func colorOfPoint(point:CGPoint) -> UIColor
    {
        var pixel:[CUnsignedChar] = [0,0,0,0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace,bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        self.render(in: context!)
        
        let red:CGFloat = CGFloat(pixel[0])
        let green:CGFloat = CGFloat(pixel[1])
        let blue:CGFloat = CGFloat(pixel[2])
        let alpha:CGFloat = CGFloat(pixel[3])
        
        
        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)
        
        return color
    }
}

extension UIColor {
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
}

struct Point{
    var x = 0
    var y = 0
}

struct Size{
    var width = 0
    var height = 0
}

class Range{
    var high:Float = 1
    var low:Float = 0
    init(high: Float, low: Float) {
        self.high = high
        self.low = low
    }
    func getDifference() -> Float {
        return self.high-self.low
    }
}

struct ColorRange{
    var redRange = Range(high: 0, low: 255)
    var greenRange = Range(high: 0, low: 255)
    var blueRange = Range(high: 0, low: 255)
}

struct DataRGB{
    var red:Float = 0
    var green:Float = 0
    var blue:Float = 0
}

struct DataOfColor{
    
    var rgb = DataRGB()
    
    var redRange = 0
    var greenRange = 0
    var blueRange = 0
}
struct TriCoordinate{
    var x = 0
    var y = 0
    var z = 0
}
struct UnitArea {
    var mean = DataOfColor()
    var pointsInArea = [Point()]
    var rangeColor = ColorRange()
    var colorDataForPoints = [DataOfColor]()
    var mode = 0
}

struct AreaMap {
    var areas = [UnitArea()]
}

class FilterForAll{
    init(){}
    var image = UIImage(named: "3")
    
    func identifyArea(){
        
    }
    
    
    func areaPresentor(){
        
        let imageInfoData = ImageInfoData(image: image!)
        print(imageInfoData.areaMap.areas.count)
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        var isBlack = true
        for i in 0...imageInfoData.areaMap.areas.count-1{
            print(imageInfoData.areaMap.areas[i].pointsInArea.count)
            var color = 0
            if(isBlack){
                color = 0
            }
            else{
                color = 1
            }
            for k in 0...imageInfoData.areaMap.areas[i].pointsInArea.count-1{
                print("x: \(CGFloat(imageInfoData.areaMap.areas[i].pointsInArea[k].x)), y: \(CGFloat(imageInfoData.areaMap.areas[i].pointsInArea[k].y))")
                
                context!.setFillColor(red: CGFloat(color), green: CGFloat(color), blue: CGFloat(color), alpha: 1)
                context!.fill(CGRect(x:imageInfoData.areaMap.areas[i].pointsInArea[k].x, y: imageInfoData.areaMap.areas[i].pointsInArea[k].y, width: 1, height: 1))
            }
            isBlack = !isBlack
        }
        /*
        for i in 0...Int((image?.size.height)!){
            for k in 0...Int((image?.size.width)!){
                context!.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
                context!.fill(CGRect(x: i, y: k, width: 1, height: 1))
            }
        }*/
        context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func transformFromInfoDataToAreasMap(infoData: ImageInfoData)->AreaMap{
        var draftMap = AreaMap()
        var finalMap = AreaMap()
        for x in 0...Int((image?.size.width)!/16){
            for y in 0...Int((image?.size.height)!/16){
                
            }
        }
        return finalMap
    }
    
    func isInTheRange (color: UIColor, range: CGFloat) -> Bool{
        var inTheRange = true
        inTheRange = inTheRange && color.components.red < range
        inTheRange = inTheRange && color.components.green < range
        inTheRange = inTheRange && color.components.blue < range
        return inTheRange
    }
    
    
    func differenceOfColorIndex(colorOne: UIColor, ColorTwo: UIColor) -> UIColor{
        var red = colorOne.components.red-ColorTwo.components.red
        var blue = colorOne.components.blue-ColorTwo.components.blue
        var green = colorOne.components.green-ColorTwo.components.green
        if(red < 0){red = -red}
        if(green < 0){green = -green}
        if(blue < 0){blue = -blue}
        return UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: 1)
    }
    
    func culcGradient(coorOne: Point, coorTwo: Point) -> Float{
        return Float(coorOne.y-coorTwo.y)/Float(coorOne.x-coorTwo.x)
    }
    
    func getMidPoint(coorOne: Point, coorTwo: Point) -> Point{
        return Point(x: (coorOne.x+coorTwo.x)/2, y: (coorOne.y+coorTwo.y)/2)
    }
    
    func getConstent(gradient: Float, point: Point) -> Float{
        return Float(point.x)*gradient-Float(point.y)
    }
    
    func culcTheArc(){
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        _ = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        var pointOne = Point(x: 0, y: 0)
        var pointTwo = Point(x: 0, y: 0)
        var mainPointOne = Point(x: 0, y: 0)
        var mainPointTwo = Point(x: 0, y: 0)
        var mainPointThree = Point(x: 0, y: 0)
        var gradientOne: Float = 0
        var gradientTwo: Float = 0
        
        
        var isOnLeft = false
        var isOnRight = false
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        
        for y in 0...Int((image?.size.height)!) {
            var isThePoint = false
            isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: 1, y: y)).components.green > 40
            isThePoint = isThePoint && imageView.layer.colorOfPoint(point: CGPoint(x: 1, y: y+1)).components.green > 40
            isThePoint = isThePoint && imageView.layer.colorOfPoint(point: CGPoint(x: 1, y: y+2)).components.green > 40
            isThePoint = isThePoint && imageView.layer.colorOfPoint(point: CGPoint(x: 1, y: y+3)).components.green > 40
            if(isThePoint){
                print(1, y)
                isOnLeft = true
                pointOne.x = 1
                pointOne.y = y
                break
            }
        }
        
        for y in 0...Int((image?.size.height)!) {
            var isThePoint = false
            isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: Int((image?.size.width)!)-2, y: y)).components.green > 40
            isThePoint = isThePoint && imageView.layer.colorOfPoint(point: CGPoint(x: Int((image?.size.width)!)-2, y: y+1)).components.green > 40
            isThePoint = isThePoint && imageView.layer.colorOfPoint(point: CGPoint(x: Int((image?.size.width)!)-2, y: y+2)).components.green > 40
            isThePoint = isThePoint && imageView.layer.colorOfPoint(point: CGPoint(x: Int((image?.size.width)!)-2, y: y+3)).components.green > 40
            if(isThePoint){
                print((image?.size.width)!-2, y)
                isOnRight = true
                pointTwo.x = Int((image?.size.width)!)-2
                pointTwo.y = y
                break
            }
        }
        
        if(isOnLeft && !isOnRight){
            for x in 0...Int((image?.size.width)!) {
                var isThePoint = false
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+1, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+2, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+3, y: Int((image?.size.height)!)-2)).components.green > 40
                if(isThePoint){
                    print(x, (image?.size.height)!-2)
                    isOnRight = true
                    pointTwo.x = x
                    pointTwo.y = Int((image?.size.height)!)-2
                    break
                }
            }
        }
        
        if(!isOnLeft && isOnRight){
            for x in Int((image?.size.width)!)...0 {
                var isThePoint = false
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+1, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+2, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+3, y: Int((image?.size.height)!)-2)).components.green > 40
                if(isThePoint){
                    print(x, (image?.size.width)!-2)
                    isOnLeft = true
                    pointOne.x = x
                    pointOne.y = Int((image?.size.height)!)-2
                    break
                }
            }
        }
        
        if(!isOnLeft && isOnRight){
            for x in Int((image?.size.width)!)...0 {
                var isThePoint = false
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+1, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+2, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+3, y: Int((image?.size.height)!)-2)).components.green > 40
                if(isThePoint){
                    print(x, (image?.size.width)!-2)
                    isOnLeft = true
                    pointOne.x = x
                    pointOne.y = Int((image?.size.height)!)-2
                    break
                }
            }
            
            for x in 0...Int((image?.size.width)!) {
                var isThePoint = false
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+1, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+2, y: Int((image?.size.height)!)-2)).components.green > 40
                isThePoint = imageView.layer.colorOfPoint(point: CGPoint(x: x+3, y: Int((image?.size.height)!)-2)).components.green > 40
                if(isThePoint){
                    print(x, (image?.size.width)!-2)
                    isOnRight = true
                    pointTwo.x = x
                    pointTwo.y = Int((image?.size.height)!)-2
                    break
                }
            }
            
            
        }
        
        gradientOne = culcGradient(coorOne: pointOne, coorTwo: pointTwo)
        mainPointOne = getMidPoint(coorOne: pointOne, coorTwo: pointTwo)
        let constentforOne = getConstent(gradient: gradientOne, point: mainPointOne)
        
        if(constentforOne > Float((image?.size.height)!)){
            let lastTimeValue = imageView.layer.colorOfPoint(point: CGPoint(x: Int((Float((image?.size.height)!)-constentforOne)/gradientOne), y: Int((image?.size.height)!)-2))
            var isblack = lastTimeValue.components.red < 40
            isblack = lastTimeValue.components.blue < 40 && isblack
            isblack = lastTimeValue.components.green < 40 && isblack
            let identifyValue = isblack
            for y in Int((image?.size.height)!)...0{
                let valueInLoop = imageView.layer.colorOfPoint(point: CGPoint(x: Int((Float(y)-constentforOne)/gradientOne), y: y))
                isblack = valueInLoop.components.red < 40
                isblack = valueInLoop.components.blue < 40 && isblack
                isblack = valueInLoop.components.green < 40 && isblack
                if(isblack != identifyValue){
                    mainPointThree.x = Int((Float(y)-constentforOne)/gradientOne)
                    mainPointThree.y = y
                    break
                }
            }
        }
        
        else if(constentforOne < 0){
            let lastTimeValue = imageView.layer.colorOfPoint(point: CGPoint(x: Int((Float(0)-constentforOne)/gradientOne), y: Int((image?.size.height)!)-2))
            var isblack = lastTimeValue.components.red < 40
            isblack = lastTimeValue.components.blue < 40 && isblack
            isblack = lastTimeValue.components.green < 40 && isblack
            let identifyValue = isblack
            for y in 0...Int((image?.size.height)!){
                let valueInLoop = imageView.layer.colorOfPoint(point: CGPoint(x: Int((Float(y)-constentforOne)/gradientOne), y: y))
                isblack = valueInLoop.components.red < 40
                isblack = valueInLoop.components.blue < 40 && isblack
                isblack = valueInLoop.components.green < 40 && isblack
                if(isblack != identifyValue){
                    mainPointThree.x = Int((Float(y)-constentforOne)/gradientOne)
                    mainPointThree.y = y
                    break
                }
            }
        }
        
        else{
            let lastTimeValue = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: Int(constentforOne)))
            var isblack = lastTimeValue.components.red < 40
            isblack = lastTimeValue.components.blue < 40 && isblack
            isblack = lastTimeValue.components.green < 40 && isblack
            let identifyValue = isblack
            for x in 0...Int((image?.size.width)!){
                let valueInLoop = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: Int(gradientOne*Float(x)+constentforOne)))
                isblack = valueInLoop.components.red < 40
                isblack = valueInLoop.components.blue < 40 && isblack
                isblack = valueInLoop.components.green < 40 && isblack
                if(isblack != identifyValue){
                    mainPointThree.x = x
                    mainPointThree.y = Int(gradientOne*Float(x)+constentforOne)
                    break
                }
            }
        }
        
    }
    
    func redStyle(){
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        
        for x in 0...Int((image?.size.width)!) {
            for y in 0...Int((image?.size.height)!) {
                pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
                
                let everage = (pointColor.components.blue+pointColor.components.green)/2
                
                context!.setFillColor(red: 1, green: everage/255, blue: everage/255, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
            print("\(x)haha")
        }
        context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()

    }
    
    func redFire(){
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        for x in 0...Int((image?.size.width)!){
            for y in 0...Int((self.image?.size.height)!) {
                pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
                
                let everage = (pointColor.components.blue+pointColor.components.green)/2
                let blueIndex = everage+(pointColor.components.blue-everage)/10
                let green = everage+(pointColor.components.green-everage)/10
                let red = pointColor.components.red+30
                
                context!.setFillColor(red: red, green: green/255, blue: blueIndex/255, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
            print(x)
        }
        context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func blueFire(){
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        for x in 0...Int((image?.size.width)!){
            for y in 0...Int((self.image?.size.height)!) {
                pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
                
                let everage = (pointColor.components.red+pointColor.components.green)/2
                let red = everage+(pointColor.components.red-everage)/10
                let green = everage+(pointColor.components.green-everage)/10
                let blueIndex = pointColor.components.blue/everage*255
                
                context!.setFillColor(red: red/255, green: green/255, blue: blueIndex/255, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
            print(x)
        }
               context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func blueStyle(){
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        
        for x in 0...Int((image?.size.width)!) {
            for y in 0...Int((image?.size.height)!) {
                let pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
                
                var everage = (pointColor.components.red+pointColor.components.green)/2
                
        
                
                context!.setFillColor(red: everage/255, green: everage/255, blue: 1, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
            print("\(x)haha")
        }
        context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func dePixelInRange(lowlimit: Int, highlimit: Int){
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        
        for x in 1...Int((image?.size.width)!-1) {
            for y in 1...Int((image?.size.height)!-1) {
                var red:CGFloat = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y)).components.red
                var green:CGFloat = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y)).components.green
                var blue:CGFloat = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y)).components.blue
                
                let surrondingPixel = [imageView.layer.colorOfPoint(point: CGPoint(x: x+1, y: y)),
                                       imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y-1)),
                                       imageView.layer.colorOfPoint(point: CGPoint(x: x-1, y: y)),
                                       imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y+1))]
                
                let doubleSurrondingPixel = [imageView.layer.colorOfPoint(point: CGPoint(x: x+2, y: y)),
                                             imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y-2)),
                                             imageView.layer.colorOfPoint(point: CGPoint(x: x-2, y: y)),
                                             imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y+2))]
                
                var sum = 0
                var wrongTarget = 0
                for i in 0...3{
                    if(!isInTheRange(color: differenceOfColorIndex(colorOne: surrondingPixel[i], ColorTwo: imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))), range: CGFloat(lowlimit)) && isInTheRange(color: differenceOfColorIndex(colorOne: surrondingPixel[i], ColorTwo: imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))), range: CGFloat(highlimit))){sum+=1}
                    else{wrongTarget = i}
                }
                if(sum == 4){
                    red = (surrondingPixel[0].components.red+surrondingPixel[1].components.red+surrondingPixel[2].components.red+surrondingPixel[3].components.red)/4
                    blue = (surrondingPixel[0].components.blue+surrondingPixel[1].components.blue+surrondingPixel[2].components.blue+surrondingPixel[3].components.blue)/4
                    green = (surrondingPixel[0].components.green+surrondingPixel[1].components.green+surrondingPixel[2].components.green+surrondingPixel[3].components.green)/4
                }
                else if(sum == 3){
                    red = (surrondingPixel[0].components.red+surrondingPixel[1].components.red+surrondingPixel[2].components.red+surrondingPixel[3].components.red-surrondingPixel[wrongTarget].components.red)/3
                    blue = (surrondingPixel[0].components.blue+surrondingPixel[1].components.blue+surrondingPixel[2].components.blue+surrondingPixel[3].components.blue-surrondingPixel[wrongTarget].components.blue)/3
                    green = (surrondingPixel[0].components.green+surrondingPixel[1].components.green+surrondingPixel[2].components.green+surrondingPixel[3].components.green-surrondingPixel[wrongTarget].components.green)/3
                }
                else{
                    sum = 0
                    for i in 0...3{
                        if(!isInTheRange(color: differenceOfColorIndex(colorOne: doubleSurrondingPixel[i], ColorTwo: imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))), range: CGFloat(lowlimit)) && isInTheRange(color: differenceOfColorIndex(colorOne: doubleSurrondingPixel[i], ColorTwo: imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))), range: CGFloat(highlimit))){sum+=1}
                        else{wrongTarget = i}
                    }
                    
                    if(sum == 4){
                        red = (surrondingPixel[0].components.red+surrondingPixel[1].components.red+surrondingPixel[2].components.red+surrondingPixel[3].components.red)/4
                        blue = (surrondingPixel[0].components.blue+surrondingPixel[1].components.blue+surrondingPixel[2].components.blue+surrondingPixel[3].components.blue)/4
                        green = (surrondingPixel[0].components.green+surrondingPixel[1].components.green+surrondingPixel[2].components.green+surrondingPixel[3].components.green)/4
                    }
                    else if(sum == 3){
                        red = (surrondingPixel[0].components.red+surrondingPixel[1].components.red+surrondingPixel[2].components.red+surrondingPixel[3].components.red-surrondingPixel[wrongTarget].components.red)/3
                        blue = (surrondingPixel[0].components.blue+surrondingPixel[1].components.blue+surrondingPixel[2].components.blue+surrondingPixel[3].components.blue-surrondingPixel[wrongTarget].components.blue)/3
                        green = (surrondingPixel[0].components.green+surrondingPixel[1].components.green+surrondingPixel[2].components.green+surrondingPixel[3].components.green-surrondingPixel[wrongTarget].components.green)/3
                    }
                }
                context!.setFillColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
                
            }
            print(x)
        }
        context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    
    
    func depixelForAll(){
        
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        for x in 1...Int((image?.size.width)!-1) {
            for y in 1...Int((image?.size.height)!-1) {
                var red:CGFloat = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y)).components.red
                var green:CGFloat = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y)).components.green
                var blue:CGFloat = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y)).components.blue
                
                let surrondingPixel = [imageView.layer.colorOfPoint(point: CGPoint(x: x+1, y: y)),
                                       imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y-1)),
                                       imageView.layer.colorOfPoint(point: CGPoint(x: x-1, y: y)),
                                       imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y+1))]
                red = (surrondingPixel[0].components.red+surrondingPixel[1].components.red+surrondingPixel[2].components.red+surrondingPixel[3].components.red)/4
                blue = (surrondingPixel[0].components.blue+surrondingPixel[1].components.blue+surrondingPixel[2].components.blue+surrondingPixel[3].components.blue)/4
                green = (surrondingPixel[0].components.green+surrondingPixel[1].components.green+surrondingPixel[2].components.green+surrondingPixel[3].components.green)/4
                context!.setFillColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
        }
    }
    
    func action(){
        //we'll work on this image
        
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        
        UIGraphicsBeginImageContext((image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image?.cgImage)!, in: imageRect)
        
        for x in 0...Int((image?.size.width)!) {
            for y in 0...Int((image?.size.height)!) {
                pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
                
                var redIndex = pointColor.components.red-pointColor.components.red.truncatingRemainder(dividingBy: 30)
                var greenIndex = pointColor.components.green-pointColor.components.green.truncatingRemainder(dividingBy: 30)
                var blueIndex = pointColor.components.blue-pointColor.components.blue.truncatingRemainder(dividingBy: 30)
                var alphaIndex = pointColor.components.alpha
                

                alphaIndex = pointColor.components.alpha
                
                
                context!.setFillColor(red: redIndex/255, green: greenIndex/255, blue: blueIndex/255, alpha: 1)
                context!.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1))
            }
            print("\(x)haha")
        }
        context!.restoreGState()
        image = UIGraphicsGetImageFromCurrentImageContext()
    }
}

/********************************************************************
  COPIES DOWN TO THE BOTTOME
*********************************************************************/
/*
 let imageView = UIImageView(image: image)
 //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
 var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
 
 
 
 let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
 
 UIGraphicsBeginImageContext((image?.size)!)
 let context = UIGraphicsGetCurrentContext()
 
 context!.saveGState()
 context?.draw((image?.cgImage)!, in: imageRect)
 
 var imageInfoData = ImageInfoData()
 
 imageInfoData.largeLocalPieces[0][0].colorPoints[0][0].red = Float(pointColor.components.red)
 imageInfoData.largeLocalPieces[0][0].colorPoints[0][0].green = Float(pointColor.components.green)
 imageInfoData.largeLocalPieces[0][0].colorPoints[0][0].blue = Float(pointColor.components.blue)
 
 var redSum: Float = 0
 var blueSum: Float = 0
 var greenSum: Float = 0
 
 
 for _ in 1...15{
 imageInfoData.largeLocalPieces[0][0].pixelInRange[0][0].append(0)
 }
 for _ in 1...15{
 var arr = [0]
 for _ in 0...15{
 arr.append(0)
 }
 imageInfoData.largeLocalPieces[0][0].pixelInRange[0].append(arr)
 }
 for _ in 1...15{
 var darr = [[0]]
 for _ in 0...15{
 var arr = [0]
 for _ in 0...15{
 arr.append(0)
 }
 darr.append(arr)
 }
 imageInfoData.largeLocalPieces[0][0].pixelInRange.append(darr)
 }
 
 var firstTimeDontAppend = true
 
 for x in 0...31{
 for y in 0...31{
 pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
 let color = DataOfColor(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue))
 print(color.red)
 if(firstTimeDontAppend){
 firstTimeDontAppend = false
 imageInfoData.largeLocalPieces[0][0].colorPoints[x][y] = color
 }
 else{
 imageInfoData.largeLocalPieces[0][0].colorPoints[x].append(color)
 }
 
 if(imageInfoData.largeLocalPieces[0][0].colorRange.redRange.high < color.red){
 imageInfoData.largeLocalPieces[0][0].colorRange.redRange.high = color.red
 }
 
 if(imageInfoData.largeLocalPieces[0][0].colorRange.redRange.low > color.red){
 imageInfoData.largeLocalPieces[0][0].colorRange.redRange.low = color.red
 }
 
 if(imageInfoData.largeLocalPieces[0][0].colorRange.blueRange.high < color.blue){
 imageInfoData.largeLocalPieces[0][0].colorRange.blueRange.high = color.blue
 }
 
 if(imageInfoData.largeLocalPieces[0][0].colorRange.blueRange.low > color.blue){
 imageInfoData.largeLocalPieces[0][0].colorRange.blueRange.low = color.blue
 }
 
 if(imageInfoData.largeLocalPieces[0][0].colorRange.greenRange.high < color.green){
 imageInfoData.largeLocalPieces[0][0].colorRange.greenRange.high = color.green
 }
 
 if(imageInfoData.largeLocalPieces[0][0].colorRange.greenRange.low > color.green){
 imageInfoData.largeLocalPieces[0][0].colorRange.greenRange.low = color.green
 }
 
 redSum = redSum+color.red
 blueSum = blueSum+color.blue
 greenSum = greenSum+color.green
 
 var redRangeIndex = Int(color.red/5)
 var greenRangeIndex = Int(color.green/5)
 var blueRangeIndex = Int(color.blue/5)
 
 if(Float(redRangeIndex) > color.red/5){redRangeIndex-=1}
 if(Float(greenRangeIndex) > color.green/5){greenRangeIndex-=1}
 if(Float(blueRangeIndex) > color.blue/5){blueRangeIndex-=1}
 
 imageInfoData.largeLocalPieces[0][0].pixelInRange[redRangeIndex][greenRangeIndex][blueRangeIndex] += 1
 }
 }
 imageInfoData.largeLocalPieces[0][0].mean = UIColor(colorLiteralRed: redSum/256/255, green: greenSum/256/255, blue: blueSum/256/255, alpha: 1)
 */

/*
 func initializeASmallPiece(coordinate: Point)->SmallPiece{
 let imageView = UIImageView(image: image)
 //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
 
 
 
 
 let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
 
 UIGraphicsBeginImageContext((image?.size)!)
 let context = UIGraphicsGetCurrentContext()
 
 context!.saveGState()
 context?.draw((image?.cgImage)!, in: imageRect)
 
 var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
 var largeLocalPieces = SmallPiece()
 largeLocalPieces.colorPoints[0][0].rgb.red = Float(pointColor.components.red)
 largeLocalPieces.colorPoints[0][0].rgb.green = Float(pointColor.components.green)
 largeLocalPieces.colorPoints[0][0].rgb.blue = Float(pointColor.components.blue)
 
 var redSum: Float = 0
 var blueSum: Float = 0
 var greenSum: Float = 0
 
 
 for _ in 1...32{
 largeLocalPieces.pixelInRange[0][0].append(0)
 }
 for _ in 1...32{
 var arr = [0]
 for _ in 1...32{
 arr.append(0)
 }
 largeLocalPieces.pixelInRange[0].append(arr)
 }
 for _ in 1...32{
 var darr = [[0]]
 for _ in 1...32{
 var arr = [0]
 for _ in 1...32{
 arr.append(0)
 }
 darr.append(arr)
 }
 largeLocalPieces.pixelInRange.append(darr)
 }
 var firstTimeDontAppend = true
 
 for y in 0...7{
 let x = 0
 pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: coordinate.y))
 
 
 if(largeLocalPieces.colorRange.redRange.high < Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.high = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.redRange.low > Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.low = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.blueRange.high < Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.high = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.blueRange.low > Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.low = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.greenRange.high < Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.high = Float(pointColor.components.green)
 }
 
 if(largeLocalPieces.colorRange.greenRange.low > Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.low = Float(pointColor.components.green)
 }
 
 redSum = redSum+Float(pointColor.components.red)
 blueSum = blueSum+Float(pointColor.components.blue)
 greenSum = greenSum+Float(pointColor.components.green)
 
 var redRangeIndex = Int(pointColor.components.red/8)
 var greenRangeIndex = Int(pointColor.components.green/8)
 var blueRangeIndex = Int(pointColor.components.blue/8)
 
 if(Float(redRangeIndex) > Float(pointColor.components.red/8)){redRangeIndex-=1}
 if(Float(greenRangeIndex) > Float(pointColor.components.green/8)){greenRangeIndex-=1}
 if(Float(blueRangeIndex) > Float(pointColor.components.blue/8)){blueRangeIndex-=1}
 
 largeLocalPieces.pixelInRange[redRangeIndex][greenRangeIndex][blueRangeIndex] += 1
 let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
 if(firstTimeDontAppend){
 firstTimeDontAppend = false
 largeLocalPieces.colorPoints[x][y] = color
 }
 else{
 largeLocalPieces.colorPoints[x].append(color)
 }
 }
 
 
 for x in (1)...(7){
 var pointOfPointInLine = [DataOfColor()]
 firstTimeDontAppend = true
 for y in (0)...(7){
 pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x+coordinate.x, y: y+coordinate.y))
 if(largeLocalPieces.colorRange.redRange.high < Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.high = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.redRange.low > Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.low = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.blueRange.high < Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.high = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.blueRange.low > Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.low = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.greenRange.high < Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.high = Float(pointColor.components.green)
 }
 
 if(largeLocalPieces.colorRange.greenRange.low > Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.low = Float(pointColor.components.green)
 }
 
 redSum = redSum+Float(pointColor.components.red)
 blueSum = blueSum+Float(pointColor.components.blue)
 greenSum = greenSum+Float(pointColor.components.green)
 
 var redRangeIndex = Int(pointColor.components.red/8)
 var greenRangeIndex = Int(pointColor.components.green/8)
 var blueRangeIndex = Int(pointColor.components.blue/8)
 
 if(Float(redRangeIndex) > Float(pointColor.components.red/8)){redRangeIndex-=1}
 if(Float(greenRangeIndex) > Float(pointColor.components.green/8)){greenRangeIndex-=1}
 if(Float(blueRangeIndex) > Float(pointColor.components.blue/8)){blueRangeIndex-=1}
 
 largeLocalPieces.pixelInRange[redRangeIndex+1][greenRangeIndex+1][blueRangeIndex+1] += 1
 let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
 
 if(firstTimeDontAppend){
 firstTimeDontAppend = false
 pointOfPointInLine[y] = color
 }
 else{
 pointOfPointInLine.append(color)
 }
 }
 largeLocalPieces.colorPoints.append(pointOfPointInLine)
 }
 largeLocalPieces.mean = UIColor(colorLiteralRed: redSum/256/255, green: greenSum/256/255, blue: blueSum/256/255, alpha: 1)
 for x in 0...3{
 for y in 0...3{
 largeLocalPieces.hugePixel[x][y] = mergePixel(coordinate: Point(x: coordinate.x+x*2, y: coordinate.y+y*2), size: Size(width: 2, height: 2))
 }
 }
 for i in 0...1{
 for k in 0...3{
 var redSum:Float = 0
 var blueSum:Float = 0
 var greemSum:Float = 0
 for numOfLine in 0...3{
 if(i==0){
 redSum += Float(largeLocalPieces.hugePixel[k][numOfLine].red)
 greemSum += Float(largeLocalPieces.hugePixel[k][numOfLine].green)
 blueSum += Float(largeLocalPieces.hugePixel[k][numOfLine].blue)
 }
 else{
 redSum += Float(largeLocalPieces.hugePixel[numOfLine][k].red)
 greemSum += Float(largeLocalPieces.hugePixel[numOfLine][k].green)
 blueSum += Float(largeLocalPieces.hugePixel[numOfLine][k].blue)
 }
 }
 largeLocalPieces.rangeColor[i][k].rgb.red = redSum/4
 largeLocalPieces.rangeColor[i][k].rgb.green = greenSum/4
 largeLocalPieces.rangeColor[i][k].rgb.blue = blueSum/4
 }
 }
 var firstTimeAddArea = true
 var lastColorRange = DataOfColor()
 var areaIDForTheRange = [[[Int]]]()
 for r in 0...31{
 var gbAreaID = [[Int]]()
 for g in 0...31{
 var bAreaID = [Int]()
 for b in 0...31{
 bAreaID.append(-1)
 }
 gbAreaID.append(bAreaID)
 }
 areaIDForTheRange.append(gbAreaID)
 }
 for r in 1...31{
 for g in 1...31{
 for b in 1...31{
 if(largeLocalPieces.pixelInRange[r][g][b] >= 1){
 /*problem!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !!!!!!!!!!!!!!!!!!!!
 */
 var rangeToNext = false
 if(areaIDForTheRange[r-1][g][b] >= 0){
 lastColorRange.redRange = r-1
 lastColorRange.greenRange = g
 lastColorRange.blueRange = b
 rangeToNext = true
 }
 if(areaIDForTheRange[r][g-1][b] >= 0){
 lastColorRange.redRange = r
 lastColorRange.greenRange = g-1
 lastColorRange.blueRange = b
 rangeToNext = true
 }
 if(areaIDForTheRange[r][g][b-1] >= 0){
 lastColorRange.redRange = r
 lastColorRange.greenRange = g
 lastColorRange.blueRange = b-1
 rangeToNext = true
 }
 if(areaIDForTheRange[r-1][g-1][b] >= 0){
 lastColorRange.redRange = r-1
 lastColorRange.greenRange = g-1
 lastColorRange.blueRange = b
 rangeToNext = true
 }
 if(areaIDForTheRange[r-1][g][b-1] >= 0){
 lastColorRange.redRange = r-1
 lastColorRange.greenRange = g
 lastColorRange.blueRange = b-1
 rangeToNext = true
 }
 if(areaIDForTheRange[r][g-1][b-1] >= 0){
 lastColorRange.redRange = r
 lastColorRange.greenRange = g-1
 lastColorRange.blueRange = b-1
 rangeToNext = true
 }
 if(areaIDForTheRange[r-1][g-1][b-1] >= 0){
 lastColorRange.redRange = r-1
 lastColorRange.greenRange = g-1
 lastColorRange.blueRange = b-1
 rangeToNext = true
 }
 if(firstTimeAddArea || rangeToNext){
 if(firstTimeAddArea){
 firstTimeAddArea = false
 areaIDForTheRange[lastColorRange.redRange][lastColorRange.greenRange][lastColorRange.blueRange] = 0
 }
 var area = UnitArea()
 var firstTimeAddPoint = true
 for x in 0...7{
 for y in 0...7{
 var isInTheRange = true
 isInTheRange = isInTheRange && (largeLocalPieces.colorPoints[x][y].redRange == r)
 isInTheRange = isInTheRange && (largeLocalPieces.colorPoints[x][y].greenRange == g)
 isInTheRange = isInTheRange && (largeLocalPieces.colorPoints[x][y].blueRange == b)
 if(isInTheRange){
 if(firstTimeAddPoint){
 largeLocalPieces.areaMap.areas[areaIDForTheRange[lastColorRange.redRange][lastColorRange.greenRange][lastColorRange.blueRange]].pointsInArea[0] = Point(x: x, y: y)
 }
 else{
 largeLocalPieces.areaMap.areas[0].pointsInArea.append(Point(x: x, y: y))
 }
 if(x == 0){
 largeLocalPieces.inputPixelsAreaID[0][y] = largeLocalPieces.areaNumber
 }
 if(y == 0){
 largeLocalPieces.inputPixelsAreaID[1][x] = largeLocalPieces.areaNumber
 }
 if(x == 7){
 largeLocalPieces.outputPixelsAreaID[0][y] = largeLocalPieces.areaNumber
 }
 if(y == 7){
 largeLocalPieces.outputPixelsAreaID[1][x] = largeLocalPieces.areaNumber
 }
 }
 }
 }
 }
 else{
 largeLocalPieces.areaNumber += 1
 areaIDForTheRange[r][g][b] = largeLocalPieces.areaNumber
 var area = UnitArea()
 var firstTimeAddPoint = true
 for x in 0...7{
 for y in 0...7{
 var isInTheRange = true
 isInTheRange = isInTheRange && (largeLocalPieces.colorPoints[x][y].redRange == r)
 isInTheRange = isInTheRange && (largeLocalPieces.colorPoints[x][y].greenRange == g)
 isInTheRange = isInTheRange && (largeLocalPieces.colorPoints[x][y].blueRange == b)
 if(isInTheRange){
 if(firstTimeAddPoint){
 area.pointsInArea[0] = Point(x: x, y: y)
 }
 else{
 area.pointsInArea.append(Point(x: x, y: y))
 }
 if(x == 0){
 largeLocalPieces.inputPixelsAreaID[0][y] = largeLocalPieces.areaNumber
 }
 if(y == 0){
 largeLocalPieces.inputPixelsAreaID[1][x] = largeLocalPieces.areaNumber
 }
 if(x == 7){
 largeLocalPieces.outputPixelsAreaID[0][y] = largeLocalPieces.areaNumber
 }
 if(y == 7){
 largeLocalPieces.outputPixelsAreaID[1][x] = largeLocalPieces.areaNumber
 }
 }
 }
 }
 largeLocalPieces.areaMap.areas.append(area)
 }
 }
 }
 }
 }
 return largeLocalPieces
 }
 
 func mergePixel(coordinate: Point, size: Size)->DataRGB{
 let imageView = UIImageView(image: image)
 //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
 var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
 
 
 
 let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
 
 UIGraphicsBeginImageContext((image?.size)!)
 let context = UIGraphicsGetCurrentContext()
 
 context!.saveGState()
 context?.draw((image?.cgImage)!, in: imageRect)
 
 var redSum: Float = 0
 var greenSum: Float = 0
 var blueSum: Float = 0
 for x in coordinate.x...coordinate.x+size.width{
 for y in coordinate.y...coordinate.y+size.height{
 pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y))
 redSum += Float(pointColor.components.red)
 greenSum += Float(pointColor.components.green)
 blueSum += Float(pointColor.components.blue)
 }
 }
 return DataRGB(red: redSum/Float(size.width*size.height),
 green: greenSum/Float(size.width*size.height),
 blue: blueSum/Float(size.width*size.height))
 }
 
 func initializeAPiece(coordinate: Point)->LargePiece{
 let imageView = UIImageView(image: image)
 //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
 
 
 let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
 
 UIGraphicsBeginImageContext((image?.size)!)
 let context = UIGraphicsGetCurrentContext()
 
 context!.saveGState()
 context?.draw((image?.cgImage)!, in: imageRect)
 
 var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
 var largeLocalPieces = LargePiece()
 largeLocalPieces.colorPoints[0][0].rgb.red = Float(pointColor.components.red)
 largeLocalPieces.colorPoints[0][0].rgb.green = Float(pointColor.components.green)
 largeLocalPieces.colorPoints[0][0].rgb.blue = Float(pointColor.components.blue)
 
 var redSum: Float = 0
 var blueSum: Float = 0
 var greenSum: Float = 0
 
 //initialize the huge range of color, which 8/256 is one unit, thus it is a 32*32*32 three demensional initializer
 for _ in 1...32{
 largeLocalPieces.pixelInRange[0][0].append(0)
 }
 for _ in 1...32{
 var arr = [0]
 for _ in 1...32{
 arr.append(0)
 }
 largeLocalPieces.pixelInRange[0].append(arr)
 }
 for _ in 1...32{
 var darr = [[0]]
 for _ in 1...32{
 var arr = [0]
 for _ in 1...32{
 arr.append(0)
 }
 darr.append(arr)
 }
 largeLocalPieces.pixelInRange.append(darr)
 }
 
 var firstTimeDontAppend = true
 
 //initialize the pixels in the piece, including range, mean and color of pixel.
 for y in (0)...(31){
 let x = 0
 pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y+coordinate.y))
 
 
 if(largeLocalPieces.colorRange.redRange.high < Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.high = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.redRange.low > Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.low = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.blueRange.high < Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.high = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.blueRange.low > Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.low = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.greenRange.high < Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.high = Float(pointColor.components.green)
 }
 
 if(largeLocalPieces.colorRange.greenRange.low > Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.low = Float(pointColor.components.green)
 }
 
 redSum = redSum+Float(pointColor.components.red)
 blueSum = blueSum+Float(pointColor.components.blue)
 greenSum = greenSum+Float(pointColor.components.green)
 
 var redRangeIndex = Int(pointColor.components.red/8)
 var greenRangeIndex = Int(pointColor.components.green/8)
 var blueRangeIndex = Int(pointColor.components.blue/8)
 
 if(Float(redRangeIndex) > Float(pointColor.components.red/8)){redRangeIndex-=1}
 if(Float(greenRangeIndex) > Float(pointColor.components.green/8)){greenRangeIndex-=1}
 if(Float(blueRangeIndex) > Float(pointColor.components.blue/8)){blueRangeIndex-=1}
 
 largeLocalPieces.pixelInRange[redRangeIndex][greenRangeIndex][blueRangeIndex] += 1
 
 let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
 if(firstTimeDontAppend){
 firstTimeDontAppend = false
 largeLocalPieces.colorPoints[x][y] = color
 }
 else{
 largeLocalPieces.colorPoints[x].append(color)
 }
 }
 
 
 for x in (1)...(31){
 var pointOfPointInLine = [DataOfColor()]
 firstTimeDontAppend = true
 for y in (0)...(31){
 pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x+coordinate.x, y: y+coordinate.y))
 if(largeLocalPieces.colorRange.redRange.high < Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.high = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.redRange.low > Float(pointColor.components.red)){
 largeLocalPieces.colorRange.redRange.low = Float(pointColor.components.red)
 }
 
 if(largeLocalPieces.colorRange.blueRange.high < Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.high = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.blueRange.low > Float(pointColor.components.blue)){
 largeLocalPieces.colorRange.blueRange.low = Float(pointColor.components.blue)
 }
 
 if(largeLocalPieces.colorRange.greenRange.high < Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.high = Float(pointColor.components.green)
 }
 
 if(largeLocalPieces.colorRange.greenRange.low > Float(pointColor.components.green)){
 largeLocalPieces.colorRange.greenRange.low = Float(pointColor.components.green)
 }
 
 redSum = redSum+Float(pointColor.components.red)
 blueSum = blueSum+Float(pointColor.components.blue)
 greenSum = greenSum+Float(pointColor.components.green)
 
 var redRangeIndex = Int(pointColor.components.red/8)
 var greenRangeIndex = Int(pointColor.components.green/8)
 var blueRangeIndex = Int(pointColor.components.blue/8)
 
 if(Float(redRangeIndex) > Float(pointColor.components.red/8)){redRangeIndex-=1}
 if(Float(greenRangeIndex) > Float(pointColor.components.green/8)){greenRangeIndex-=1}
 if(Float(blueRangeIndex) > Float(pointColor.components.blue/8)){blueRangeIndex-=1}
 
 largeLocalPieces.pixelInRange[redRangeIndex+1][greenRangeIndex+1][blueRangeIndex+1] += 1
 let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
 
 if(firstTimeDontAppend){
 firstTimeDontAppend = false
 pointOfPointInLine[y] = color
 }
 else{
 pointOfPointInLine.append(color)
 }
 }
 largeLocalPieces.colorPoints.append(pointOfPointInLine)
 }
 largeLocalPieces.mean = UIColor(colorLiteralRed: redSum/256/255, green: greenSum/256/255, blue: blueSum/256/255, alpha: 1)
 
 //pooling...initialize small pieces,
 for x in 0...3{
 for y in 0...3{
 largeLocalPieces.smallPiece[x][y] = initializeASmallPiece(coordinate: Point(x: coordinate.x+x*8, y: coordinate.y+y*8))
 }
 }
 
 //Regionalization, devide in to unit of area
 var isFirstTimeAddArea = true
 var isNotGoToLinkYet = true
 var currentArea = 0
 for x in 0...3{
 for y in 0...3{
 if(isNotGoToLinkYet){
 
 isNotGoToLinkYet = false
 for i in 0...largeLocalPieces.smallPiece[x][y].areaMap.areas.count-1{
 if(isFirstTimeAddArea){
 largeLocalPieces.areaMap.areas[currentArea] = largeLocalPieces.smallPiece[x][y].areaMap.areas[i]
 isFirstTimeAddArea = false
 }
 else{
 currentArea += 1
 largeLocalPieces.areaMap.areas.append(largeLocalPieces.smallPiece[x][y].areaMap.areas[i])
 
 for arrIndex in 0...largeLocalPieces.areaMap.areas[currentArea].pointsInArea.count-1{
 largeLocalPieces.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
 largeLocalPieces.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
 }
 
 for k in 0...7{
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
 largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] = currentArea
 }
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
 largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] = currentArea
 }
 if(largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[0][k] == i){
 largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[0][k] = currentArea
 }
 if(largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[1][k] == i){
 largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[1][k] = currentArea
 }
 }
 }
 
 }
 }
 else{
 for i in 0...largeLocalPieces.smallPiece[x][y].areaMap.areas.count-1{
 var isLinked = true
 var linkedTimes = 0
 var linkedAreaID = 0
 
 if(y == 0){
 for k in 0...7{
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.red-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.red <= 8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.red-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.red >= -8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.green-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.green <= 8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.green-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.green >= -8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.blue-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.blue <= 8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.blue-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.blue >= -8
 if(isLinked){
 linkedTimes += 1
 linkedAreaID = largeLocalPieces.smallPiece[x-1][y].outputPixelsAreaID[0][k]
 }
 }
 }
 }
 else if(x == 0){
 for k in 0...7{
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.red-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.red <= 8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.red-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.red >= -8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.green-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.green <= 8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.green-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.green >= -8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.blue-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.blue <= 8
 
 isLinked = isLinked && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.blue-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.blue >= -8
 if(isLinked){
 linkedTimes += 1
 linkedAreaID = largeLocalPieces.smallPiece[x][y-1].outputPixelsAreaID[1][k]
 }
 }
 }
 }
 else{
 for k in 0...7{
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
 var isLinkedY = true
 var isLinkedX = true
 isLinkedY = isLinkedY && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.red-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.red <= 8
 
 isLinkedY = isLinkedY && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.red-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.red >= -8
 
 isLinkedY = isLinkedY && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.green-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.green <= 8
 
 isLinkedY = isLinkedY && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.green-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.green >= -8
 
 isLinkedY = isLinkedY && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.blue-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.blue <= 8
 
 isLinkedY = isLinkedY && largeLocalPieces.smallPiece[x][y].colorPoints[1][k].rgb.blue-largeLocalPieces.smallPiece[x][y-1].colorPoints[7][k].rgb.blue >= -8
 
 isLinkedX = isLinkedX && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.red-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.red <= 8
 
 isLinkedX = isLinkedX && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.red-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.red >= -8
 
 isLinkedX = isLinkedX && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.green-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.green <= 8
 
 isLinkedX = isLinkedX && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.green-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.green >= -8
 
 isLinkedX = isLinkedX && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.blue-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.blue <= 8
 
 isLinkedX = isLinkedX && largeLocalPieces.smallPiece[x][y].colorPoints[0][k].rgb.blue-largeLocalPieces.smallPiece[x-1][y].colorPoints[7][k].rgb.blue >= -8
 
 if(isLinkedX){
 linkedTimes += 1
 linkedAreaID = largeLocalPieces.smallPiece[x-1][y].outputPixelsAreaID[0][k]
 }
 if(isLinkedY){
 
 linkedTimes += 1
 linkedAreaID = largeLocalPieces.smallPiece[x][y-1].outputPixelsAreaID[1][k]
 }
 
 }
 }
 }
 if(linkedTimes >= 1){
 for k in 0...largeLocalPieces.smallPiece[x][y].areaMap.areas[i].pointsInArea.count-1{
 largeLocalPieces.areaMap.areas[linkedAreaID].pointsInArea.append(Point(x: largeLocalPieces.smallPiece[x][y].areaMap.areas[i].pointsInArea[k].x+x*8, y: largeLocalPieces.smallPiece[x][y].areaMap.areas[i].pointsInArea[k].y+y*8))
 }
 //update the inputs and outputs
 for k in 0...7{
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
 largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] = linkedAreaID
 }
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
 largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] = linkedAreaID
 }
 if(largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[0][k] == i){
 largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[0][k] = linkedAreaID
 }
 if(largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[1][k] == i){
 largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[1][k] = linkedAreaID
 }
 }
 }
 else{
 currentArea += 1
 largeLocalPieces.areaMap.areas.append(largeLocalPieces.smallPiece[x][y].areaMap.areas[i])
 for arrIndex in 0...largeLocalPieces.areaMap.areas[currentArea].pointsInArea.count-1{
 largeLocalPieces.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
 largeLocalPieces.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
 }
 //update the inputs and outputs
 for k in 0...7{
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
 largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[0][k] = currentArea
 }
 if(largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
 largeLocalPieces.smallPiece[x][y].inputPixelsAreaID[1][k] = currentArea
 }
 if(largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[0][k] == i){
 largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[0][k] = currentArea
 }
 if(largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[1][k] == i){
 largeLocalPieces.smallPiece[x][y].outputPixelsAreaID[1][k] = currentArea
 }
 }
 }
 }
 }
 }
 }
 //in this case input and output need to be reverse, because they are adjacent to each.
 for x in 0...3{
 for i in 0...7{
 largeLocalPieces.midInputPixelsAreaID[1].append(largeLocalPieces.smallPiece[x][1].outputPixelsAreaID[1][i])
 largeLocalPieces.midOutputPixelsAreaID[1].append(largeLocalPieces.smallPiece[x][2].inputPixelsAreaID[1][i])
 }
 }
 for y in 0...3{
 for i in 0...7{
 largeLocalPieces.midInputPixelsAreaID[0].append(largeLocalPieces.smallPiece[1][y].outputPixelsAreaID[0][i])
 largeLocalPieces.midOutputPixelsAreaID[0].append(largeLocalPieces.smallPiece[2][y].inputPixelsAreaID[0][i])
 
 }
 }
 //back to the normal again
 for x in 0...3{
 for i in 0...7{
 largeLocalPieces.inputPixelsAreaID[1].append(largeLocalPieces.smallPiece[x][0].inputPixelsAreaID[1][i])
 largeLocalPieces.outputPixelsAreaID[1].append(largeLocalPieces.smallPiece[x][3].outputPixelsAreaID[1][i])
 }
 }
 for y in 0...3{
 for i in 0...7{
 largeLocalPieces.inputPixelsAreaID[0].append(largeLocalPieces.smallPiece[0][y].inputPixelsAreaID[0][i])
 largeLocalPieces.outputPixelsAreaID[0].append(largeLocalPieces.smallPiece[3][y].outputPixelsAreaID[0][i])
 
 }
 }
 //***************************************************//
 for i in 0...1{
 for k in 0...3{
 var redSum:Float = 0
 var blueSum:Float = 0
 var greemSum:Float = 0
 for numOfLine in 0...3{
 if(i==0){
 redSum += Float(largeLocalPieces.smallPiece[k][numOfLine].mean.components.red)
 greemSum += Float(largeLocalPieces.smallPiece[k][numOfLine].mean.components.green)
 blueSum += Float(largeLocalPieces.smallPiece[k][numOfLine].mean.components.blue)
 }
 else{
 redSum += Float(largeLocalPieces.smallPiece[numOfLine][k].mean.components.red)
 greemSum += Float(largeLocalPieces.smallPiece[numOfLine][k].mean.components.green)
 blueSum += Float(largeLocalPieces.smallPiece[numOfLine][k].mean.components.blue)
 }
 }
 largeLocalPieces.rangeColor[i][k].rgb.red = redSum/4
 largeLocalPieces.rangeColor[i][k].rgb.green = greenSum/4
 largeLocalPieces.rangeColor[i][k].rgb.blue = blueSum/4
 }
 }
 return largeLocalPieces
 }
 
 func initializeImageInfoData()->ImageInfoData{
 let imageView = UIImageView(image: image)
 //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
 var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
 
 
 
 let imageRect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
 
 UIGraphicsBeginImageContext((image?.size)!)
 let context = UIGraphicsGetCurrentContext()
 
 context!.saveGState()
 context?.draw((image?.cgImage)!, in: imageRect)
 
 var imageInfoData = ImageInfoData()
 for x in 0...Int((image?.size.width)!/16)-1{
 
 var largePiecesInLine = [LargePiece]()
 for y in 0...Int((self.image?.size.height)!/16)-1{
 largePiecesInLine.append(self.initializeAPiece(coordinate: Point(x: x*16, y: y*16)))
 print(x, y)
 }
 imageInfoData.largeLocalPieces.append(largePiecesInLine)
 }
 
 print("initialized")
 var isFirstTimeAddArea = true
 var isNotGoToLinkYet = true
 
 var finishLinked = false
 var currentArea = 0
 for x in 0...Int((image?.size.width)!/16)-1{
 for y in 0...Int((image?.size.height)!/16-1){
 for i in 0...imageInfoData.largeLocalPieces[0][0].areaMap.areas.count-1{
 var linkedAreasID = [Int]()
 var newLinkedAreasID = [Int]()
 if(isNotGoToLinkYet){
 if(isFirstTimeAddArea){
 imageInfoData.areaMap.areas[currentArea] = imageInfoData.largeLocalPieces[x][y].areaMap.areas[i]
 isFirstTimeAddArea = false
 }
 else{
 imageInfoData.areaMap.areas.append(imageInfoData.largeLocalPieces[x][y].areaMap.areas[i])
 currentArea += 1
 
 for arrIndex in 0...imageInfoData.areaMap.areas[currentArea].pointsInArea.count-1{
 imageInfoData.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
 imageInfoData.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
 }
 
 for k in 0...31{
 if(imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[0][k] == i){
 imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[0][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[1][k] == i){
 imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[1][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[0][k] == i){
 imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[0][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[1][k] == i){
 imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[1][k] = currentArea
 }
 }
 
 for k in 0...31{
 if(imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0][k] == i){
 imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1][k] == i){
 imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] == i){
 imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] == i){
 imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] = currentArea
 }
 }
 }
 }
 else if(!finishLinked){
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
 newAreaIDX.append(imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0][index])
 }
 else{
 var isSame = false
 for k in 0...newAreaIDX.count-1{
 isSame = isSame || newAreaIDX[k] == imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0][index]
 }
 if(!isSame){
 newAreaIDX.append(imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0][index])
 }
 }
 }
 
 fistTimeAddElementID = true
 
 for index in 0...31{
 if(fistTimeAddElementID){
 newAreaIDY.append(imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1][index])
 }
 else{
 var isSame = false
 for k in 0...newAreaIDY.count-1{
 isSame = isSame || newAreaIDY[k] == imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1][index]
 }
 if(!isSame){
 newAreaIDY.append(imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1][index])
 }
 }
 }
 
 //initialize areasID,
 if(x != 0){
 isFirstTimeAddArea = true
 for index in 0...31{
 if(fistTimeAddElementID){
 areaIDX.append(imageInfoData.largeLocalPieces[x-1][y].outputPixelsAreaID[0][index])
 }
 else{
 var isSame = false
 for k in 0...areaIDX.count-1{
 isSame = isSame || areaIDX[k] == imageInfoData.largeLocalPieces[x-1][y].outputPixelsAreaID[0][index]
 }
 if(!isSame){
 areaIDX.append(imageInfoData.largeLocalPieces[x-1][y].outputPixelsAreaID[0][index])
 }
 }
 }
 }
 
 if(y != 0){
 fistTimeAddElementID = true
 for index in 0...31{
 if(fistTimeAddElementID){
 areaIDY.append(imageInfoData.largeLocalPieces[x][y-1].outputPixelsAreaID[1][index])
 }
 else{
 var isSame = false
 for k in 0...areaIDY.count-1{
 isSame = isSame || areaIDY[k] == imageInfoData.largeLocalPieces[x][y-1].outputPixelsAreaID[1][index]
 }
 if(!isSame){
 areaIDY.append(imageInfoData.largeLocalPieces[x][y-1].outputPixelsAreaID[1][index])
 }
 }
 }
 }
 
 var newAreaID = [Int]()
 var areaID = [Int]()
 if(y != 0 && x != 0){
 newAreaID = newAreaIDX
 areaID = areaIDX
 for m in 0...areaIDY.count-1{
 var isSame = false
 for n in 0...areaID.count{
 isSame = isSame || areaID[n] == areaIDY[m]
 }
 if(!isSame){
 areaID.append(areaIDY[m])
 }
 }
 for m in 0...newAreaIDY.count-1{
 var isSame = false
 for n in 0...newAreaID.count{
 isSame = isSame || newAreaID[n] == newAreaIDY[m]
 }
 if(!isSame){
 areaID.append(newAreaIDY[m])
 }
 }
 }
 
 //forming Areas
 if(!(y==0 || x==0)){
 
 for index in 0...areaID.count-1{
 for k in 0...imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea.count-1{
 // "<=" need to be checked, because the direction are not sure
 if(imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].x >= 16 && imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].y >= 16){
 imageInfoData.areaMap.areas[areaID[index]].pointsInArea.append(Point(
 x: imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].x+x*16,
 y: imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].y+y*16))
 }
 }
 }
 
 newLinkedAreasID = newAreaID
 linkedAreasID = areaID
 
 imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0] = imageInfoData.largeLocalPieces[x-1][y].midOutputPixelsAreaID[0]
 imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1] = imageInfoData.largeLocalPieces[x][y-1].midOutputPixelsAreaID[1]
 }
 else if(y == 0){
 for index in 0...areaIDX.count-1{
 for k in 0...imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea.count-1{
 if(imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea[k].x >= 16){
 imageInfoData.areaMap.areas[areaIDX[index]].pointsInArea.append(Point(
 x: imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea[k].x+x*16,
 y: imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea[k].y))
 }
 }
 }
 newLinkedAreasID = newAreaIDX
 linkedAreasID = areaIDX
 imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[0] = imageInfoData.largeLocalPieces[x-1][y].midOutputPixelsAreaID[0]
 }
 else if(x == 0){
 for index in 0...areaIDY.count-1{
 for k in 0...imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea.count-1{
 if(imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea[k].y >= 16){
 imageInfoData.areaMap.areas[areaIDY[index]].pointsInArea.append(Point(
 x: imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea[k].x,
 y: imageInfoData.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea[k].y+y*16))
 }
 }
 }
 newLinkedAreasID = newAreaIDY
 linkedAreasID = areaIDY
 imageInfoData.largeLocalPieces[x][y].midInputPixelsAreaID[1] = imageInfoData.largeLocalPieces[x][y-1].midOutputPixelsAreaID[1]
 }
 
 //updating outPuts
 for index in 0...linkedAreasID.count-1{
 for k in 0...31{
 if(imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] == newLinkedAreasID[index]){
 imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] = linkedAreasID[index]
 }
 if(imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] == newLinkedAreasID[index]){
 imageInfoData.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] = linkedAreasID[index]
 }
 }
 }
 
 finishLinked = true
 }
 else{
 //error, need to be fixed, debug then delete this line
 var isSame = false
 
 for index in 0...linkedAreasID.count-1{
 isSame = isSame || linkedAreasID[index] == i
 }
 
 if(!isSame){
 imageInfoData.areaMap.areas.append(imageInfoData.largeLocalPieces[x][y].areaMap.areas[i])
 currentArea += 1
 
 for arrIndex in 0...imageInfoData.areaMap.areas[currentArea].pointsInArea.count{
 imageInfoData.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
 imageInfoData.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
 }
 
 for k in 0...31{
 if(imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[0][k] == i){
 imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[0][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[1][k] == i){
 imageInfoData.largeLocalPieces[x][y].inputPixelsAreaID[1][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[0][k] == i){
 imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[0][k] = currentArea
 }
 if(imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[1][k] == i){
 imageInfoData.largeLocalPieces[x][y].outputPixelsAreaID[1][k] = currentArea
 }
 }
 }
 }
 }
 
 isNotGoToLinkYet = false
 }
 }
 return imageInfoData
 }*/







