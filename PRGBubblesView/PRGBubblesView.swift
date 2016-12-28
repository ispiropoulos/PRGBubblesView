//
//  PRGBubblesView.swift
//  PRGBubblesView
//
//  Created by John Spiropoulos on 27/10/2016.
//  Copyright © 2016 Programize. All rights reserved.
//

import UIKit

protocol PRGBubblesViewDelegate:class {
    func bubblesView(bubblesView: PRGBubblesView, didSelectBubble bubble: BendableView, withText text:String)
     func bubblesView(bubblesView: PRGBubblesView, didDeSelectBubble bubble: BendableView, withText text:String)
}

class PRGBubblesView: UIView {
    
    weak var delegate: PRGBubblesViewDelegate?
    private var divider: Int! = 5
    
    open var elements: Array<String> = [] {
        didSet {
            self.elements = Array(Set(self.elements)).sorted()
            self.setNeedsDisplay()
        }
    }
    open var selectedElements: Array<String> = [] {
        
        didSet (newValue) {
            self.selectedElements = self.selectedElements.filter({ (element) -> Bool in
                elements.contains(element)
            }).sorted()
        }
    }
    
    open var remainingElements: Array<String> {
        get {
            return elements.filter({ (element) -> Bool in
                return !selectedElements.contains(element)
            })
        }
    }
    
    open var bubbleTextFont: UIFont! = UIFont.systemFont(ofSize: 10) {
        didSet {
            if self.unselectedBubbles != nil {
                for bubble in self.unselectedBubbles! {
                    bubble.textFont = self.bubbleTextFont
                }
            }
            
            if self.selectedBubbles != nil {
                for bubble in self.selectedBubbles! {
                    bubble.textFont = self.bubbleTextFont
                }
            }

        }
    }
    
    open var bubbleTextColor: UIColor! = UIColor.darkGray {
        didSet {
            if self.unselectedBubbles != nil {
                for bubble in self.unselectedBubbles! {
                    bubble.textColor = self.bubbleTextColor
                }
            }
        }
        
    }
    
    open var selectedBubbleTextColor: UIColor! {
        didSet {
            if self.selectedBubbles != nil {
                for bubble in self.selectedBubbles! {
                    bubble.textColor = self.selectedBubbleTextColor
                }
            }
        }
        
    }

    
    open var bubbleBGColor: UIColor! = UIColor.lightGray {
        didSet {
            if self.unselectedBubbles != nil {
                for bubble in self.unselectedBubbles! {
                    bubble.fillColor = self.bubbleBGColor
                }
            }
        }
    }

    open var selectedBubbleBGColor: UIColor! {
        didSet {
            if self.selectedBubbles != nil {
                for bubble in self.selectedBubbles! {
                    bubble.fillColor = self.selectedBubbleBGColor
                }
            }
        }
    }
    
    open var bubbleStrokeColor: UIColor! = UIColor.darkGray {
        didSet {
            if self.unselectedBubbles != nil {
            for bubble in self.unselectedBubbles! {
                bubble.strokeColor = self.bubbleStrokeColor
            }
            }
        }
    }
    
    open var selectedBubbleStrokeColor: UIColor! {
        didSet {
            if self.selectedBubbles != nil {
                for bubble in self.selectedBubbles! {
                    bubble.strokeColor = self.selectedBubbleStrokeColor
                }
            }
        }
    }

    
    open var dividerColor: UIColor! = UIColor.darkGray {
        didSet {
            if horizontalView != nil {
                horizontalView.backgroundColor = self.dividerColor
            }
        }
    }
    
    open var allowsMultipleChoise: Bool = true
    
    private var bubbleFrameX: CGFloat!
    private var bubbleFrameY: CGFloat!
    
    private var horizontalView: UIView!
    
