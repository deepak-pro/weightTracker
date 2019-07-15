//
//  GameScene.swift
//  weightTracker
//
//  Created by Deepak on 15/07/19.
//  Copyright © 2019 Deepak. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        addEmmiter()
    }
    
    func addEmmiter(){
        let emitter = SKEmitterNode(fileNamed: "MagicEmmiter")!
        emitter.position = CGPoint(x: size.width / 2, y: size.width / 2)
        addChild(emitter)
    }
    
}
