//
//  GameScene.swift
//  Car-Game
//
//  Created by Jesse on 06/11/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Animations
    var animations = AnimationClass()
    
    //Variables
    var gameViewControllerBridge: GameViewController!
    var planetRadius = Float()
    
    //Beizer Path
    var beizerPath = UIBezierPath()
    
    //Textures
    var carTexture: SKTexture!
    var wheel1Texture: SKTexture!
    var wheel2Texture: SKTexture!
    var planetTexture: SKTexture!
    var textureImage: SKTexture!
    
    //Nodes
    var sceneNode = SKNode()
    var carNode = SKNode()
    
    //Sprites
    var map = SKSpriteNode()
    var car = SKSpriteNode()
    var wheel1 = SKSpriteNode()
    var wheel2 = SKSpriteNode()
    var suspension1 = SKSpriteNode()
    var suspension2 = SKSpriteNode()
    var planetSprite = SKSpriteNode()
    
    //Emitters
    var wheelDirtEmitter = SKEmitterNode()
    
    //Planet Shapes
    var planetPath = SKShapeNode()
    
    //Bit Masks
    var planetGroup : UInt32 = 0x1 << 1
    var carGroup : UInt32 = 0x1 << 2
    
    //Camera
    var cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) //Earth gravity (0, -9.8)
        self.physicsWorld.speed = 0.7
        self.physicsWorld.contactDelegate = self
        self.camera = cam
        
        self.addChild(carNode)
        self.addChild(sceneNode)
        
        gameViewControllerBridge.scene?.backgroundColor = SKColor.black
        
        createGame()
    }
    
    func createGame() {
        cam.setScale(1)
        
        loadMap()
        createCar()
        addJoint()
        
    }
    
    func loadMap() {
        //Generate random beizer path
        beizerPath.move(to: CGPoint(x: 0,y: 0))
        
        planetRadius = Float.random(2000, upper: 5000)
        var theta : Float = 9.0
        
        let ox = planetRadius * cos((Float(M_PI)) / 180)
        let oy = planetRadius * sin((Float(M_PI)) / 180)
        
        beizerPath.move(to: CGPoint(x: CGFloat(ox),y: CGFloat(oy)))
        
        for _ in 0...38 {
            var newRadius = Float.random(planetRadius, upper: planetRadius + planetRadius / 4)

            let x2 = newRadius * cos((theta * Float(M_PI)) / 180)
            let y2 = newRadius * sin((theta * Float(M_PI)) / 180)
            
            var x3 = newRadius * cos(((theta - 3.5) * Float(M_PI)) / 180)
            var y3 = newRadius * sin(((theta - 3.5) * Float(M_PI)) / 180)
            
            let x4 = newRadius * cos(((theta ) * Float(M_PI)) / 180)
            let y4 = newRadius * sin(((theta ) * Float(M_PI)) / 180)
            
            if theta == 360 {
                beizerPath.addQuadCurve(to: CGPoint(x: CGFloat(ox),y: CGFloat(oy)), controlPoint: CGPoint(x: CGFloat(x3),y: CGFloat(y3)))
            }
            else {
                if randomBool() {
                beizerPath.addQuadCurve(to: CGPoint(x: CGFloat(x2),y: CGFloat(y2)), controlPoint: CGPoint(x: CGFloat(x3),y: CGFloat(y3)))
                }
                else {
                beizerPath.addCurve(to: CGPoint(x: CGFloat(x2),y: CGFloat(y2)), controlPoint1: CGPoint(x: CGFloat(x3),y: CGFloat(y3)), controlPoint2: CGPoint(x: CGFloat(x4),y: CGFloat(y4)))
                }
            }
            
            let coinCount = Int.random(0, upper: 4)
            var newTheta : Float = 3.0
            for _ in 0...coinCount {
                newRadius += Float.random(50, upper: 70)
                
                x3 = newRadius * cos(((theta - newTheta) * Float(M_PI)) / 180)
                y3 = newRadius * sin(((theta - newTheta) * Float(M_PI)) / 180)
                
                newTheta += 3
            }
            theta += 9
        }
        
        beizerPath.close()
        
        //Create planet from beizer path
        
        planetPath = SKShapeNode(path: beizerPath.cgPath)
        planetPath.fillColor = getRandomColor()
        
        //planetPath.strokeColor = getRandomColor()
        //planetPath.lineWidth = CGFloat(Int.random(5, upper: 15))
        
        planetPath.lineWidth = 100
        planetPath.strokeTexture = SKTexture(imageNamed: "test")
        planetPath.strokeColor = SKColor.white

        
        let planet = SKCropNode()
        planet.maskNode = planetPath
        
        textureImage = SKTexture(imageNamed: "test(5)")
        planetSprite = generateTileSprite(texture: textureImage,frame: planetPath.frame)
        planetSprite.position = CGPoint(x: planetPath.frame.minX, y: planetPath.frame.minY)
        planetSprite.alpha = 0.5
        
        planet.addChild(planetSprite)
        
        planet.position = CGPoint(x: 0, y: 0)
        planet.physicsBody = SKPhysicsBody(edgeLoopFrom: beizerPath.cgPath)
        planet.physicsBody?.isDynamic = false
        planet.physicsBody?.categoryBitMask = planetGroup
        planet.zPosition = 10
        
        //Gravity & Friction
        planet.physicsBody?.friction = 1
        
        let fieldNode = SKFieldNode.radialGravityField()
        fieldNode.position = planet.position
        fieldNode.falloff = 0.9
        fieldNode.strength = 200
        
        //Planet atmosphere
        let atmo1 = SKShapeNode(circleOfRadius: CGFloat(planetRadius + planetRadius / 2))
        atmo1.position = CGPoint(x: 0,y: 0)
        atmo1.fillColor = SKColor.cyan
        atmo1.alpha = 0.9
        atmo1.zPosition = 1
        
        let atmo2 = SKShapeNode(circleOfRadius: CGFloat(planetRadius + planetRadius / 2))
        atmo2.fillColor = getRandomColor()
        atmo2.glowWidth = 30
        atmo2.alpha = 0.2
        
        let atmo3 = SKShapeNode(circleOfRadius: CGFloat(planetRadius + planetRadius / 3))
        atmo3.fillColor = getRandomColor()
        atmo3.glowWidth = 60
        atmo3.alpha = 0.3
        
        atmo1.addChild(atmo2)
        atmo2.addChild(atmo3)
        
        //sceneNode.addChild(atmo1)
        sceneNode.addChild(planet)
        sceneNode.addChild(fieldNode)
        
    }
    
    func createCar() {
        carTexture = SKTexture(imageNamed: "Body.png")
        car = SKSpriteNode(texture: carTexture)
        car.position = CGPoint(x: 600, y: planetPath.frame.maxY + car.frame.height + 50)
        car.physicsBody = SKPhysicsBody(texture: carTexture, size: car.frame.size)
        //car.physicsBody?.dynamic = true
        car.physicsBody?.mass = 0.5
        car.setScale(0.3)
        car.zPosition = 101
        
        car.physicsBody?.restitution = 0.5
        
        //Roch Shok
        suspension1 = SKSpriteNode(color: SKColor.red, size: CGSize(width: 5, height: 5))
        suspension1.position = CGPoint(x: car.position.x + car.size.width / 2 - 35, y: car.position.y - 50)
        suspension1.zPosition = 103
        suspension1.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        suspension1.physicsBody?.isDynamic = true
        suspension1.physicsBody?.mass = 0.1
        
        //suspension1.physicsBody?.restitution = 0.4
        //suspension1.physicsBody?.density = 0.1
        
        suspension2 = SKSpriteNode(color: SKColor.green, size: CGSize(width: 5, height: 5))
        suspension2.position = CGPoint(x: car.position.x - car.size.width / 2 + 25, y: car.position.y - 50)
        suspension2.zPosition = 103
        suspension2.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        suspension2.physicsBody?.isDynamic = true
        suspension2.physicsBody?.mass = 0.1
        
        //suspension2.physicsBody?.restitution = 0.4
        //suspension2.physicsBody?.density = 0.1
         
        wheel1Texture = SKTexture(imageNamed: "Wheel1")
        wheel2Texture = SKTexture(imageNamed: "Wheel2")
        wheel1 = SKSpriteNode(texture: wheel1Texture)
        wheel2 = SKSpriteNode(texture: wheel2Texture)
        wheel1.setScale(0.3)
        wheel2.setScale(0.3)
        wheel1.physicsBody = SKPhysicsBody(circleOfRadius: wheel1.size.width/2)
        wheel2.physicsBody = SKPhysicsBody(circleOfRadius: wheel2.size.width/2)
        wheel1.position = suspension1.position
        wheel2.position = suspension2.position
        wheel1.physicsBody?.allowsRotation = true
        wheel2.physicsBody?.allowsRotation = true
        wheel1.physicsBody?.isDynamic = true
        wheel2.physicsBody?.isDynamic = true
        wheel1.physicsBody?.friction = 1
        wheel2.physicsBody?.friction = 1

        wheel1.physicsBody?.mass = 1
        wheel2.physicsBody?.mass = 1
        
        wheel1.physicsBody?.restitution = 0.5
        wheel2.physicsBody?.restitution = 0.5
        
        wheel1.zPosition = 102
        wheel2.zPosition = 102
        
        car.physicsBody?.categoryBitMask = carGroup
        car.physicsBody?.contactTestBitMask = planetGroup
        car.physicsBody?.collisionBitMask = planetGroup
        
        suspension1.physicsBody?.collisionBitMask = 0
        suspension2.physicsBody?.collisionBitMask = 0
        
        wheel1.physicsBody?.categoryBitMask = carGroup
        wheel1.physicsBody?.contactTestBitMask = planetGroup
        wheel1.physicsBody?.collisionBitMask =   planetGroup

        wheel2.physicsBody?.categoryBitMask = carGroup
        wheel2.physicsBody?.contactTestBitMask =  planetGroup
        wheel2.physicsBody?.collisionBitMask = planetGroup
        
        carNode.addChild(car)
        carNode.addChild(suspension1)
        carNode.addChild(suspension2)
        carNode.addChild(wheel1)
        carNode.addChild(wheel2)
        
        addWheelDirtEmiter()
    }
    
    func addWheelDirtEmiter() {
        wheelDirtEmitter = SKEmitterNode(fileNamed: "WheelDirtEmitter.sks")!
        carNode.addChild(wheelDirtEmitter)
        
        //wheelDirtEmitter.hidden = true
    }
    
    func addJoint() {
        //Suspensions
        //Wheel1
        let wheel1JointSliding = SKPhysicsJointSliding.joint(withBodyA: car.physicsBody!, bodyB: suspension1.physicsBody!, anchor: suspension1.position, axis: CGVector(dx: 0,dy: 1))
        
        wheel1JointSliding.shouldEnableLimits = true
        wheel1JointSliding.lowerDistanceLimit = 5
        wheel1JointSliding.upperDistanceLimit = 20
        
        let wheel1JointSpring = SKPhysicsJointSpring.joint(withBodyA: car.physicsBody!, bodyB: wheel1.physicsBody!, anchorA: CGPoint(x: car.position.x - car.frame.size.width / 2, y: car.position.y), anchorB: suspension1.position)
        
        wheel1JointSpring.damping = 1
        wheel1JointSpring.frequency = 11

        
        let wheel1JointPin = SKPhysicsJointPin.joint(withBodyA: suspension1.physicsBody!, bodyB: wheel1.physicsBody!, anchor: wheel1.position)
        
        //Wheel2
        let wheel2JointSliding = SKPhysicsJointSliding.joint(withBodyA: car.physicsBody!, bodyB: suspension2.physicsBody!, anchor: suspension2.position, axis: CGVector(dx: 0, dy: 1))
        
        wheel2JointSliding.shouldEnableLimits = true
        wheel2JointSliding.lowerDistanceLimit = 5
        wheel2JointSliding.upperDistanceLimit = 20
        
        let wheel2JointSpring = SKPhysicsJointSpring.joint(withBodyA: car.physicsBody!, bodyB: wheel2.physicsBody!, anchorA: CGPoint(x: car.position.x + car.frame.size.width / 2, y: car.position.y), anchorB: suspension2.position)
        
        wheel2JointSpring.damping = 1
        wheel2JointSpring.frequency = 11
        
        let wheel2JointPin = SKPhysicsJointPin.joint(withBodyA: suspension2.physicsBody!, bodyB: wheel2.physicsBody!, anchor: wheel2.position)
        
        //Addjoints
        self.physicsWorld.add(wheel1JointSliding)
        self.physicsWorld.add(wheel1JointSpring)
        self.physicsWorld.add(wheel1JointPin)
        
        self.physicsWorld.add(wheel2JointSliding)
        self.physicsWorld.add(wheel2JointSpring)
        self.physicsWorld.add(wheel2JointPin)
        
    }
    
    override func didFinishUpdate() {
        let a = sqrt(pow(planetPath.position.x - car.position.x, 2) + pow(planetPath.position.y - car.position.y, 2))
        
        let angle = atan2(car.position.y, car.position.x)
        let theta : CGFloat = 0.0
        
        let cx = (Float(a) * cosf(Float(angle - theta)))
        let cy = (Float(a) * sinf(Float(angle - theta)))
        
        cam.position = CGPoint(x: CGFloat(cx), y: CGFloat(cy))
        cam.zRotation = angle - CGFloat(M_PI_2)
        
        //let camZoom = SKAction.scale(to: 1, duration: 0.5)
        //cam.runAction(camZoom)
        
        wheelDirtEmitter.position = CGPoint(x: wheel2.position.x,y: wheel2.position.y - wheel2.frame.height / 2)
        wheelDirtEmitter.zRotation = angle - CGFloat(M_PI_2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if gameViewControllerBridge.gasButtonState {
            wheel2.physicsBody?.angularVelocity = -35
            wheel1.physicsBody?.angularVelocity = -35
            
            wheelDirtEmitter.isHidden = false
        } else if gameViewControllerBridge.brakeButtonState {
            wheel2.physicsBody?.angularVelocity = 35
            wheel1.physicsBody?.angularVelocity = 35
        } else {
            wheelDirtEmitter.isHidden = true
        }
    }
    
    func reloadGame() {
        animations.shakeAndFlashAnimation(self.view!)
        
        beizerPath.removeAllPoints()
        
        carNode.removeAllChildren()
        sceneNode.removeAllChildren()
        
        Model.sharedInstance.score = 0
        
        createGame()
        
        //let camZoom = SKAction.scale(to: 50, duration: 0.1)
        //cam.runAction(camZoom)
    }
    
    func removeAll() {
        self.removeAllActions()
        self.removeAllActions()
        self.removeFromParent()
        self.view?.removeFromSuperview()
        
        gameViewControllerBridge = nil
    }
}