    private var selectedBubbles: Array<BendableView>? {
        get {
            return (self.subviews.filter({ (subview) -> Bool in
                return subview.isKind(of: BendableView.self)
            }) as! Array<BendableView>).filter({ (view) -> Bool in
                return view.selected
            }).sorted(by: { (bubble1, bubble2) -> Bool in
                return bubble1.text < bubble2.text
            })
        }
        set {
            
        }
    }
    
    private var unselectedBubbles: Array<BendableView>? {
        get {
            var unselectedBubblesArray = (self.subviews.filter({ (subview) -> Bool in
                return subview.isKind(of: BendableView.self)
            }) as! Array<BendableView>).filter({ (view) -> Bool in
                return !view.selected
            })
            unselectedBubblesArray = unselectedBubblesArray.sorted { (bubble1, bubble2) -> Bool in
                bubble1.text < bubble2.text
            }
            
            // Put no preference bubble first
            for i in 0 ..< unselectedBubblesArray.count {
                if unselectedBubblesArray[i].text == "No Preference" {
                    let bubble = unselectedBubblesArray[i]
                    unselectedBubblesArray.remove(at: i)
                    unselectedBubblesArray.insert(bubble, at: 0)
                    break
                }
            }
            return unselectedBubblesArray.sorted(by: { (bubble1, bubble2) -> Bool in
                return bubble1.text < bubble2.text
            })
        }
        set {
            
        }
    }
    
