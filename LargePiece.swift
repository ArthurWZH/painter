//
//  LargePiece.swift
//  PixelEditor
//
//  Created by Zihao Arthur Wang [STUDENT] on 2017/5/17.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import Foundation

import UIKit

class LargePiece{
    var scale = 32
    var colorRange = ColorRange()
    var mean = UIColor.black
    
    var colorPoints = [[DataOfColor()]]
    
    var smallPiece = [[SmallPiece]]()
    
    var rangeColor = [[DataOfColor(),DataOfColor(),DataOfColor(),DataOfColor()],
                      [DataOfColor(),DataOfColor(),DataOfColor(),DataOfColor()]]
    
    var pixelInRange = [[[0]]]
    //range RGB, red greem blue, color range, e.g R: 16...31, G: 128...143, B: 64...79, therefore pixelInRange[2][9][5] += 1
    var areaIDMap = [[Int]]()
    var areas = [UnitArea]()
    
    var areaNumber = 0
    var areaMap = AreaMap()
    var midInputPixelsAreaID = [[Int](), [Int]()]
    var midOutputPixelsAreaID = [[Int](), [Int]()]
    var inputPixelsAreaID = [[Int](), [Int]()]
    var outputPixelsAreaID = [[Int](), [Int]()]
    
    init(image: UIImage, coordinate: Point){
        let imageView = UIImageView(image: image)
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        self.colorPoints[0][0].rgb.red = Float(pointColor.components.red)
        self.colorPoints[0][0].rgb.green = Float(pointColor.components.green)
        self.colorPoints[0][0].rgb.blue = Float(pointColor.components.blue)
        
        var redSum: Float = 0
        var blueSum: Float = 0
        var greenSum: Float = 0
        
        for _ in 0...31{
            var line = [Int]()
            for _ in 0...31{
                line.append(0)
            }
            self.areaIDMap.append(line)
            
        }
        
        //initialize the huge range of color, which 8/256 is one unit, thus it is a 32*32*32 three demensional initializer
        for _ in 1...32{
            self.pixelInRange[0][0].append(0)
        }
        for _ in 1...32{
            var arr = [0]
            for _ in 1...32{
                arr.append(0)
            }
            self.pixelInRange[0].append(arr)
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
            self.pixelInRange.append(darr)
        }
        
        var firstTimeDontAppend = true
        
        //initialize the pixels in the piece, including range, mean and color of pixel.
        for y in (0)...(31){
            let x = 0
            pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x, y: y+coordinate.y))
            
            
            if(self.colorRange.redRange.high < Float(pointColor.components.red)){
                self.colorRange.redRange.high = Float(pointColor.components.red)
            }
            
            if(self.colorRange.redRange.low > Float(pointColor.components.red)){
                self.colorRange.redRange.low = Float(pointColor.components.red)
            }
            
            if(self.colorRange.blueRange.high < Float(pointColor.components.blue)){
                self.colorRange.blueRange.high = Float(pointColor.components.blue)
            }
            
            if(self.colorRange.blueRange.low > Float(pointColor.components.blue)){
                self.colorRange.blueRange.low = Float(pointColor.components.blue)
            }
            
            if(self.colorRange.greenRange.high < Float(pointColor.components.green)){
                self.colorRange.greenRange.high = Float(pointColor.components.green)
            }
            
            if(self.colorRange.greenRange.low > Float(pointColor.components.green)){
                self.colorRange.greenRange.low = Float(pointColor.components.green)
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
            
            self.pixelInRange[redRangeIndex][greenRangeIndex][blueRangeIndex] += 1
            
            let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
            if(firstTimeDontAppend){
                firstTimeDontAppend = false
                self.colorPoints[x][y] = color
            }
            else{
                self.colorPoints[x].append(color)
            }
        }
        
        
        for x in (1)...(31){
            var pointOfPointInLine = [DataOfColor()]
            firstTimeDontAppend = true
            for y in (0)...(31){
                pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: x+coordinate.x, y: y+coordinate.y))
                if(self.colorRange.redRange.high < Float(pointColor.components.red)){
                    self.colorRange.redRange.high = Float(pointColor.components.red)
                }
                
