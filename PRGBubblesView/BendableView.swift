//
//  BendableView.swift
//  AHKBendableView
//
//  Created by Arkadiusz Holko on 26-06-14.
//  Edited by John Spiropoulos on 20-09-16.

import UIKit
import CoreGraphics
import QuartzCore

private class BendableLayer: CALayer {

    override func add(_ anim: CAAnimation, forKey key: String?) {
        super.add(anim, forKey: key)

        // Checks if the animation changes the position and lets the view know about that.
        if let basicAnimation = anim as? CABasicAnimation {
            if basicAnimation.keyPath == NSStringFromSelector(#selector(getter: UIFieldBehavior.position)) {
                (self.delegate as! BendableLayerDelegate).positionAnimationWillStart(basicAnimation)
            }
        }
    }
}

private protocol BendableLayerDelegate {
    func positionAnimationWillStart(_ anim: CABasicAnimation)
}


/// UIView subclass that bends its edges (internally, a CAShapeLayer filled with `fillColor`) when its position changes.
///
/// You'll receive the best effect when you use `+animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:`
/// to animate the change of the position and set `damping` and `initialSpringVelocity` to different values
/// than in that animation call. I propose to use slightly lower values for these properties.
/// These properties can't be set automatically, because `CASpringAnimation` is private.
open class BendableView: UIView, BendableLayerDelegate {
    
    open var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            if label != nil {
                label.font = self.textFont
            }
        }
    }
    private var label: UILabel!
    private var initialOrigin: CGRect!
    open var selected = false
    private var layerView: UIView!
    
    open var text: String! {
        didSet {
            label.text = text.replacingOccurrences(of: " ", with: "\n")
            if text.contains(" ") {
                label.numberOfLines = 2
            }
           updateColor()
        }
    }
    
    open var textColor: UIColor = UIColor.white {
        didSet {
            updateColor()
        }
    }
    
    open var damping: CGFloat = 0.7
    open var initialSpringVelocity: CGFloat = 0.8
    open var strokeColor: UIColor = UIColor.black {
        didSet {
            updateColor()
        }
    }
    open var fillColor: UIColor = UIColor.lightGray {
    didSet {
        updateColor()
    }
    }

    fileprivate var displayLink: CADisplayLink?
    fileprivate var animationCount = 0
    // A hidden view that is used only for spring animation's simulation.
    // Its frame's origin matches the view's frame origin (except during animation). Of course it is in a different coordinate system,
    // but it doesn't matter to us. What we're interested in, is a position's difference between this subview's frame and the view's frame.
    // This difference (`bendableOffset`) is used for "bending" the edges of the view.
    fileprivate let dummyView = UIView()
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate var bendableOffset: UIOffset = UIOffset.zero {
    didSet {
        updatePath()
    }
    }

    // MARK: Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    fileprivate func commonInit() {
        layerView = UIView(frame: CGRect(x: 2, y: 2, width: frame.size.width-4, height: frame.size.height-4))
        addSubview(layerView)
        self.layerView.layer.insertSublayer(shapeLayer, at: 0)
        label = UILabel(frame:CGRect(x: frame.size.width-frame.size.width*0.95, y: frame.size.height-frame.size.height*0.95, width: frame.size.width*0.9, height: frame.size.height*0.9))
        label.textAlignment = .center
        label.font = self.textFont
        addSubview(label)

        updatePath()
        updateColor()
        addSubview(dummyView)
    }

    // MARK: UIView

    override open class var layerClass : AnyClass {
        return BendableLayer.self
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        updatePath()
        dummyView.frame.origin = frame.origin
    }

    // MARK: BendableLayerDelegate

    func positionAnimationWillStart(_ anim: CABasicAnimation) {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(self.tick(_:)))
            displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        }
        animationCount += 1

        let newPosition = layer.frame.origin

        // Effects of this animation are invisible, because dummyView is hidden.
        // dummyView frame's change animation matches the animation of the whole view, though it's in a different coordinate system.
        UIView.animate(withDuration: anim.duration,
            delay: anim.beginTime,
            usingSpringWithDamping: damping,
            initialSpringVelocity: initialSpringVelocity,
            options: [.beginFromCurrentState, .allowUserInteraction, .overrideInheritedOptions],
            animations: {
                self.dummyView.frame.origin = newPosition
            }, completion: { _ in
                self.animationCount -= 1
                if self.animationCount == 0 {
                    self.displayLink!.invalidate()
                    self.displayLink = nil
                }
            }
        )
    }

    // MARK: Internal

    func updatePath() {
        var bounds: CGRect
        if let presentationLayer = layerView.layer.presentation() {
            bounds = presentationLayer.bounds
        } else {
            bounds = self.layerView.bounds
        }

        let width = bounds.width
        let height = bounds.height
        
        let ovalPath = UIBezierPath()
        
        print("horizontal \(bendableOffset.horizontal)")
        print("vertical \(bendableOffset.vertical)")
        
        ovalPath.move(to: CGPoint(x: width, y: height/2))
        ovalPath.addCurve(to: CGPoint(x: width/2 - bendableOffset.horizontal, y: height - bendableOffset.vertical), controlPoint1: CGPoint(x: width, y: height*0.784), controlPoint2: CGPoint(x: width*0.7761 - bendableOffset.horizontal, y: height - bendableOffset.vertical))
        ovalPath.addCurve(to: CGPoint(x: 0, y: height*0.5051), controlPoint1: CGPoint(x: width*0.2239 - bendableOffset.horizontal, y: height - bendableOffset.vertical), controlPoint2: CGPoint(x: 0, y: height*0.784))
        ovalPath.addCurve(to: CGPoint(x: width/2, y: 0), controlPoint1: CGPoint(x: 0, y: height*0.2261), controlPoint2: CGPoint(x: width*0.2239, y: 0))
        ovalPath.addCurve(to: CGPoint(x: width, y: height*0.5051), controlPoint1: CGPoint(x: width*0.7761, y: 0), controlPoint2: CGPoint(x: width, y: height*0.2261))
        ovalPath.close()
       // ovalPath.applyTransform(CGAffineTransformMakeScale(0.9, 0.9))
        shapeLayer.path = ovalPath.cgPath

    }

    func updateColor() {
        if text != nil {
            shapeLayer.fillColor = fillColor.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            label.textColor = textColor
            
        } else {
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        }
    }

    func tick(_ displayLink: CADisplayLink) {
        if let dummyViewPresentationLayer = dummyView.layer.presentation() {
            if let presentationLayer = layer.presentation() {
                bendableOffset = UIOffset(horizontal: (dummyViewPresentationLayer.frame).minX - (presentationLayer.frame).minX,
                    vertical: (dummyViewPresentationLayer.frame).minY - (presentationLayer.frame).minY)
            }
        }
    }
}
