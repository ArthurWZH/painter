//
//  SmallPiece.swift
//  PixelEditor
//
//  Created by Zihao Arthur Wang [STUDENT] on 2017/5/17.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import Foundation

import UIKit
class SmallPiece{
    var scale = 8
    var colorRange = ColorRange()
    var mean = UIColor.black
    
    var colorPoints = [[DataOfColor]]()
    var pixelInRange = [[[[Point]]]]()
    
    var areaIDMap = [[Int]]()
    
    var rangeColor = [[DataOfColor(),DataOfColor(),DataOfColor(),DataOfColor()],
                      [DataOfColor(),DataOfColor(),DataOfColor(),DataOfColor()]]
    
    var hugePixel = [[DataRGB(),DataRGB(),DataRGB(),DataRGB()],
                     [DataRGB(),DataRGB(),DataRGB(),DataRGB()],
                     [DataRGB(),DataRGB(),DataRGB(),DataRGB()],
                     [DataRGB(),DataRGB(),DataRGB(),DataRGB()]]
    
    var areaNumber = 0
    var areas = [UnitArea()]
    init(image: UIImage, coordinate: Point){
        let imageView = UIImageView(image: image)
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        var redSum: Float = 0
        var blueSum: Float = 0
        var greenSum: Float = 0
        
        for _ in 0...31{
            var darr = [[[Point]]]()
            for _ in 0...31{
                var arr = [[Point]]()
                for _ in 0...31{
                    arr.append([Point]())
                }
                darr.append(arr)
            }
            self.pixelInRange.append(darr)
        }
        
        for _ in 0...31{
            var line = [Int]()
            for _ in 0...31{
                line.append(0)
            }
            self.areaIDMap.append(line)
        }
        
        for x in (0)...(7){
            var pointOfPointInLine = [DataOfColor]()
            for y in (0)...(7){
                
                //range code block{
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
                
                
                
                
                //range code block end}
                
                //sum code block in loop{
                
                redSum = redSum+Float(pointColor.components.red)
                blueSum = blueSum+Float(pointColor.components.blue)
                greenSum = greenSum+Float(pointColor.components.green)
                //sum code block in loop end}
                
                //pixelRange init code block{
                var redRangeIndex = Int(pointColor.components.red/8)
                var greenRangeIndex = Int(pointColor.components.green/8)
                var blueRangeIndex = Int(pointColor.components.blue/8)
                
                if(Float(redRangeIndex) > Float(pointColor.components.red/8)){redRangeIndex-=1}
                if(Float(greenRangeIndex) > Float(pointColor.components.green/8)){greenRangeIndex-=1}
                if(Float(blueRangeIndex) > Float(pointColor.components.blue/8)){blueRangeIndex-=1}
                
                self.pixelInRange[redRangeIndex][greenRangeIndex][blueRangeIndex].append(Point(x: x, y: y))
                //pixelRange init code block end}
                //initialize point dataOfColor code block{
                let color = DataOfColor(rgb: DataRGB(red: Float(pointColor.components.red), green: Float(pointColor.components.green), blue: Float(pointColor.components.blue)), redRange: redRangeIndex, greenRange: greenRangeIndex, blueRange: blueRangeIndex)
                
                pointOfPointInLine.append(color)
                //point dataOfColor code block end}
            }
            self.colorPoints.append(pointOfPointInLine)
        }
        
        //test area, can ignore
        
    
    
        //All the information for huge Pixel code block{
        self.mean = UIColor(colorLiteralRed: redSum/256/255, green: greenSum/256/255, blue: blueSum/256/255, alpha: 1)
        for x in 0...3{
            for y in 0...3{
                self.hugePixel[x][y] = mergePixel(image: image, coordinate: Point(x: coordinate.x+x*2, y: coordinate.y+y*2), size: Size(width: 2, height: 2))
            }
        }
        for i in 0...1{
            for k in 0...3{
                var redSum:Float = 0
                var blueSum:Float = 0
                var greemSum:Float = 0
                for numOfLine in 0...3{
                    if(i==0){
                        redSum += Float(self.hugePixel[k][numOfLine].red)
                        greemSum += Float(self.hugePixel[k][numOfLine].green)
                        blueSum += Float(self.hugePixel[k][numOfLine].blue)
                    }
                    else{
                        redSum += Float(self.hugePixel[numOfLine][k].red)
                        greemSum += Float(self.hugePixel[numOfLine][k].green)
                        blueSum += Float(self.hugePixel[numOfLine][k].blue)
                    }
                }
                self.rangeColor[i][k].rgb.red = redSum/4
                self.rangeColor[i][k].rgb.green = greenSum/4
                self.rangeColor[i][k].rgb.blue = blueSum/4
            }
        }
        //huge pixel code block end}
        
        //initialize how many pixels in the range code block{
        var firstTimeAddArea = true
        var lastColorRange = DataOfColor()
        var areaIDForTheRange = [[[Int]]]()
        for _ in 0...31{
            var gbAreaID = [[Int]]()
            for _ in 0...31{
                var bAreaID = [Int]()
                for _ in 0...31{
                    bAreaID.append(-1)
                }
                gbAreaID.append(bAreaID)
            }
            areaIDForTheRange.append(gbAreaID)
        }
        //initialize how many pixels in the range code block end}
        
        //arealize{
        var colorGotThere = [TriCoordinate]()
        var sumOfCounts = 0
        for r in 0...31{
            for g in 0...31{
                for b in 0...31{
                    if(self.pixelInRange[r][g][b].count >= 1){
                        /*problem!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         !!!!!!!!!!!!!!!!!!!!
                         */

                        var rangeToNext = false
                        if(firstTimeAddArea){
                            firstTimeAddArea = false
                            areaIDForTheRange[r][g][b] = 0
                            
                            var firstTimeAddPoint = true
                            for i in 0...pixelInRange[r][g][b].count-1{
                                if(firstTimeAddPoint){
                                    firstTimeAddPoint = false
                                    self.areas[0].pointsInArea[0] = Point(x: pixelInRange[r][g][b][i].x, y: pixelInRange[r][g][b][i].y)
                                    self.areas[0].colorDataForPoints.append(self.colorPoints[pixelInRange[r][g][b][i].x][pixelInRange[r][g][b][i].y])
                                    sumOfCounts += 1
                                }
                                else{
                                    self.areas[0].pointsInArea.append(Point(x: pixelInRange[r][g][b][i].x, y: pixelInRange[r][g][b][i].y))
                                    self.areas[0].colorDataForPoints.append(self.colorPoints[pixelInRange[r][g][b][i].x][pixelInRange[r][g][b][i].y])
                                    sumOfCounts += 1
                                }
                            }
                        }
                        else{
                            var indexInTheLoop = 0
                            while(!rangeToNext && indexInTheLoop < colorGotThere.count){
                                
                                rangeToNext = r-colorGotThere[indexInTheLoop].x <= 1
                                rangeToNext = rangeToNext && r-colorGotThere[indexInTheLoop].x >= -1
                                rangeToNext = rangeToNext && g-colorGotThere[indexInTheLoop].y <= 1
                                rangeToNext = rangeToNext && g-colorGotThere[indexInTheLoop].y >= -1
                                rangeToNext = rangeToNext && b-colorGotThere[indexInTheLoop].z <= 1
                                rangeToNext = rangeToNext && b-colorGotThere[indexInTheLoop].z >= -1
                                
                                if(rangeToNext){
                                    lastColorRange.redRange = colorGotThere[indexInTheLoop].x
                                    lastColorRange.greenRange = colorGotThere[indexInTheLoop].y
                                    lastColorRange.blueRange = colorGotThere[indexInTheLoop].z
                                }
                                indexInTheLoop += 1
                            }
                            
                            if(rangeToNext){
                                
                                for i in 0...pixelInRange[r][g][b].count-1{
                                    self.areas[areaIDForTheRange[lastColorRange.redRange][lastColorRange.greenRange][lastColorRange.blueRange]].pointsInArea.append(Point(x: pixelInRange[r][g][b][i].x, y: pixelInRange[r][g][b][i].y))
                                    self.areas[areaIDForTheRange[lastColorRange.redRange][lastColorRange.greenRange][lastColorRange.blueRange]].colorDataForPoints.append(self.colorPoints[pixelInRange[r][g][b][i].x][pixelInRange[r][g][b][i].y])
                                    sumOfCounts += 1
                                }
                                
                                areaIDForTheRange[r][g][b] = areaIDForTheRange[lastColorRange.redRange][lastColorRange.greenRange][lastColorRange.blueRange]
                            }
                            else{
                                self.areaNumber += 1
                                areaIDForTheRange[r][g][b] = self.areaNumber
                                var area: UnitArea? = UnitArea()
                                var firstTimeAddPoint = true
                                for i in 0...pixelInRange[r][g][b].count-1{
                                    if(firstTimeAddPoint){
                                        firstTimeAddPoint = false
                                        area?.pointsInArea[0] = Point(x: pixelInRange[r][g][b][i].x, y: pixelInRange[r][g][b][i].y)
                                        area?.colorDataForPoints.append(self.colorPoints[pixelInRange[r][g][b][i].x][pixelInRange[r][g][b][i].y])
                                        sumOfCounts += 1
                                    }
                                    else{
                                        area?.pointsInArea.append(Point(x: pixelInRange[r][g][b][i].x, y: pixelInRange[r][g][b][i].y))
                                        area?.colorDataForPoints.append(self.colorPoints[pixelInRange[r][g][b][i].x][pixelInRange[r][g][b][i].y])
                                        sumOfCounts += 1
                                    }
                                }
                                self.areas.append(area!)
                                area = nil
                            }
                        }
                        colorGotThere.append(TriCoordinate(x: r, y: g, z: b))
                    }
                }
            }
        }
        
        
        
        //arealize end}
       
        //initialize the area data
        for i in 0...self.areas.count-1{
            //initialize range and mean of the area
            var redSum:Float = 0
            var blueSum:Float = 0
            var greenSum:Float = 0
            for k in 0...self.areas[i].pointsInArea.count-1{
                if(self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.red > self.areas[i].rangeColor.redRange.high){
                    
                    self.areas[i].rangeColor.redRange.high = self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.red
                }
                if(self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.red < self.areas[i].rangeColor.redRange.low){
                    
                    self.areas[i].rangeColor.redRange.low = self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.red
                }
                if(self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.green > self.areas[i].rangeColor.greenRange.high){
                    
                    self.areas[i].rangeColor.greenRange.high = self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.green
                }
                if(self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.green < self.areas[i].rangeColor.greenRange.low){
                    
                    self.areas[i].rangeColor.greenRange.low = self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.green
                }
                if(self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.blue > self.areas[i].rangeColor.blueRange.high){
                    
                    self.areas[i].rangeColor.blueRange.high = self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.blue
                }
                if(self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.blue < self.areas[i].rangeColor.blueRange.low){
                    
                    self.areas[i].rangeColor.blueRange.low = self.colorPoints[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y].rgb.blue
                }
                redSum += self.areas[i].colorDataForPoints[k].rgb.red
                greenSum += self.areas[i].colorDataForPoints[k].rgb.green
                blueSum += self.areas[i].colorDataForPoints[k].rgb.blue
            }
            self.areas[i].mean.rgb.red = Float(Int(redSum)/self.areas[i].pointsInArea.count)
            self.areas[i].mean.rgb.green = Float(Int(greenSum)/self.areas[i].pointsInArea.count)
            self.areas[i].mean.rgb.blue = Float(Int(blueSum)/self.areas[i].pointsInArea.count)
            
            self.areas[i].mean.redRange = Int(self.areas[i].mean.rgb.red/8)
            self.areas[i].mean.greenRange = Int(self.areas[i].mean.rgb.green/8)
            self.areas[i].mean.blueRange = Int(self.areas[i].mean.rgb.blue/8)
            
            if(Float(self.areas[i].mean.redRange) > Float(self.areas[i].mean.rgb.red/8)){self.areas[i].mean.redRange-=1}
            if(Float(self.areas[i].mean.greenRange) > Float(self.areas[i].mean.rgb.green/8)){self.areas[i].mean.greenRange-=1}
            if(Float(self.areas[i].mean.blueRange) > Float(self.areas[i].mean.rgb.blue/8)){self.areas[i].mean.blueRange-=1}
        }
        
        
        for i in 0...self.areas.count-1{
            
            let redChangingRatio = self.areas[i].rangeColor.redRange.low/self.areas[i].rangeColor.redRange.high
            let greenChangingRatio = self.areas[i].rangeColor.greenRange.low/self.areas[i].rangeColor.greenRange.high
            let blueChangingRatio = self.areas[i].rangeColor.blueRange.low/self.areas[i].rangeColor.blueRange.high
            
            var sameColor = redChangingRatio-greenChangingRatio <= redChangingRatio/8
            sameColor = sameColor && redChangingRatio-greenChangingRatio >= -redChangingRatio/8
            sameColor = sameColor && blueChangingRatio-greenChangingRatio <= blueChangingRatio/8
            sameColor = sameColor && blueChangingRatio-greenChangingRatio >= -blueChangingRatio/8
            sameColor = sameColor && redChangingRatio-blueChangingRatio <= greenChangingRatio/8
            sameColor = sameColor && redChangingRatio-blueChangingRatio >= -greenChangingRatio/8
            
            var smallDifference = self.areas[i].rangeColor.redRange.getDifference() <= 20
            smallDifference = smallDifference && self.areas[i].rangeColor.greenRange.getDifference() <= 25
            smallDifference = smallDifference && self.areas[i].rangeColor.blueRange.getDifference() <= 25
            smallDifference = smallDifference && self.areas[i].rangeColor.redRange.getDifference() <= 25
            
            
            
            
            
            if(sameColor && smallDifference){
                
                self.areas[i].mode = Coefficient.ONEAREAMODE
            }
            else if(self.areas[i].pointsInArea.count > 5){
                //check the heavy ranges, will do saperate range later
                var rangeDataCollector = [self.areas[i].colorDataForPoints[0]]
                var amountOfPixelInTheRanges = [1]
                var saperatedAreas = [UnitArea()]
                var finalAreas = [UnitArea]()
                saperatedAreas[0].pointsInArea[0] = self.areas[i].pointsInArea[0]
                
                
                
                for k in 1...self.areas[i].pointsInArea.count-1{
                    var theSame = true
                    var index = 0
                    for checkSameIndex in 0...rangeDataCollector.count-1{
                        var isTheSame = true
                        isTheSame = isTheSame && self.areas[i].colorDataForPoints[k].blueRange == rangeDataCollector[checkSameIndex].blueRange
                        isTheSame = isTheSame && self.areas[i].colorDataForPoints[k].greenRange == rangeDataCollector[checkSameIndex].greenRange
                        isTheSame = isTheSame && self.areas[i].colorDataForPoints[k].redRange == rangeDataCollector[checkSameIndex].redRange
                        if(isTheSame){
                            theSame = true
                            index = checkSameIndex
                        }
                        
                    }
                    if(theSame){
                        amountOfPixelInTheRanges[index] += 1
                        
                        saperatedAreas[index].pointsInArea.append(self.areas[i].pointsInArea[k])
                    }
                    else{
                        rangeDataCollector.append(self.areas[i].colorDataForPoints[k])
                        amountOfPixelInTheRanges.append(1)
                        var newArea: UnitArea? = UnitArea()
                        newArea?.pointsInArea[0] = self.areas[i].pointsInArea[k]
                        
                        saperatedAreas.append(newArea!)
                        newArea = nil
                    }

                }
                                //start to saparate
                var areaIDGroups = [[Int]]()
                var firstTimeAppend = true
                for k in 0...amountOfPixelInTheRanges.count-1{
                    
                    var isNextTo = false
                    var isNextToInloop = false
                    var belongsTo = 0
                    
                    if(firstTimeAppend){
                        if(amountOfPixelInTheRanges[k] > areas[i].pointsInArea.count/4){
                            areaIDGroups.append([k])
                            firstTimeAppend = false
                        }
                    }
                    else{
                        if(amountOfPixelInTheRanges[k] > areas[i].pointsInArea.count/4){
                            for n in 0...areaIDGroups.count-1{
                                
                                for m in 0...areaIDGroups[n].count-1{
                                    isNextToInloop = rangeDataCollector[k].redRange-rangeDataCollector[areaIDGroups[n][m]].redRange <= 1
                                    isNextToInloop = isNextToInloop && rangeDataCollector[k].redRange-rangeDataCollector[areaIDGroups[n][m]].redRange >= -1
                                    isNextToInloop = isNextToInloop && rangeDataCollector[k].greenRange-rangeDataCollector[areaIDGroups[n][m]].greenRange <= 1
                                    isNextToInloop = isNextToInloop && rangeDataCollector[k].greenRange-rangeDataCollector[areaIDGroups[n][m]].greenRange >= -1
                                    isNextToInloop = isNextToInloop && rangeDataCollector[k].blueRange-rangeDataCollector[areaIDGroups[n][m]].blueRange <= 1
                                    isNextToInloop = isNextToInloop && rangeDataCollector[k].blueRange-rangeDataCollector[areaIDGroups[n][m]].blueRange >= -1
                                    
                                    if(isNextToInloop){
                                        isNextTo = true
                                        belongsTo = n
                                    }
                                }
                            }
                            if(isNextTo){
                                areaIDGroups[belongsTo].append(k)
                            }
                            else{
                                areaIDGroups.append([k])
                            }
                        }
                        
                    }
                }
                
                for k in 0...areaIDGroups.count-1{
                    finalAreas.append(saperatedAreas[areaIDGroups[k][0]])
                    if(areaIDGroups[k].count > 1){
                        for n in 1...areaIDGroups[k].count-1{
                            for m in 0...saperatedAreas[areaIDGroups[k][n]].pointsInArea.count-1{
                                finalAreas[k].pointsInArea.append(saperatedAreas[areaIDGroups[k][0]].pointsInArea[m])
                            }
                        }
                    }
                    
                    
                }
                
                for k in 0...amountOfPixelInTheRanges.count-1{
                    var isSame = false
                    for n in 0...areaIDGroups.count-1{
                        for m in 0...areaIDGroups[n].count-1{
                            isSame = isSame || areaIDGroups[n][m] == k
                        }
                    }
                    if(!isSame){
                        for n in 0...saperatedAreas[k].pointsInArea.count-1{
                            let newLinkedAreaID = detectNearestLargestArea(point: saperatedAreas[k].pointsInArea[n], areaInFunc: finalAreas)
                            finalAreas[newLinkedAreaID].pointsInArea.append(saperatedAreas[k].pointsInArea[n])
                        }
                    }
                }
                //saperate range, haven't write yet
                for k in 0...finalAreas.count-1{
                    if(k >= 1){
                        self.areas.append(finalAreas[k])
                    }
                }
                self.areas[i] = finalAreas[0]
            }
            
        }
    
        //delete small areas and transform to the large
        
        for i in 0...self.areas.count-1{
           
            if(self.areas[i].pointsInArea.count <= 5){
                for k in 0...self.areas[i].pointsInArea.count-1{
                    
                    let currentAreaID = detectNearestLargestArea(areaID: i, pointID: k, areaInFunc: self.areas)
                    
                    self.areas[currentAreaID].pointsInArea.append(self.areas[i].pointsInArea[k])
                    
                    self.areas[currentAreaID].colorDataForPoints.append(self.areas[currentAreaID].mean)
                    
                }
            }
        }
        
        for i in 0...self.areas.count-1{
            for k in 0...self.areas[i].pointsInArea.count-1{
                self.areaIDMap[self.areas[i].pointsInArea[k].x][self.areas[i].pointsInArea[k].y] = i
            }
        }
        
        
       
    }
    
