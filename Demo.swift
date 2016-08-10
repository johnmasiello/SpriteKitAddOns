/**
 Classes Demo, DemoScene
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

class Demo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = view as? SKView {
            
            let scene = DemoScene(size: skView.frame.size)
            skView.presentScene(scene)
        }
        else {
            print("The view controller's view must have its identity set to SKView in the Interface Builder")
        }
    }
}

/**
 Classes Demo, DemoScene
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
class DemoScene: SKScene {
    
    var toast: SpriteKitToast?
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.greenColor()
        scaleMode = .ResizeFill
        anchorPoint = CGPointZero
        
        
        // Demo SpriteKitRect
        
        // Draw a label node in the center of the scene. It would be handy if the center were referenced from frame's origin.
        // The view's (or node's) frame stores in a CGRect, which defines origin as top or bottom left corner.
        
        let labelFrame = SpriteKitRect(cgRect: self.frame)
        let label = SKLabelNode(text: "Demo SpriteKit Rectangle")
        label.fontSize = 35.0
        label.fontColor = SKColor.blackColor()
        label.position = labelFrame.origin // No need to clutter code with CGRect properties
        label.name = "center label"
        addChild(label)
        
        
        // Demo SpriteKitToast
        
        toast = SpriteKitToast.makeToast(self, message: "Demo SpriteKitToast", 5.0).animate()
    }
    
    override func didChangeSize(oldSize: CGSize) {
        if let label = childNodeWithName("center label") {
            
            let labelFrame = SpriteKitRect(cgRect: self.frame)
            label.position = labelFrame.origin
        }
        
        // Reposition the toast -on or offscreen
        if let toast = self.toast {
            toast.updateFrame(self)
        }
    }
}