                if(self.colorRange.redRange.low > Float(pointColor.components.red)){
                    self.colorRange.redRange.low = Float(pointColor.components.red)
                }
                
                if(self.colorRange.blueRange.high < Float(pointColor.components.blue)){
                    self.colorRange.blueRange.high = Float(pointColor.components.blue)
                }
                
                if(self.colorRange.blueRange.low > Float(pointColor.components.blue)){
                    self.colorRange.blueRange.low = Float(pointColor.components.blue)
                }
                
                if(self.colorRange.greenRange.high < Float(pointColor.components.green)){
                    self.colorRange.greenRange.high = Float(pointColor.components.green)
                }
                
                if(self.colorRange.greenRange.low > Float(pointColor.components.green)){
                    self.colorRange.greenRange.low = Float(pointColor.components.green)
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
                
                self.pixelInRange[redRangeIndex+1][greenRangeIndex+1][blueRangeIndex+1] += 1
                let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
                
                if(firstTimeDontAppend){
                    firstTimeDontAppend = false
                    pointOfPointInLine[y] = color
                }
                else{
                    pointOfPointInLine.append(color)
                }
            }
            self.colorPoints.append(pointOfPointInLine)
        }
        self.mean = UIColor(colorLiteralRed: redSum/256/255, green: greenSum/256/255, blue: blueSum/256/255, alpha: 1)
        
        //pooling...initialize small pieces,
        for x in 0...6{
            var piecesLine = [SmallPiece]()
            for y in 0...6{
                print(x, y)
                piecesLine.append(SmallPiece(image: image, coordinate: Point(x: coordinate.x+x*4, y: coordinate.y+y*4)))
            }
            self.smallPiece.append(piecesLine)
        }
        
        var areaInLine = [[UnitArea](), [UnitArea](), [UnitArea](), [UnitArea](), [UnitArea](), [UnitArea](), [UnitArea]()]
        var areaIDMapInLine = [[[Int]](), [[Int]](), [[Int]](), [[Int]](), [[Int]](), [[Int]](), [[Int]]()]
        for x in 0...6{
            for _ in 0...7{
                var line = [Int]()
                for _ in 0...31{
                    line.append(0)
                }
                areaIDMapInLine[x].append(line)
            }
            var notLinkYet = true
            for y in 0...6{
                
                if(notLinkYet){
//                    first initialize the area for the frist small piece in the line
                    notLinkYet = false
                    print("areaCounts: \(smallPiece[x][y].areas.count-1)")
                    for index in 0...smallPiece[x][y].areas.count-1{
                        
                        areaInLine[x].append(smallPiece[x][y].areas[index])
                        print(smallPiece[x][y].areas[index].pointsInArea.count-1)
                        for i in 0...smallPiece[x][y].areas[index].pointsInArea.count-1{
                            
                            areaIDMapInLine[x][areaInLine[x][index].pointsInArea[i].x][areaInLine[x][index].pointsInArea[i].y] = index
                        }
                    }
                    
                }
                else{
                    
//                    needed to be link with the last now
                    var linkedAreaID = [areaIDMapInLine[x][0][(y-1)*4+6]]
                    var linkedAreaCount = [[0]]
                    var addAreaID = [smallPiece[x][y].areaIDMap[0][2]]
                    var addAreaIDCount = [[0]]
                    
                    // initialize areaID in order to link areas
                    for i in 1...7{
                        var isSameLinkedArea = false
                        var isSameAddArea = false
                        var addAreaIndex = 0
                        var linkedAreaIndex = 0
                        for k in 0...linkedAreaID.count-1{
                            if(linkedAreaID[k] == areaIDMapInLine[x][i][(y-1)*4+6]){
                                isSameLinkedArea = true
                                linkedAreaIndex = k
                            }
                        }
                        for k in 0...addAreaID.count-1{
                            
                            if(addAreaID[k] == smallPiece[x][y].areaIDMap[i][2]){
                                isSameAddArea = true
                                addAreaIndex = k
                            }
                        }
                        if(isSameLinkedArea){
                            linkedAreaCount[linkedAreaIndex].append(i)
                        }
                        else{
                            linkedAreaCount.append([i])
                            linkedAreaID.append(areaIDMapInLine[x][i][(y-1)*4+6])
                        }
                        if(isSameAddArea){
                            addAreaIDCount[addAreaIndex].append(i)
                        }
                        else{
                            addAreaIDCount.append([i])
                            addAreaID.append(smallPiece[x][y].areaIDMap[i][2])
                        }
                    }
                    // linking...
                    var translateNewID = [Int]()
                    var translateOldID = [Int]()
                    
                    for i in 0...linkedAreaID.count-1{
                        
                        for k in 0...addAreaID.count-1{
                            var sameID = 0
                            for a in 0...linkedAreaCount[i].count-1{
                                for b in 0...addAreaIDCount[k].count-1{
                                    if(linkedAreaCount[i][a] == addAreaIDCount[k][b]){
                                        sameID += 1
                                    }
                                }
                            }
                            if(Float(sameID)/Float(linkedAreaCount[i].count) >= 0.5){
                                translateOldID.append(linkedAreaID[i])
                                translateNewID.append(addAreaID[k])
                            }
                        }
                    }
                    var removedAreaIDGroup = [Int]()
                    for i in 0...areaInLine[x].count-1{
                        var removedIndex = [Int]()
                        for k in 0...areaInLine[x][i].pointsInArea.count-1{
                            if(areaInLine[x][i].pointsInArea[k].y >= 2+y*4){
                                removedIndex.append(k)
                            }
                        }
                        if(removedIndex.count != 0){
                            if(removedIndex.count >= 2){
                                for n in 0...removedIndex.count-2{
                                    for m in 0...removedIndex.count-2-n{
                                        if(removedIndex[m] <= removedIndex[m+1]){
                                            let changeValue = removedIndex[m]
                                            removedIndex[m] = removedIndex[m+1]
                                            removedIndex[m+1] = changeValue
                                        }
                                    }
                                }
                            }
                            
                            for k in 0...removedIndex.count-1{
                                areaInLine[x][i].pointsInArea.remove(at: removedIndex[k])
                            }
                            if(areaInLine[x][i].pointsInArea.count <= 0){
                                var isSameWithTranslate = false
                                for k in 0...translateOldID.count-1{
                                    isSameWithTranslate = isSameWithTranslate || translateOldID[k] == i
                                }
                                if(isSameWithTranslate){
                                    removedAreaIDGroup.append(i)
                                }
                            }
                        }
                    }
                    
                    if(translateNewID.count != 0){
                        for i in 0...translateNewID.count-1{
                            for k in 0...smallPiece[x][y].areas[translateNewID[i]].pointsInArea.count-1{
                                if(smallPiece[x][y].areas[translateNewID[i]].pointsInArea[k].y >= 2){
                                    areaInLine[x][translateOldID[i]].pointsInArea.append(Point(
                                        x: smallPiece[x][y].areas[translateNewID[i]].pointsInArea[k].x,
                                        y: smallPiece[x][y].areas[translateNewID[i]].pointsInArea[k].y+y*4))
                                }
                            }
                        }
                    }
                    
                    for i in 0...translateOldID.count-1{
                        for k in 0...areaInLine[x][translateOldID[i]].pointsInArea.count-1{
                            areaIDMapInLine[x][areaInLine[x][translateOldID[i]].pointsInArea[k].x][areaInLine[x][translateOldID[i]].pointsInArea[k].y] = translateOldID[i]
                        }
                    }
                    
                    if(removedAreaIDGroup.count >= 1){
                        for i in 0...removedAreaIDGroup.count-1{
                            areaInLine[x].remove(at: removedAreaIDGroup[removedAreaIDGroup.count-1-i])
                        }
                    }
                    
                    let oldAreasCount = areaInLine[x].count
                    
                    for i in 0...smallPiece[x][y].areas.count-1{
                        var isSame = false
                        if(translateNewID.count != 0){
                            for k in 0...translateNewID.count-1{
                                isSame = isSame || translateNewID[k] == i
                            }
                        }
                        if(!isSame){
                            
                            areaInLine[x].append(smallPiece[x][y].areas[i])
                            var removedIndex = [Int]()
                            for k in 0...areaInLine[x][areaInLine[x].count-1].pointsInArea.count-1{
                                if(areaInLine[x][areaInLine[x].count-1].pointsInArea[k].y >= 2+y*4){
                                    areaInLine[x][areaInLine[x].count-1].pointsInArea[k].y += y*4
                                }
                                else{
                                    removedIndex.append(k)
                                }
                            }
                            
                            if(removedIndex.count >= 1){
                                if(removedIndex.count == areaInLine[x][areaInLine[x].count-1].pointsInArea.count){
                                    areaInLine[x].removeLast()
                                }
                                else{
                                    if(removedIndex.count >= 2){
                                        for n in 0...removedIndex.count-2{
                                            for m in 0...n{
                                                if(removedIndex[m] <= removedIndex[m+1]){
                                                    let changeValue = removedIndex[m]
                                                    removedIndex[m] = removedIndex[m+1]
                                                    removedIndex[m+1] = changeValue
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        for k in 0...removedIndex.count-1{
                                            areaInLine[x][areaInLine[x].count-1].pointsInArea.remove(at: removedIndex[k])
                                        }
                                    }
                                }
                            }
                            
                            if(areaInLine[x][areaInLine[x].count-1].pointsInArea.count <= 0){
                                areaInLine[x].removeLast()
                            }
                        }
                        
                    }
                    
                    if(areaInLine[x].count > oldAreasCount){
                        for i in oldAreasCount...areaInLine[x].count-1{
                            for k in 0...areaInLine[x][i].pointsInArea.count-1{
                                areaIDMapInLine[x][areaInLine[x][i].pointsInArea[k].x][areaInLine[x][i].pointsInArea[k].y] = i
                            }
                        }
                    }
                }
            }
        }
        
        
        var pointsInTotal = 0
        for index in 0...areaInLine[2].count-1{
            areas.append(areaInLine[2][index])
            pointsInTotal += areaInLine[2][index].pointsInArea.count
        }
        print("points: \(pointsInTotal)")
        
        var notLinkYet = true
        for x in 0...6{
            
            if(notLinkYet){
                //                    first initialize the area for the frist small piece in the line
                notLinkYet = false
                print("areaCounts: \(areaInLine[x].count-1)")
                for index in 0...areaInLine[x].count-1{
                    
                    areas.append(areaInLine[x][index])
                    print(areaInLine[x][index].pointsInArea.count-1)
                    for i in 0...areaInLine[x][index].pointsInArea.count-1{
                        
                        areaIDMap[areaInLine[x][index].pointsInArea[i].x][areaInLine[x][index].pointsInArea[i].y] = index
                    }
                }
                
            }
            else{
                //                    needed to be link with the last now
                var linkedAreaID = [areaIDMap[(x-1)*4+6][0]]
                var linkedAreaCount = [[0]]
                var addAreaID = [areaIDMapInLine[x][2][0]]
                var addAreaIDCount = [[0]]
                
                // initialize areaID in order to link areas
                for i in 1...31{
                    var isSameLinkedArea = false
                    var isSameAddArea = false
                    var addAreaIndex = 0
                    var linkedAreaIndex = 0
                    for k in 0...linkedAreaID.count-1{
                        if(linkedAreaID[k] == areaIDMap[(x-1)*4+6][i]){
                            isSameLinkedArea = true
                            linkedAreaIndex = k
                        }
                    }
                    for k in 0...addAreaID.count-1{
                        if(addAreaID[k] == areaIDMapInLine[x][2][i]){
                            isSameAddArea = true
                            addAreaIndex = k
                        }
                    }
                    if(isSameLinkedArea){
                        linkedAreaCount[linkedAreaIndex].append(i)
                    }
                    else{
                        linkedAreaCount.append([i])
                        linkedAreaID.append(areaIDMap[(x-1)*4+6][i])
                    }
                    if(isSameAddArea){
                        addAreaIDCount[addAreaIndex].append(i)
                    }
                    else{
                        addAreaIDCount.append([i])
                        addAreaID.append(areaIDMapInLine[x][2][i])
                    }
                }
                // linking...
                var translateNewID = [Int]()
                var translateOldID = [Int]()
                
                for i in 0...linkedAreaID.count-1{
                    
                    for k in 0...addAreaID.count-1{
                        var sameID = 0
                        for a in 0...linkedAreaCount[i].count-1{
                            for b in 0...addAreaIDCount[k].count-1{
                                if(linkedAreaCount[i][a] == addAreaIDCount[k][b]){
                                    sameID += 1
                                }
                            }
                        }
                        if(Float(sameID)/Float(linkedAreaCount[i].count) >= 0.5){
                            translateOldID.append(linkedAreaID[i])
                            translateNewID.append(addAreaID[k])
                        }
                    }
                }
                
                var removedAreaIDGroup = [Int]()
                for i in 0...areas.count-1{
                    var removedIndex = [Int]()
                    for k in 0...areas[i].pointsInArea.count-1{
                        if(areas[i].pointsInArea[k].x >= 2+x*4){
                            removedIndex.append(k)
                        }
                    }
                    if(removedIndex.count != 0){
                        if(removedIndex.count >= 2){
                            for n in 0...removedIndex.count-2{
                                for m in 0...removedIndex.count-2-n{
                                    if(removedIndex[m] <= removedIndex[m+1]){
                                        let changeValue = removedIndex[m]
                                        removedIndex[m] = removedIndex[m+1]
                                        removedIndex[m+1] = changeValue
                                    }
                                }
                            }
                        }
                        
                        for k in 0...removedIndex.count-1{
                            areas[i].pointsInArea.remove(at: removedIndex[k])
                        }
                        
                        if(areas[i].pointsInArea.count <= 0){
                            var isSameWithTranslate = false
                            for k in 0...translateOldID.count-1{
                                isSameWithTranslate = isSameWithTranslate || translateOldID[k] == i
                            }
                            if(isSameWithTranslate){
                                removedAreaIDGroup.append(i)
                            }
                        }
                    }
                }
                
                if(translateNewID.count != 0){
                    for i in 0...translateNewID.count-1{
                        for k in 0...areaInLine[x][translateNewID[i]].pointsInArea.count-1{
                            if(areaInLine[x][translateNewID[i]].pointsInArea[k].y >= 2){
                                areas[translateOldID[i]].pointsInArea.append(Point(
                                    x: areaInLine[x][translateNewID[i]].pointsInArea[k].x+x*4,
                                    y: areaInLine[x][translateNewID[i]].pointsInArea[k].y))
                            }
                        }
                    }
                }
                
                for i in 0...translateOldID.count-1{
                    for k in 0...areas[translateOldID[i]].pointsInArea.count-1{
                        areaIDMap[areas[translateOldID[i]].pointsInArea[k].x][areas[translateOldID[i]].pointsInArea[k].y] = translateOldID[i]
                    }
                }
                
                if(removedAreaIDGroup.count >= 1){
                    for i in 0...removedAreaIDGroup.count-1{
                        areas.remove(at: removedAreaIDGroup[removedAreaIDGroup.count-1-i])
                    }
                }
                
                let oldAreasCount = areas.count
                
                for i in 0...areaInLine[x].count-1{
                    var isSame = false
                    if(translateNewID.count != 0){
                        for k in 0...translateNewID.count-1{
                            isSame = isSame || translateNewID[k] == i
                        }
                    }
                    if(!isSame){
                        
                        areas.append(areaInLine[x][i])
                        var removedIndex = [Int]()
                        for k in 0...areas[areas.count-1].pointsInArea.count-1{
                            if(areas[areas.count-1].pointsInArea[k].y >= 2+x*4){
                                areas[areas.count-1].pointsInArea[k].x += x*4
                            }
                            else{
                                removedIndex.append(k)
                            }
                        }
                        
                        if(removedIndex.count >= 1){
                            if(removedIndex.count == areas[areas.count-1].pointsInArea.count){
                                areas.removeLast()
                            }
                            else{
                                if(removedIndex.count >= 2){
                                    for n in 0...removedIndex.count-2{
                                        for m in 0...n{
                                            if(removedIndex[m] <= removedIndex[m+1]){
                                                let changeValue = removedIndex[m]
                                                removedIndex[m] = removedIndex[m+1]
                                                removedIndex[m+1] = changeValue
                                            }
                                        }
                                    }
                                }
                                else{
                                    for k in 0...removedIndex.count-1{
                                        areas[areas.count-1].pointsInArea.remove(at: removedIndex[k])
                                    }
                                }
                            }
                        }
                        
                        if(areas[areas.count-1].pointsInArea.count <= 0){
                            areas.removeLast()
                        }
                    }
                }
                
                if(areaInLine[x].count > oldAreasCount){
                    for i in oldAreasCount...areaInLine[x].count-1{
                        for k in 0...areas[i].pointsInArea.count-1{
                            areaIDMap[areas[i].pointsInArea[k].x][areas[i].pointsInArea[k].y] = i
                        }
                    }
                }
            }
        }
    
        //Regionalization, devide in to unit of area
        /*
        var isFirstTimeAddArea = true
        var isNotGoToLinkYet = true
        var currentArea = 0
        for x in 0...3{
            for y in 0...3{
                //initialize the first ever small piece area
                if(isNotGoToLinkYet){
     
                    isNotGoToLinkYet = false
                    for i in 0...self.smallPiece[x][y].areaMap.areas.count-1{
                        if(isFirstTimeAddArea){
                            self.areaMap.areas[currentArea] = self.smallPiece[x][y].areaMap.areas[i]
                            isFirstTimeAddArea = false
                        }
                        else{
                            currentArea += 1
                            self.areaMap.areas.append(self.smallPiece[x][y].areaMap.areas[i])
                            
                            for arrIndex in 0...self.areaMap.areas[currentArea].pointsInArea.count-1{
                                self.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
                                self.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
                            }
                            
                            for k in 0...7{
                                if(self.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
                                    self.smallPiece[x][y].inputPixelsAreaID[0][k] = currentArea
                                }
                                if(self.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
                                    self.smallPiece[x][y].inputPixelsAreaID[1][k] = currentArea
                                }
                                if(self.smallPiece[x][y].outputPixelsAreaID[0][k] == i){
                                    self.smallPiece[x][y].outputPixelsAreaID[0][k] = currentArea
                                }
                                if(self.smallPiece[x][y].outputPixelsAreaID[1][k] == i){
                                    self.smallPiece[x][y].outputPixelsAreaID[1][k] = currentArea
                                }
                            }
                        }
                        
                    }
                }
                //linking part
                else{
                    var relativeArray = [[Int](),[Int]()]
                    for i in 0...self.smallPiece[x][y].areaMap.areas.count-1{
                        var isLinked = true
                        var linkedTimes = 0
                        var linkedAreaID = 0
                        
                        if(y == 0){
                            for k in 0...7{
                                if(self.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[0][k].rgb.red-self.smallPiece[x-1][y].colorPoints[7][k].rgb.red <= 8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[0][k].rgb.red-self.smallPiece[x-1][y].colorPoints[7][k].rgb.red >= -8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[0][k].rgb.green-self.smallPiece[x-1][y].colorPoints[7][k].rgb.green <= 8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[0][k].rgb.green-self.smallPiece[x-1][y].colorPoints[7][k].rgb.green >= -8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[0][k].rgb.blue-self.smallPiece[x-1][y].colorPoints[7][k].rgb.blue <= 8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[0][k].rgb.blue-self.smallPiece[x-1][y].colorPoints[7][k].rgb.blue >= -8
                                    
                                    isLinked = isLinked && self.smallPiece[x-1][y].areaMap.areas[self.smallPiece[x-1][y].outputPixelsAreaID[0][k]].mode == self.smallPiece[x][y].areaMap.areas[i].mode
                                    if(isLinked){
                                         //needed to be complex, isLinked condition changed by add area mode
                                        linkedTimes += 1
                                        linkedAreaID = self.smallPiece[x-1][y].outputPixelsAreaID[0][k]
                                        
                                    }
                                }
                            }
                        }
                        else if(x == 0){
                            for k in 0...7{
                                if(self.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[k][0].rgb.red-self.smallPiece[x][y-1].colorPoints[k][7].rgb.red <= 8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[k][0].rgb.red-self.smallPiece[x][y-1].colorPoints[k][7].rgb.red >= -8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[k][0].rgb.green-self.smallPiece[x][y-1].colorPoints[k][7].rgb.green <= 8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[k][0].rgb.green-self.smallPiece[x][y-1].colorPoints[k][7].rgb.green >= -8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[k][0].rgb.blue-self.smallPiece[x][y-1].colorPoints[k][7].rgb.blue <= 8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y].colorPoints[k][0].rgb.blue-self.smallPiece[x][y-1].colorPoints[k][7].rgb.blue >= -8
                                    
                                    isLinked = isLinked && self.smallPiece[x][y-1].areaMap.areas[self.smallPiece[x][y-1].outputPixelsAreaID[1][k]].mode == self.smallPiece[x][y].areaMap.areas[i].mode
                                    if(isLinked){
                                        //needed to be complex, isLinked condition changed by add area mode
                                        linkedTimes += 1
                                        linkedAreaID = self.smallPiece[x][y-1].outputPixelsAreaID[1][k]
                                    }
                                }
                            }
                        }
                        else{
                            for k in 0...7{
                                if(self.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
                                    var isLinkedY = true
                                    var isLinkedX = true
                                    isLinkedY = isLinkedY && self.smallPiece[x][y].colorPoints[k][0].rgb.red-self.smallPiece[x][y-1].colorPoints[k][7].rgb.red <= 8
                                    
                                    isLinkedY = isLinkedY && self.smallPiece[x][y].colorPoints[k][0].rgb.red-self.smallPiece[x][y-1].colorPoints[k][7].rgb.red >= -8
                                    
                                    isLinkedY = isLinkedY && self.smallPiece[x][y].colorPoints[k][0].rgb.green-self.smallPiece[x][y-1].colorPoints[k][7].rgb.green <= 8
                                    
                                    isLinkedY = isLinkedY && self.smallPiece[x][y].colorPoints[k][0].rgb.green-self.smallPiece[x][y-1].colorPoints[k][7].rgb.green >= -8
                                    
                                    isLinkedY = isLinkedY && self.smallPiece[x][y].colorPoints[k][0].rgb.blue-self.smallPiece[x][y-1].colorPoints[k][7].rgb.blue <= 8
                                    
                                    isLinkedY = isLinkedY && self.smallPiece[x][y].colorPoints[k][0].rgb.blue-self.smallPiece[x][y-1].colorPoints[k][7].rgb.blue >= -8
                                    
                                    isLinkedX = isLinkedX && self.smallPiece[x][y].colorPoints[0][k].rgb.red-self.smallPiece[x-1][y].colorPoints[7][k].rgb.red <= 8
                                    
                                    isLinkedX = isLinkedX && self.smallPiece[x][y].colorPoints[0][k].rgb.red-self.smallPiece[x-1][y].colorPoints[7][k].rgb.red >= -8
                                    
                                    isLinkedX = isLinkedX && self.smallPiece[x][y].colorPoints[0][k].rgb.green-self.smallPiece[x-1][y].colorPoints[7][k].rgb.green <= 8
                                    
                                    isLinkedX = isLinkedX && self.smallPiece[x][y].colorPoints[0][k].rgb.green-self.smallPiece[x-1][y].colorPoints[7][k].rgb.green >= -8
                                    
                                    isLinkedX = isLinkedX && self.smallPiece[x][y].colorPoints[0][k].rgb.blue-self.smallPiece[x-1][y].colorPoints[7][k].rgb.blue <= 8
                                    
                                    isLinkedX = isLinkedX && self.smallPiece[x][y].colorPoints[0][k].rgb.blue-self.smallPiece[x-1][y].colorPoints[7][k].rgb.blue >= -8
                                     //needed to be complex, isLinked condition changed by add area mode
                                    if(isLinkedX){
                                        linkedTimes += 1
                                        linkedAreaID = self.smallPiece[x-1][y].outputPixelsAreaID[0][k]
                                    }
                                    if(isLinkedY){
                                        
                                        linkedTimes += 1
                                        linkedAreaID = self.smallPiece[x][y-1].outputPixelsAreaID[1][k]
                                    }
                                    
                                }
                            }
                        }
                        //this should 
                        if(linkedTimes >= 1){
                            for k in 0...self.smallPiece[x][y].areaMap.areas[i].pointsInArea.count-1{
                                self.areaMap.areas[linkedAreaID].pointsInArea.append(Point(x: self.smallPiece[x][y].areaMap.areas[i].pointsInArea[k].x+x*8, y: self.smallPiece[x][y].areaMap.areas[i].pointsInArea[k].y+y*8))
                            }
                            //update the inputs and outputs
                            for k in 0...7{
                                if(self.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
                                    self.smallPiece[x][y].inputPixelsAreaID[0][k] = linkedAreaID
                                }
                                if(self.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
                                    self.smallPiece[x][y].inputPixelsAreaID[1][k] = linkedAreaID
                                }
                                if(self.smallPiece[x][y].outputPixelsAreaID[0][k] == i){
                                    self.smallPiece[x][y].outputPixelsAreaID[0][k] = linkedAreaID
                                }
                                if(self.smallPiece[x][y].outputPixelsAreaID[1][k] == i){
                                    self.smallPiece[x][y].outputPixelsAreaID[1][k] = linkedAreaID
                                }
                            }
                        }
                        else{
                            currentArea += 1
                            self.areaMap.areas.append(self.smallPiece[x][y].areaMap.areas[i])
                            for arrIndex in 0...self.areaMap.areas[currentArea].pointsInArea.count-1{
                                self.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
                                self.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
                            }
                            //update the inputs and outputs
                            for k in 0...7{
                                if(self.smallPiece[x][y].inputPixelsAreaID[0][k] == i){
                                    self.smallPiece[x][y].inputPixelsAreaID[0][k] = currentArea
                                }
                                if(self.smallPiece[x][y].inputPixelsAreaID[1][k] == i){
                                    self.smallPiece[x][y].inputPixelsAreaID[1][k] = currentArea
                                }
                                if(self.smallPiece[x][y].outputPixelsAreaID[0][k] == i){
                                    self.smallPiece[x][y].outputPixelsAreaID[0][k] = currentArea
                                }
                                if(self.smallPiece[x][y].outputPixelsAreaID[1][k] == i){
                                    self.smallPiece[x][y].outputPixelsAreaID[1][k] = currentArea
                                }
                            }
                        }
                    }
                }
            }
        }
    */
        //in this case input and output need to be reverse, because they are adjacent to each.
        /*
        for x in 0...3{
            for i in 0...7{
                self.midInputPixelsAreaID[1].append(self.smallPiece[x][1].outputPixelsAreaID[1][i])
                self.midOutputPixelsAreaID[1].append(self.smallPiece[x][2].inputPixelsAreaID[1][i])
            }
        }
        for y in 0...3{
            for i in 0...7{
                self.midInputPixelsAreaID[0].append(self.smallPiece[1][y].outputPixelsAreaID[0][i])
                self.midOutputPixelsAreaID[0].append(self.smallPiece[2][y].inputPixelsAreaID[0][i])
                
            }
        }
        //back to the normal again
        for x in 0...3{
            for i in 0...7{
                self.inputPixelsAreaID[1].append(self.smallPiece[x][0].inputPixelsAreaID[1][i])
                self.outputPixelsAreaID[1].append(self.smallPiece[x][3].outputPixelsAreaID[1][i])
            }
        }
        for y in 0...3{
            for i in 0...7{
                self.inputPixelsAreaID[0].append(self.smallPiece[0][y].inputPixelsAreaID[0][i])
                self.outputPixelsAreaID[0].append(self.smallPiece[3][y].outputPixelsAreaID[0][i])
                
            }
        }*/
        //***************************************************//
        for i in 0...1{
            for k in 0...3{
                var redSum:Float = 0
                var blueSum:Float = 0
                var greemSum:Float = 0
                for numOfLine in 0...3{
                    if(i==0){
                        redSum += Float(self.smallPiece[k][numOfLine].mean.components.red)
                        greemSum += Float(self.smallPiece[k][numOfLine].mean.components.green)
                        blueSum += Float(self.smallPiece[k][numOfLine].mean.components.blue)
                    }
                    else{
                        redSum += Float(self.smallPiece[numOfLine][k].mean.components.red)
                        greemSum += Float(self.smallPiece[numOfLine][k].mean.components.green)
                        blueSum += Float(self.smallPiece[numOfLine][k].mean.components.blue)
                    }
                }
                self.rangeColor[i][k].rgb.red = redSum/4
                self.rangeColor[i][k].rgb.green = greenSum/4
                self.rangeColor[i][k].rgb.blue = blueSum/4
            }
        }
        print("end")
    }
}
