    func detectNearestLargestArea(point: Point, areaInFunc: [UnitArea])->Int{
        var continueLooping = true
        var loop = 1
        var largestAreaNum = 0
        var largestAreaID = 0
        while(continueLooping){
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: point.x+loop,
                    y: point.y+i))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID){
                    largestAreaID = currentID
                    largestAreaNum = self.areas[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: point.x-loop,
                    y: point.y+i))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID){
                    largestAreaID = currentID
                    largestAreaNum = self.areas[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: point.x+i,
                    y: point.y+loop))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID){
                    largestAreaID = currentID
                    largestAreaNum = areaInFunc[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: point.x+i,
                    y: point.y-loop))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID){
                    largestAreaID = currentID
                    largestAreaNum = areaInFunc[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            loop += 1
        }
        return largestAreaID
    }
    
    func detectNearestLargestArea(areaID: Int, pointID: Int, areaInFunc: [UnitArea])->Int{
        var continueLooping = true
        var loop = 1
        var largestAreaNum = 0
        var largestAreaID = areaID
        while(continueLooping){
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: areaInFunc[areaID].pointsInArea[pointID].x+loop,
                    y: areaInFunc[areaID].pointsInArea[pointID].y+i))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID && currentID != areaID){
                    largestAreaID = currentID
                    largestAreaNum = self.areas[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: areaInFunc[areaID].pointsInArea[pointID].x-loop,
                    y: areaInFunc[areaID].pointsInArea[pointID].y+i))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID && currentID != areaID){
                    largestAreaID = currentID
                    largestAreaNum = self.areas[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: areaInFunc[areaID].pointsInArea[pointID].x+i,
                    y: areaInFunc[areaID].pointsInArea[pointID].y+loop))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID && currentID != areaID){
                    largestAreaID = currentID
                    largestAreaNum = areaInFunc[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            for i in -loop...loop{
                let currentID = findPointBelong(point: Point(
                    x: areaInFunc[areaID].pointsInArea[pointID].x+i,
                    y: areaInFunc[areaID].pointsInArea[pointID].y-loop))
                if(areaInFunc[currentID].pointsInArea.count > largestAreaID && currentID != areaID){
                    largestAreaID = currentID
                    largestAreaNum = areaInFunc[currentID].pointsInArea.count
                    continueLooping = false
                }
            }
            loop += 1
        }
        return largestAreaID
    }
    
    func findPointBelong(point: Point)->Int{
        var returnNum = 0
        for i in 0...self.areas.count-1{
            for k in 0...self.areas[i].pointsInArea.count-1{
                if(self.areas[i].pointsInArea[k].x == point.x && self.areas[i].pointsInArea[k].y == point.y){
                    returnNum = i
                    return returnNum
                }
            }
        }
        return returnNum
    }
    
    func mergePixel(image: UIImage, coordinate: Point, size: Size)->DataRGB{
        let imageView = UIImageView(image: image)
        //test out the extension above on the point (0,0) - returns r 0.541 g 0.78 b 0.227 a 1.0
        var pointColor = imageView.layer.colorOfPoint(point: CGPoint(x: 0, y: 0))
        
        
        
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContext((image.size))
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        context?.draw((image.cgImage)!, in: imageRect)
        
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
}
