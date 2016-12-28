# PRGBubblesView

A UIView subclass that supports showing and selecting / deselecting items in bubble form with animation.

![PRGBubblesView](https://github.com/ispiropoulos/PRGBubblesView/blob/master/PRGBubblesView.gif?raw=true)

## Installation

### Manually:
Copy PRGBubblesView.swift and BendableView.swift to your project.

## Usage

### Storyboard:
1. Add a UIView and change it's class to PRGBubblesView. You can use autolayout constraints.
2. Create an IBOutlet and set the "elements" property of the BubblesView:
```swift
bubblesView.elements = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
```
3. You 're set! Just build and run the project!

### Programmatically:
```swift
let bubbleViewFrame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
let bubblesView = PRGBubblesView(frame: bubbleViewFrame, elements: ["Andres","Noel","Lewis","Judson","Edgardo","Jarred","Myles","Darren","Erasmo","Rhea","Monica","Jo","Dara","Selma","Garnet","Verena","My","Vera","Josefa"])
self.view.addSubview(bubblesView)
```
or
```swift
let bubblesView = PRGBubblesView(frame: bubbleViewFrame, elements: ["Andres","Noel","Lewis","Judson","Edgardo","Jarred","Myles","Darren","Erasmo","Rhea","Monica","Jo","Dara","Selma","Garnet","Verena","My","Vera","Josefa"], maxElementsPerRow: 5, bubbleTextFont: UIFont.systemFont(ofSize: 10), bubbleBGColor: UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.0)
            , bubbleStrokeColor: .clear, bubbleTextColor: .white, dividerColor: UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.0))
self.view.addSubview(bubblesView)
```

### Properties
```swift
open var elements: Array<String> // The total elements you want bubblesView to show
open var selectedElements: Array<String> // The elements you have selected
open var remainingElements: Array<String> // The remaining elements
open var allowsMultipleChoise: Bool // Wether the user can select multiple items or not. Default set to true

open var bubbleTextFont: UIFont // The font of the bubble text
open var bubbleTextColor: UIColor // The text color of unselected bubbles
open var selectedBubbleTextColor: UIColor // The text color of selected bubbles
open var bubbleBGColor: UIColor // The background color of unselected bubbles
open var selectedBubbleBGColor: UIColor // The background color of selected bubbles
open var bubbleStrokeColor: UIColor // The stroke color of unselected bubbles
open var selectedBubbleStrokeColor: UIColor // The stroke color of selected bubbles

open var dividerColor: UIColor // The color of the horizontal divider
```

## Author
John Spiropoulos

## Credits

Arkadiusz Holko for the initial BendableView code.

## License

PRGBubblesView is available under the MIT license. See the LICENSE file for more info.
