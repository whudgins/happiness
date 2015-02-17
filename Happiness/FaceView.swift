//
//  FaceView.swift
//  Happiness
//
//  Created by Will Hudgins on 2/9/15.
//  Copyright (c) 2015 Will Hudgins. All rights reserved.
//

import UIKit

// required to be implemented by a class. this allows you to make references weak
protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) -> Double?
}

class FaceView: UIView {

    // closure + property observer causes redraw when this is set. listener
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    
    // weak keeps controller (as the data source) from permanently staying in memory.
    // very important in this case because the two depend on each other. this would create
    // a memory loop and keep both in memory forever.
    weak var dataSource: FaceViewDataSource?
    
    var faceCenter: CGPoint {
    // don't need get if only return value
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(
            arcCenter: faceCenter,
            radius: faceRadius,
            startAngle: 0,
            endAngle: CGFloat(2*M_PI),
            clockwise: true
        )
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        // COOL TRICK: if left != nil, use it, otherwise use right
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        
    }
    

}
