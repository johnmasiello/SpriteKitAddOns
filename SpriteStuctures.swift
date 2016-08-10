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

struct SpriteKitRect {
    /**
     - The point that is equidistant to all points on the rectangle; the center
     - Handy for setting the sprite's position, ie SKNode.position = self.origin
     */
    var origin: CGPoint
    var size: CGSize
    var lowerLeftCorner: CGPoint {
        get {
            return CGPointMake(origin.x - size.width / 2.0, origin.y - size.height / 2.0)
        }
    }
    var upperLeftCorner: CGPoint {
        get {
            return CGPointMake(origin.x - size.width / 2.0, origin.y + size.height / 2.0)
        }
    }
    var cgRect: CGRect {
        get {
            return CGRect(origin: lowerLeftCorner, size: size)
        }
    }
    var minX: CGFloat {
        get {
            return origin.x - size.width / 2.0
        }
    }
    var maxX: CGFloat {
        get {
            return origin.x + size.width / 2.0
        }
    }
    var minY: CGFloat {
        get {
            return origin.y - size.height / 2.0
        }
    }
    var maxY: CGFloat {
        get {
            return origin.y + size.height / 2.0
        }
    }
    
    init(origin: CGPoint, size: CGSize) {
        self.origin = origin
        self.size = size
    }
    
    init(cgRect: CGRect) {
        self.origin = CGPointMake(cgRect.midX, cgRect.midY)
        self.size = cgRect.size
    }
}