    init(frame: CGRect, elements: Array<String>) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        self.elements = elements
        
    }
    
    init(frame: CGRect, elements: Array<String>, maxElementsPerRow: Int, bubbleTextFont: UIFont, bubbleBGColor: UIColor, bubbleStrokeColor: UIColor, bubbleTextColor: UIColor, dividerColor: UIColor) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        self.elements = elements.sorted()
        self.divider = maxElementsPerRow
        self.bubbleBGColor = bubbleBGColor
        self.bubbleTextColor = bubbleTextColor
        self.bubbleStrokeColor = bubbleStrokeColor
        self.bubbleTextFont = bubbleTextFont
        self.dividerColor = dividerColor
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initialInit(frame: CGRect) {
        for view in self.subviews {
            if view.isKind(of: BendableView.self) {
                view.removeFromSuperview()
            }
        }
        if horizontalView == nil {
        horizontalView = UIView(frame: CGRect(x: 0, y: self.bounds.width/CGFloat(divider), width: self.bounds.width, height: 1))
        horizontalView.backgroundColor = dividerColor
        
        self.addSubview(horizontalView)
        } else {
            horizontalView.frame = CGRect(x: 0, y: self.bounds.width/CGFloat(divider), width: self.bounds.width, height: 1)
        }
        placeBottomBubbles(elements)
       
    }
    
    
    override func layoutSubviews() {
        
         initialInit(frame: self.bounds)
    }
    
    func placeBottomBubbles(_ elements: Array<String>) {
        
        let bubbleWidth = self.bounds.width/CGFloat(divider)
        let bubbleHeight = bubbleWidth
        
        var z = 1
        var xMulti = 1
        
        for i in (0 ..< elements.count).reversed() {
            
            if z%2 == 0 {
                let bubbleFrameX = self.bounds.width - (bubbleWidth / 2) - (CGFloat(xMulti) * (bubbleWidth))
                let bubbleFrameY = self.bounds.height - (CGFloat(z) * bubbleHeight)
                let bubbleFrame = CGRect(x: bubbleFrameX, y: bubbleFrameY, width: bubbleWidth, height: bubbleHeight)
                let bubble = BendableView(frame: bubbleFrame)
                bubble.text = elements[i]
                bubble.fillColor = self.bubbleBGColor
                bubble.textFont = self.bubbleTextFont
                bubble.strokeColor = self.bubbleStrokeColor
                bubble.textColor = self.bubbleTextColor
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(bubbleTapped(_:)))
                bubble.tag = i
                bubble.isUserInteractionEnabled = true
                bubble.addGestureRecognizer(tapGR)
                self.addSubview(bubble)
                
                if xMulti == divider - 1 {
                    z += 1
                    xMulti = 1
                } else {
                    xMulti += 1
                }
                
                
            } else {
                let bubbleFrameX = self.bounds.width - (CGFloat(xMulti) * (bubbleWidth))
                let bubbleFrameY = self.bounds.height - (CGFloat(z) * bubbleHeight)
                let bubbleFrame = CGRect(x: bubbleFrameX, y: bubbleFrameY, width: bubbleWidth, height: bubbleHeight)
                let bubble = BendableView(frame: bubbleFrame)
                bubble.fillColor = self.bubbleBGColor
                bubble.textFont = self.bubbleTextFont
                bubble.strokeColor = self.bubbleStrokeColor
                bubble.textColor = self.bubbleTextColor
                
                
                bubble.text = elements[i]
                bubble.tag = i
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(bubbleTapped(_:)))
                bubble.isUserInteractionEnabled = true
                bubble.addGestureRecognizer(tapGR)
                self.addSubview(bubble)
                
                if xMulti == divider {
                    z += 1
                    xMulti = 1
                } else {
                    xMulti += 1
                }
                
            }
            
        }
        
    }
    
    
    func bubbleTapped(_ sender: UITapGestureRecognizer) {
        
        let bubble = sender.view! as! BendableView
        if bubble.selected {
            bubble.selected = false
            for i in 0 ..< selectedElements.count {
                if selectedElements[i] == bubble.text {
                    selectedElements.remove(at: i)
                    break
                }
                
            }
            bubble.textColor = bubbleTextColor
            bubble.strokeColor = bubbleStrokeColor
            bubble.fillColor = bubbleBGColor
            
            delegate?.bubblesView(bubblesView: self, didDeSelectBubble: bubble, withText: bubble.text)
            rearrangeTopBubbles(true)
            
        } else {
            if !allowsMultipleChoise {
                
                selectedElements.removeAll()
                for selectedBubble in selectedBubbles! {
                    selectedBubble.selected = false
                    selectedBubble.textColor = bubbleTextColor
                    selectedBubble.strokeColor = bubbleStrokeColor
                    selectedBubble.fillColor = bubbleBGColor
                    
                }
                
            }
            bubble.selected = true
            if selectedBubbleTextColor != nil {
            bubble.textColor = selectedBubbleTextColor
            }
            if selectedBubbleStrokeColor != nil {
            bubble.strokeColor = selectedBubbleStrokeColor
            }
            if selectedBubbleBGColor != nil {
            bubble.fillColor = selectedBubbleBGColor
            }

            let selectedElementsCount = selectedElements.count
            
            var yMulti: Double = 0
            
            let modulus = fmod(Double(selectedElementsCount), Double(divider))
            
            if modulus == 0 || (modulus >= 1 && modulus < Double(divider)) {
                yMulti = Double((selectedElementsCount/divider))
            } else if (Double(elements.count) - (Double(selectedElementsCount) + fmod(Double(selectedElementsCount), Double(divider))) < 1)  {
                yMulti = Double(selectedElementsCount/divider + 1)
            }
            
            var xMulti: Double = Double(selectedElementsCount)
            if selectedElementsCount < divider {
                xMulti = Double(selectedElementsCount)
            } else {
                xMulti = Double(selectedElementsCount).truncatingRemainder(dividingBy: Double(divider))
            }
            
            let bubbleFrameX = CGFloat(xMulti) * bubble.frame.width
            let bubbleFrameY = CGFloat(yMulti) * bubble.frame.height
            let bubbleFrame = CGRect(x: bubbleFrameX, y: bubbleFrameY, width: bubble.frame.width, height: bubble.frame.height)
            let destPoint: CGPoint =  CGPoint(x: bubbleFrame.origin.x, y: bubbleFrame.origin.y)
            
            
            bubble.damping = 0.8
            bubble.initialSpringVelocity = 0.8
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.9,
                           options: [.beginFromCurrentState, .allowUserInteraction],
                           animations: {
                            bubble.frame.origin = destPoint
            }, completion: {(_) in
                
                
                
            }
                
                
                
            )
            selectedElements.append(bubble.text)
            delegate?.bubblesView(bubblesView: self, didSelectBubble: bubble, withText: bubble.text)
            rearrangeTopBubbles(true)
            UIView.animate(withDuration: 0.3, animations: {
                self.horizontalView.frame.origin.y = (CGFloat(yMulti) + 1) * self.bounds.width / CGFloat(self.divider)
            })
            
        }
        
        rearrangeBottomBubbles(true)
        
    }
    
    
    
    func rearrangeBottomBubbles(_ withAnimation:Bool) {
        
        var z = 1
        var xMulti = 1
        
        for bubble in unselectedBubbles!.reversed() {
            
            if z%2 == 0 {
                let bubbleFrameX = self.bounds.width - (bubble.frame.width / 2) - (CGFloat(xMulti) * (bubble.frame.width))
                let bubbleFrameY = self.bounds.height - (CGFloat(z) * bubble.frame.height)
                
                if withAnimation {
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 0.9,
                                   options: [.beginFromCurrentState, .allowUserInteraction],
                                   animations: {
                                    bubble.frame.origin = CGPoint(x: bubbleFrameX, y: bubbleFrameY)
                    }, completion: nil
                    )
                } else {
                    bubble.frame.origin = CGPoint(x: bubbleFrameX, y: bubbleFrameY)
                }
                
                if xMulti == divider - 1 {
                    z += 1
                    xMulti = 1
                } else {
                    xMulti += 1
                }
                
                
            } else {
                let bubbleFrameX = self.bounds.width - (CGFloat(xMulti) * (bubble.frame.width))
                let bubbleFrameY = self.bounds.height - (CGFloat(z) * bubble.frame.height)
                if withAnimation {
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   usingSpringWithDamping: 0.9,
                                   initialSpringVelocity: 0.9,
                                   options: [.beginFromCurrentState, .allowUserInteraction],
                                   animations: {
                                    bubble.frame.origin = CGPoint(x: bubbleFrameX, y: bubbleFrameY)
                    }, completion: nil
                    )
                } else {
                    bubble.frame.origin = CGPoint(x: bubbleFrameX, y: bubbleFrameY)
                }
                
                if xMulti == divider {
                    z += 1
                    xMulti = 1
                } else {
                    xMulti += 1
                }
                
            }
            
        }
        
    }
    
    func rearrangeTopBubbles(_ withAnimation:Bool) {
        
        var xMulti: Double = 0
        var yMulti: Double = 0
        
        for i in 0 ..< self.selectedBubbles!.count {
            
            let bubble = selectedBubbles![i]
            
            
            let bubbleFrameX = CGFloat(xMulti) * bubble.frame.width
            let bubbleFrameY = CGFloat(yMulti) * bubble.frame.height
            let bubbleFrame = CGRect(x: bubbleFrameX, y: bubbleFrameY, width: bubble.frame.width, height: bubble.frame.height)
            let destPoint: CGPoint =  CGPoint(x: bubbleFrame.origin.x, y: bubbleFrame.origin.y)
            
            bubble.damping = 0.8
            bubble.initialSpringVelocity = 0.8
            if withAnimation {
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 0.9,
                               options: [.beginFromCurrentState, .allowUserInteraction],
                               animations: {
                                bubble.frame.origin = destPoint
                }, completion: nil
                )
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.horizontalView.frame.origin.y = (CGFloat(yMulti) + 1) * bubble.bounds.height
                })
            } else {
                bubble.frame.origin = destPoint
                self.horizontalView.frame.origin.y = (CGFloat(yMulti) + 1) * bubble.bounds.height
            }
            
            if xMulti == Double(divider-1) {
                xMulti = 0
                yMulti += 1
            } else {
                xMulti += 1
            }
        }
        
    }
    
    
    
}
