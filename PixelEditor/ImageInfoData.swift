//
//  self.swift
//  PixelEditor
//
//  Created by Zihao Arthur Wang [STUDENT] on 2017/5/17.
//  Copyright © 2017年 王子豪. All rights reserved.
//

import Foundation
import UIKit
class ImageInfoData{
    var largeLocalPieces = [[LargePiece]]()
    var areaMap = AreaMap()
    init(image: UIImage){
        let imageView = UIImageView(image: image)
        for x in 0...Int((image.size.width)/16)-1{
            
            var largePiecesInLine = [LargePiece]()
            for y in 0...Int((image.size.height)/16)-1{
                largePiecesInLine.append(LargePiece(image: image, coordinate: Point(x: x*16, y: y*16)))
                print(x, y)
            }
            self.largeLocalPieces.append(largePiecesInLine)
        }
        
        print("initialized")
        var isFirstTimeAddArea = true
        var isNotGoToLinkYet = true
        
        /*
        for i in 0...0{
            for k in 0...31{
                if(self.largeLocalPieces[0][0].colorPoints[31][k].redRange != self.largeLocalPieces[1][0].colorPoints[15][k].redRange){
                    print("kkk")
                }
            }
        }
        for i in 0...3{
            for k in 0...7{
                
                if(self.largeLocalPieces[1][0].smallPiece[1][i].colorPoints[7][k].redRange != self.largeLocalPieces[0][0].smallPiece[3][i].colorPoints[7][k].redRange){
                    print("bbb: \(i*8+k)")
                }
                if(self.largeLocalPieces[1][0].smallPiece[1][i].colorPoints[7][k].greenRange != self.largeLocalPieces[0][0].smallPiece[3][i].colorPoints[7][k].greenRange){
                    print("ggg: \(i*8+k)")
                }
                if(self.largeLocalPieces[1][0].smallPiece[1][i].colorPoints[7][k].blueRange != self.largeLocalPieces[0][0].smallPiece[3][i].colorPoints[7][k].blueRange){
                    print("rrr: \(i*8+k)")
                }
            }
        }*/
        
        var currentArea = 0
        for x in 0...Int((image.size.width)/16)-1{
            for y in 0...Int((image.size.height)/16-1){
                var finishLinked = false
                for i in 0...self.largeLocalPieces[x][y].areaMap.areas.count-1{
                    var linkedAreasID = [Int]()
                    var newLinkedAreasID = [Int]()
                    if(isNotGoToLinkYet){
                        if(isFirstTimeAddArea){
                            self.areaMap.areas[currentArea] = self.largeLocalPieces[x][y].areaMap.areas[i]
                            isFirstTimeAddArea = false
                        }
                        else{
                            self.areaMap.areas.append(self.largeLocalPieces[x][y].areaMap.areas[i])
                            currentArea += 1
                            
                        }
                        for arrIndex in 0...self.areaMap.areas[currentArea].pointsInArea.count-1{
                            self.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*16
                            self.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*16
                        }
                        
                        for k in 0...31{
                            if(self.largeLocalPieces[x][y].inputPixelsAreaID[0][k] == i){
                                self.largeLocalPieces[x][y].inputPixelsAreaID[0][k] = currentArea
                            }
                            if(self.largeLocalPieces[x][y].inputPixelsAreaID[1][k] == i){
                                self.largeLocalPieces[x][y].inputPixelsAreaID[1][k] = currentArea
                            }
                            if(self.largeLocalPieces[x][y].outputPixelsAreaID[0][k] == i){
                                self.largeLocalPieces[x][y].outputPixelsAreaID[0][k] = currentArea
                            }
                            if(self.largeLocalPieces[x][y].outputPixelsAreaID[1][k] == i){
                                self.largeLocalPieces[x][y].outputPixelsAreaID[1][k] = currentArea
                            }
                        }
                        
                        for k in 0...31{
                            if(self.largeLocalPieces[x][y].midInputPixelsAreaID[0][k] == i){
                                self.largeLocalPieces[x][y].midInputPixelsAreaID[0][k] = currentArea
                            }
                            if(self.largeLocalPieces[x][y].midInputPixelsAreaID[1][k] == i){
                                self.largeLocalPieces[x][y].midInputPixelsAreaID[1][k] = currentArea
                            }
                            if(self.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] == i){
                                self.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] = currentArea
                            }
                            if(self.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] == i){
                                self.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] = currentArea
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
                                fistTimeAddElementID = false
                                newAreaIDX.append(self.largeLocalPieces[x][y].midInputPixelsAreaID[0][index])
                            }
                            else{
                                var isSame = false
                                for k in 0...newAreaIDX.count-1{
                                    isSame = isSame || newAreaIDX[k] == self.largeLocalPieces[x][y].midInputPixelsAreaID[0][index]
                                }
                                if(!isSame){
                                    newAreaIDX.append(self.largeLocalPieces[x][y].midInputPixelsAreaID[0][index])
                                }
                            }
                        }
                        
                        fistTimeAddElementID = true
                        
                        for index in 0...31{
                            if(fistTimeAddElementID){
                                fistTimeAddElementID = false
                                newAreaIDY.append(self.largeLocalPieces[x][y].midInputPixelsAreaID[1][index])
                            }
                            else{
                                var isSame = false
                                for k in 0...newAreaIDY.count-1{
                                    isSame = isSame || newAreaIDY[k] == self.largeLocalPieces[x][y].midInputPixelsAreaID[1][index]
                                }
                                if(!isSame){
                                    newAreaIDY.append(self.largeLocalPieces[x][y].midInputPixelsAreaID[1][index])
                                }
                            }
                        }
                        
                        //initialize areasID,
                        
                        fistTimeAddElementID = true
                        if(x != 0){
                            for index in 0...31{
                                if(fistTimeAddElementID){
                                    fistTimeAddElementID = false
                                    areaIDX.append(self.largeLocalPieces[x-1][y].outputPixelsAreaID[0][index])
                                }
                                else{
                                    var isSame = false
                                    for k in 0...areaIDX.count-1{
                                        isSame = isSame || areaIDX[k] == self.largeLocalPieces[x-1][y].outputPixelsAreaID[0][index]
                                    }
                                    if(!isSame){
                                        areaIDX.append(self.largeLocalPieces[x-1][y].outputPixelsAreaID[0][index])
                                    }
                                }
                            }
                        }
                        
                        fistTimeAddElementID = true
                        
                        if(y != 0){
                            for index in 0...31{
                                if(fistTimeAddElementID){
                                    fistTimeAddElementID = false
                                    areaIDY.append(self.largeLocalPieces[x][y-1].outputPixelsAreaID[1][index])
                                }
                                else{
                                    var isSame = false
                                    for k in 0...areaIDY.count-1{
                                        isSame = isSame || areaIDY[k] == self.largeLocalPieces[x][y-1].outputPixelsAreaID[1][index]
                                    }
                                    if(!isSame){
                                        areaIDY.append(self.largeLocalPieces[x][y-1].outputPixelsAreaID[1][index])
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
                                var isNewSame = false
                                for n in 0...areaID.count-1{
                                    isSame = isSame || areaID[n] == areaIDY[m]
                                }
                                for n in 0...newAreaID.count-1{
                                    isNewSame = isNewSame || newAreaID[n] == newAreaIDY[m]
                                }
                                if(!isSame){
                                    areaID.append(areaIDY[m])
                                }
                                if(!isNewSame){
                                    newAreaID.append(newAreaIDY[m])
                                }
                            }
                            for m in 0...newAreaIDY.count-1{
                                var isSame = false
                                for n in 0...newAreaID.count-1{
                                    isSame = isSame || newAreaID[n] == newAreaIDY[m]
                                }
                                if(!isSame){
                                    areaID.append(newAreaIDY[m])
                                }
                            }
                        }
                        
                        //forming Areas
                        if(!(y==0 || x==0)){
                            
                            for index in 0...newAreaID.count-1{
                                for k in 0...self.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea.count-1{
                                    // "<=" need to be checked, because the direction are not sure
                                    if(self.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].x >= 16 && self.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].y >= 16){
                                        self.areaMap.areas[areaID[index]].pointsInArea.append(Point(
                                            x: self.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].x+x*16,
                                            y: self.largeLocalPieces[x][y].areaMap.areas[newAreaID[index]].pointsInArea[k].y+y*16))
                                    }
                                }
                            }
                            
                            newLinkedAreasID = newAreaID
                            linkedAreasID = areaID
                            
                            self.largeLocalPieces[x][y].midInputPixelsAreaID[0] = self.largeLocalPieces[x-1][y].midOutputPixelsAreaID[0]
                            self.largeLocalPieces[x][y].midInputPixelsAreaID[1] = self.largeLocalPieces[x][y-1].midOutputPixelsAreaID[1]
                        }
                        else if(y == 0){
                            for index in 0...newAreaIDX.count-1{
                                for k in 0...self.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea.count-1{
                                    if(self.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea[k].x >= 16){
                                        self.areaMap.areas[areaIDX[index]].pointsInArea.append(Point(
                                            x: self.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea[k].x+x*16,
                                            y: self.largeLocalPieces[x][y].areaMap.areas[newAreaIDX[index]].pointsInArea[k].y))
                                    }
                                }
                            }
                            newLinkedAreasID = newAreaIDX
                            linkedAreasID = areaIDX
                            self.largeLocalPieces[x][y].midInputPixelsAreaID[0] = self.largeLocalPieces[x-1][y].midOutputPixelsAreaID[0]
                        }
                        else if(x == 0){
                            for index in 0...newAreaIDY.count-1{
                                for k in 0...self.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea.count-1{
                                    if(self.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea[k].y >= 16){
                                        self.areaMap.areas[areaIDY[index]].pointsInArea.append(Point(
                                            x: self.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea[k].x,
                                            y: self.largeLocalPieces[x][y].areaMap.areas[newAreaIDY[index]].pointsInArea[k].y+y*16))
                                    }
                                }
                            }
                            newLinkedAreasID = newAreaIDY
                            linkedAreasID = areaIDY
                            self.largeLocalPieces[x][y].midInputPixelsAreaID[1] = self.largeLocalPieces[x][y-1].midOutputPixelsAreaID[1]
                        }
                        
