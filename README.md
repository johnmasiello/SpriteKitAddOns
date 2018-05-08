# SpriteKitAddOns
### Custom classes that work with SpriteKit Framework
- SpriteKitRect
- SpriteKitToast

## SpriteKitRect
Conveniently provides a more intuitive definition of _origin_:

     - The point (x, y) such that [x is the midpoint between left and right bounds], 
       [y is the midpoint between top and bottom bounds]; ie, the center
         
Constructors

    init(origin: CGPoint, size: CGSize) {
        self.origin = origin
        self.size = size
    }
    
    init(cgRect: CGRect) {
        // Adapt SpriteKitRect to Core Graphics Rectangle
        self.origin = CGPointMake(cgRect.midX, cgRect.midY)
        self.size = cgRect.size
    }         
         

## SpriteKitToast
A nuanced analog to _Toast_ in Android

- Will not animate the node until its scene is presented in the SKView
    - ie. make sure it is onscreen
    - call instance method _animate()_
- Effects
    - Animates a toast within _parent_node_ with text _message_ for a period _duration_

_Method Signatures_

    static func makeToast(parent_node: SKNode, message: String, _ duration: NSTimeInterval?) -> SpriteKitToast
And

    func animate() -> SpriteKitToast
    
## Demo

Draw a label node in the center of the scene.
The view's (or node's) frame stores in a CGRect, which uses an origin of bottom left corner
So it would be handy if instead of using the frame's origin, we reference the frame's center;
Enter SpriteKitRect:
    
    let mySpriteKitRect = SpriteKitRect(cgRect: self.frame)
    let label = SKLabelNode(text: "Demo SpriteKit Rectangle")
    label.fontSize = 35.0
    label.fontColor = SKColor.blackColor()
    label.position = mySpriteKitRect.origin // No need to clutter code with CGRect properties
    label.name = "center label"
    addChild(label)
    
Make a toast, as in a game using SpriteKit...
    
    toast = SpriteKitToast.makeToast(self, message: "Demo SpriteKitToast", 5.0).animate()
