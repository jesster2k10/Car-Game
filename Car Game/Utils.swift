//
//  Utils.swift
//  Car-Game
//
//  Created by Jesse on 06/11/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import Foundation
import SpriteKit
import QuartzCore
import UIKit

//Extensions
extension Int {
    var degreesToRadians: Double { return Double(self) * M_PI / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / M_PI }
    
    public static func random (_ lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

extension Float {
    public static func random(_ lower: Float, upper: Float) -> Float {
        let r = Float(arc4random()) / Float(UInt32.max)
        return (r * (upper - lower)) + lower
    }
}

func randomBool() -> Bool {
    return arc4random_uniform(2) == 0 ? true: false
}

extension CGPath {
    func points() -> [CGPoint]
    {
        var bezierPoints = [CGPoint]()
        self.forEach({ (element: CGPathElement) in
            let numberOfPoints: Int = {
                switch element.type {
                case .moveToPoint, .addLineToPoint: // contains 1 point
                    return 1
                case .addQuadCurveToPoint: // contains 2 points
                    return 2
                case .addCurveToPoint: // contains 3 points
                    return 3
                case .closeSubpath:
                    return 0
                }
            }()
            for index in 0..<numberOfPoints {
                let point = element.points[index]
                bezierPoints.append(point)
            }
        })
        return bezierPoints
    }
    
    func forEach(_ body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(_ info: UnsafeMutableRawPointer, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback as! CGPathApplierFunction)
    }
}

//Functions
func getRandomColor() -> SKColor{
    
    let randomRed:CGFloat = CGFloat(drand48())
    let randomGreen:CGFloat = CGFloat(drand48())
    let randomBlue:CGFloat = CGFloat(drand48())
    
    return SKColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    
}

//Tiles

/* To del
func tiledFillTexture(imageTexture: SKTexture, frameSize: CGSize ,tileSize: CGSize) -> SKTexture {
    let targetSize = CGSize(width: frameSize.width, height: frameSize.height)
    
    UIGraphicsBeginImageContext(targetSize)
    
    UIGraphicsGetCurrentContext()?.draw(imageTexture.cgImage(), in: CGRect(origin: CGPoint.zero, size: tileSize), byTiling: true)
    
    let tiledTexture = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return SKTexture(image: tiledTexture!)
}
*/

func getTilePosition(row r:Int, column c:Int, tileSize: CGSize) -> CGPoint
{
    let x = 0 + (c * (Int(tileSize.width)))
    let y = 0 + (r * (Int(tileSize.height)))
    return CGPoint(x: x, y: y)
}

func generateTileSprite(texture: SKTexture ,frame: CGRect) -> SKSpriteNode {
    let rx = Int(frame.width / texture.size().width + 1)
    let ry = Int(frame.height / texture.size().height + 1)
    
    let tempTileSprite = SKSpriteNode()
    
    for r in 0...ry {
        for c in 0...rx {
            let tile = SKSpriteNode(texture: texture)
            tile.size = CGSize(width: texture.size().width, height: texture.size().height)
            tile.position = getTilePosition(row: r, column: c, tileSize: texture.size())
            tempTileSprite.addChild(tile)
        }
    }
    return tempTileSprite
}