                        //updating outPuts
                        for index in 0...newLinkedAreasID.count-1{
                            for k in 0...31{
                                if(self.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] == newLinkedAreasID[index]){
                                    self.largeLocalPieces[x][y].midOutputPixelsAreaID[0][k] = linkedAreasID[index]
                                }
                                if(self.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] == newLinkedAreasID[index]){
                                    self.largeLocalPieces[x][y].midOutputPixelsAreaID[1][k] = linkedAreasID[index]
                                }
                            }
                        }
                        
                        finishLinked = true
                    }
                    else{
                        //error, need to be fixed, debug then delete this line
                        var isSame = false
                        if(linkedAreasID.count >= 1){
                            for index in 0...linkedAreasID.count-1{
                                isSame = isSame || linkedAreasID[index] == i
                            }
                        }
                        
                        if(!isSame){
                            self.areaMap.areas.append(self.largeLocalPieces[x][y].areaMap.areas[i])
                            currentArea += 1
                            
                            for arrIndex in 0...self.areaMap.areas[currentArea].pointsInArea.count-1{
                                self.areaMap.areas[currentArea].pointsInArea[arrIndex].x += x*8
                                self.areaMap.areas[currentArea].pointsInArea[arrIndex].y += y*8
                            }
                            
                            for k in 0...31{
                                if(self.largeLocalPieces[x][y].inputPixelsAreaID[0][k] == i){
                                    self.largeLocalPieces[x][y].inputPixelsAreaID[0][k] = currentArea
                                }
                                if(self.largeLocalPieces[x][y].inputPixelsAreaID[1][k] == i){
                                    self.largeLocalPieces[x][y].inputPixelsAreaID[1][k] = currentArea
                                }
                                if(self.largeLocalPieces[x][y].outputPixelsAreaID[0][k] == i){
                                    self.largeLocalPieces[x][y].outputPixelsAreaID[0][k] = currentArea
                                }
                                if(self.largeLocalPieces[x][y].outputPixelsAreaID[1][k] == i){
                                    self.largeLocalPieces[x][y].outputPixelsAreaID[1][k] = currentArea
                                }
                            }
                        }
                    }
                }
                
                isNotGoToLinkYet = false
            }
        }
    }
}
