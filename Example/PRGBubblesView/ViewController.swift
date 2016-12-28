//
//  ViewController.swift
//  PRGBubblesView
//
//  Created by John Spiropoulos on 27/10/2016.
//  Copyright © 2016 Programize. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PRGBubblesViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let bubbleViewFrame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
        let bubbleView = PRGBubblesView(frame: bubbleViewFrame, elements: ["Andres","Noel","Lewis","Judson","Edgardo","Jarred","Myles","Darren","Erasmo","Rhea","Monica","Jo","Dara","Selma","Garnet","Verena","My","Vera","Josefa"])
        
        view.backgroundColor = UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.0)
        bubbleView.delegate = self
        bubbleView.bubbleStrokeColor = .clear
        bubbleView.bubbleTextColor = .white
        bubbleView.bubbleBGColor = UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.0)
        bubbleView.backgroundColor = .clear
        bubbleView.dividerColor = UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.0)
        
        bubbleView.selectedBubbleBGColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
       
        
        self.view.addSubview(bubbleView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func bubblesView(bubblesView: PRGBubblesView, didSelectBubble bubble: BendableView, withText text: String) {
        print("You just selected \(text)")
        
    }
    
    func bubblesView(bubblesView: PRGBubblesView, didDeSelectBubble bubble: BendableView, withText text: String) {
        print("You just deselected \(text)")

    }


}

