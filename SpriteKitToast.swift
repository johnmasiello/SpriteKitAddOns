/**
Copyright 2016 John Masiello
 
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

import UIKit
import SpriteKit

class SpriteKitToast: SKSpriteNode {
    
    // MARK: Properties
    static let DEFAULT_BACKGROUND_COLOR = SKColor(white: 0.20, alpha: 1.0)
    static let DEFAULT_FONT_COLOR = SKColor(white: 0.90, alpha: 1.0)
    static let DEFAULT_FONT_SIZE: CGFloat = 15.0
    static let DEFAULT_FONT_NAME = "HelveticaNeue-CondensedBold" // "AppleColorEmoji"
    static let TYPICAL_PLACEMENT = CGPointMake(0.50, 0.15)
    static let ASPECT_SMALL: CGFloat = 0.25
    static let ASPECT_MEDIUM: CGFloat = 0.50
    static let ASPECT_LARGE: CGFloat = 0.75
    static let HEIGHT_SCALE: CGFloat = 0.15
    static let DURATION: NSTimeInterval = 0.60
    static let BASIC_TOAST_ACTION = "I toast"
    
    var fontNode: SKLabelNode
    var placement = SpriteKitToast.TYPICAL_PLACEMENT
    var sizeAsFraction = CGSizeMake(SpriteKitToast.ASPECT_MEDIUM, sqrt(SpriteKitToast.ASPECT_MEDIUM))
    var forDuration: NSTimeInterval?
    var accumulatedFrame: CGRect?
    var oldParent: SKNode?
    
    // MARK: Methods
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        let fontNode = SKLabelNode(fontNamed: SpriteKitToast.DEFAULT_FONT_NAME)
        fontNode.fontColor = SpriteKitToast.DEFAULT_FONT_COLOR
        fontNode.fontSize = SpriteKitToast.DEFAULT_FONT_SIZE
        fontNode.verticalAlignmentMode = .Center
        fontNode.zPosition = 1.0
        self.fontNode = fontNode
        
        super.init(texture: texture, color: SpriteKitToast.DEFAULT_BACKGROUND_COLOR, size: CGSizeZero)
        self.addChild(fontNode)
        name = "Android Toast"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    - precondition:
    Set (placement or sizeAsFraction) and parent != nil
    */
    func updateFrame(parents_anchorPoint: CGPoint, parents_size: CGSize) {
        
        let width = parents_size.width > 0 ? parents_size.width : calculate_AccumulatedFrame().width
        let height = parents_size.height > 0 ? parents_size.height : (accumulatedFrame?.height ?? calculate_AccumulatedFrame().height)
        
        position = CGPointMake(width * (placement.x - parents_anchorPoint.x), height * (placement.y - parents_anchorPoint.y))
        
        size = CGSizeMake(width * sizeAsFraction.width, height * sizeAsFraction.height * SpriteKitToast.HEIGHT_SCALE)
    }
    
    private func calculate_AccumulatedFrame() -> CGRect {
        accumulatedFrame = parent!.calculateAccumulatedFrame(); return accumulatedFrame!
    }
    
    /**
    Sets size and position to place within node
    - precondition:
     Node has node tree containing self
    - Call this to reposition the toast on SKScene didChangeSize
    */
    func updateFrame(node: SKNode) {
        
        if let thisNode = node as? SKScene {
            updateFrame(thisNode.anchorPoint, parents_size: thisNode.size)
        }
        else if let thisNode = node as? SKSpriteNode {
            updateFrame(thisNode.anchorPoint, parents_size: thisNode.size)
        }
        else {
            updateFrame(CGPoint(x: 0.5, y: 0.5), parents_size: node.frame.size)
        }
    }
    
    /**
    Ends the toast by removing from its parent node
    */
    func cancel() {
        if let parent = self.parent {
            oldParent = parent
        }
        removeFromParent()
    }
    
    /**
    - Will not animate the node until its scene is presented in the SKView, ie. make sure it is onscreen.
    - postcondition:
     Animates a toast with message over node for duration
    */
    static func makeToast(parent_node: SKNode, _ duration: NSTimeInterval?) -> SpriteKitToast {
        
        let spriteToast = SpriteKitToast(texture: nil, color: SKColor.clearColor(), size: CGSizeZero)
        spriteToast.forDuration = duration ?? SpriteKitToast.DURATION
        spriteToast.zPosition = parent_node.zPosition + 1000.0
        
        parent_node.addChild(spriteToast)
        spriteToast.updateFrame(parent_node)
        
        return spriteToast
    }
    
    /**
     - Will not animate the node until its scene is presented in the SKView, ie. make sure it is onscreen.
     - postcondition:
     Animates a toast with message over node for duration
     */
    static func makeToast(parent_node: SKNode, message: String, _ duration: NSTimeInterval?) -> SpriteKitToast {
        
        let spriteToast = SpriteKitToast(texture: nil, color: SKColor.clearColor(), size: CGSizeZero)
        spriteToast.forDuration = duration ?? SpriteKitToast.DURATION
        spriteToast.zPosition = parent_node.zPosition + 1000.0
        
        parent_node.addChild(spriteToast)
        spriteToast.updateFrame(parent_node)
        spriteToast.fontNode.text = message
        
        return spriteToast
    }
    
    static func animate(toast: SpriteKitToast, message: String) -> SpriteKitToast {
        toast.fontNode.text = message
        
        let duration = toast.forDuration ?? SpriteKitToast.DURATION
        
        toast.removeActionForKey(SpriteKitToast.BASIC_TOAST_ACTION)
        
        if toast.parent == nil {
            if let itsParent = toast.oldParent {
                itsParent.addChild(toast)
                
            }
            else {
                return toast
            }
        }
        
        // Create the animation
        let fadeIn = SKAction.fadeInWithDuration(0.20)
        let display = SKAction.waitForDuration(duration)
        let fadeOut = SKAction.fadeOutWithDuration(0.35)
        let finish = SKAction.runBlock({toast.cancel()})
        
        toast.runAction(SKAction.sequence([fadeIn, display, fadeOut, finish]), withKey: SpriteKitToast.BASIC_TOAST_ACTION)
        return toast
    }
    
    func animate() -> SpriteKitToast {
        if let message = self.fontNode.text {
            SpriteKitToast.animate(self, message: message)
        }
        else {
            print("no message to display for toast -not showing")
        }
        return self;
    }
}
