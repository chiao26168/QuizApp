//
//  DrawView.swift
//  exercise3
//
//  Created by Claire Lee on 11/9/22.
//



import UIKit

protocol DrawDelegate {
    func showAlert()
}
class DrawView: UIView, UIGestureRecognizerDelegate {
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    var item: Item!
    var moveRecognizer: UIPanGestureRecognizer!
    var desiredColor = UIColor.systemOrange
    var lineThickness: CGFloat = 10
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()

    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.hideMenu(from: self)
            }
        }
    }
    func start() {
        setNeedsDisplay()
        print("bagel")
    }
    
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        line.color.setStroke()
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {

        for line in finishedLines {
            stroke(line)
//            print("A")
        }

        for (_, line) in currentLines {
            stroke(line)
//            print("B")
        }
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
//            print("C")
        }
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    
    @objc func changeBlue(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.systemBlue
            setNeedsDisplay()
        }
    }
    @objc func changeYellow(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.systemYellow
            setNeedsDisplay()
        }
    }
    @objc func changeTeal(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.systemTeal
            setNeedsDisplay()
        }
    }
    @objc func changeOrange(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].color = UIColor.systemOrange
            setNeedsDisplay()
        }
    }
    @objc func setBlue(_ sender: UIMenuController) {
        desiredColor = UIColor.systemBlue
    }
    @objc func setYellow(_ sender: UIMenuController) {
        desiredColor = UIColor.systemYellow
    }
    @objc func setTeal(_ sender: UIMenuController) {
        desiredColor = UIColor.systemTeal
    }
    @objc func setOrange(_ sender: UIMenuController) {
        desiredColor = UIColor.systemOrange
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location, color: desiredColor)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                line.color = desiredColor
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        if let index = selectedLineIndex {
            if gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)
                
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                setNeedsDisplay()
            }
        } else {
            return
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            print("T")
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
                print("G")
            }
        } else if gestureRecognizer.state == .ended {
            if selectedLineIndex != nil {
                selectedLineIndex = nil
            }
            else {
                print("H")
                let menu = UIMenuController.shared
                becomeFirstResponder()
                
                let colorTeal = UIMenuItem(title: "Teal", action: #selector(DrawView.setTeal(_:)))
                let colorYellow = UIMenuItem(title: "Yellow", action: #selector(DrawView.setYellow(_:)))
                let colorBlue = UIMenuItem(title: "Blue", action: #selector(DrawView.setBlue(_:)))
                let colorOrange = UIMenuItem(title: "Orange", action: #selector(DrawView.setOrange(_:)))
                menu.menuItems = [colorTeal, colorBlue, colorOrange, colorYellow ]
                
                let targetRect = CGRect(x: 400, y: 400, width: 2, height: 2)
                menu.showMenu(from: self, rect: targetRect)
            }

        }
        print("Z")
        setNeedsDisplay()
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        let alert = UIAlertController(title: "Alert", message: "Do you want to clear your canvas?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in print("tapped dismissed")}))
        alert.addAction(UIAlertAction(title: "Delete", style: .default) { _ in
            self.clear()
            self.setNeedsDisplay()
        })
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController!.present(alert, animated: true, completion: nil)

    }
    
    func clear() {
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            becomeFirstResponder()
            
            // Menu : delete + color
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            let colorTeal = UIMenuItem(title: "Teal", action: #selector(DrawView.changeTeal(_:)))
            let colorYellow = UIMenuItem(title: "Yellow", action: #selector(DrawView.changeYellow(_:)))
            let colorBlue = UIMenuItem(title: "Blue", action: #selector(DrawView.changeBlue(_:)))
            let colorOrange = UIMenuItem(title: "Orange", action: #selector(DrawView.changeOrange(_:)))
            menu.menuItems = [deleteItem, colorTeal, colorBlue, colorOrange, colorYellow ]
            
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.showMenu(from: self, rect: targetRect)
        } else {
            menu.hideMenu(from: self)
        }
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        
        return nil
    }
    

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc fileprivate func handleColorChange() {
        
    }
}
extension UIView {
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }

    func getImage(scale: CGFloat? = nil) -> UIImage {
        let newScale = scale ?? UIScreen.main.scale
        self.scale(by: newScale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale

        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)

        let image = renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }

        return image
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
