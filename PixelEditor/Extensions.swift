//
//  File.swift
//  PixelEditor
//
//  Created by Zihao Arthur Wang [STUDENT] on 2017/5/7.
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
