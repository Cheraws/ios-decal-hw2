//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    let operators = ["/", "*", "-", "+", "="]
    let others = ["C", "+/-", "%"]
    let special = ["0", "."]
    var firstNumber = ""
    var currentOperator = ""
    
    var exactValue = 0.0
    var validOperator = false
    var prevOperator = false //refers to whether the previous value was an operator
    var dotOperator = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        var label = self.resultLabel.text!
        //let numberLabel = Int(self.resultLabel.text!)
        //let firstNumberLabel = Int(firstNumber)
        let count = label.characters.count
        if(others.contains(content)){
            if(content == "C"){
                self.resultLabel.text = "0"
                firstNumber = ""
                currentOperator = ""
                validOperator = false
                prevOperator = false
            }
            if(content == "+/-"){
                let value = -Double(self.resultLabel.text!)!
                
                if(value.truncatingRemainder(dividingBy:1) == 0){
                    let text = String(Int(value))
                    if (text.characters.count <= 7){
                        self.resultLabel.text = text
                    }
                }
                else{
                    let text = String(value)
                    if(text.characters.count <= 7){
                        self.resultLabel.text = text
                    }
                    
                }
            }
            return
        }
        if (operators.contains(content)){
            print("So we see operators")
            if(firstNumber == "" && content != "="){
                //first operation
                firstNumber = self.resultLabel.text!
                exactValue = Double(label)!
                prevOperator = true
                currentOperator = content
            }

            else{
                
                if(content == "="){
                    //let newText = String(intCalculate(a: firstNumberLabel!,b: numberLabel!, operation:currentOperator))
                    let newText = calculate(a: exactValue,b: label, operation:currentOperator)
                    if(newText > 9999999 || newText < -999999){
                        return
                    }
                    if(0 > newText && newText > -0.0001){
                        return
                    }
                    if(0 < newText && newText < 0.00001){
                        return
                    }

                    exactValue = newText
                    firstNumber = ""
                    currentOperator = "="
                    if(newText.truncatingRemainder(dividingBy:1) == 0){
                        self.resultLabel.text = String(Int(newText))
                    }else{
                        self.resultLabel.text = String(newText)
                    }
                    label = self.resultLabel.text!
                    if(label.characters.count > 7){
                        self.resultLabel.text = (label as NSString).substring(to: 7)
                    }

                }
                else{
                    if (prevOperator == true){
                        currentOperator = content
                        return
                    }
                    //use previous currentOperator, then add again.
                    //let newText = String(intCalculate(a: firstNumberLabel!,b: numberLabel!, operation:currentOperator))
                    let newText = calculate(a: exactValue,b: label, operation:currentOperator)
                    if(newText > 9999999 || newText < -999999){
                        return
                    }
                    if(0 > newText && newText > -0.0001){
                        return
                    }
                    if(0 < newText && newText < 0.00001){
                        return
                    }
                    exactValue = newText
                    currentOperator = content
                    prevOperator = true
                    if(newText.truncatingRemainder(dividingBy:1) == 0){
                        self.resultLabel.text = String(Int(newText))
                        firstNumber = String(Int(newText))
                        exactValue = newText
                    }else{
                        firstNumber = String(newText)
                        self.resultLabel.text = String(newText)
                        exactValue = newText
                    }
                    label = self.resultLabel.text!
                    if(label.characters.count > 7){
                        self.resultLabel.text = (label as NSString).substring(to: 7)
                    }
                    
                }
            }
            return;
        }
        if(special.contains(content)){
            if(content == "0"){
                if(count != 7){
                    if(self.resultLabel.text == "0" || prevOperator == true){
                        self.resultLabel.text = "0"
                    }
                    else{
                        self.resultLabel.text = label + content;
                    }
                }
            }
            if(content == "."){
                if(count != 7){
                    
                    if(self.resultLabel.text == "0" || prevOperator == true){
                        self.resultLabel.text = "0."
                    }
                    else{
                        if(self.resultLabel.text!.range(of: ".") == nil){
                            self.resultLabel.text = label + content;
                        }
                        else{
                            //equivalent of empty operation
                            return
                        }
                    }
                }
            }
            prevOperator = false
            return
        }
        if (self.resultLabel.text == "0" || prevOperator == true){
            self.resultLabel.text = content
        }
        else if (count >= 7){
            return
        }
        else{
            self.resultLabel.text = label + content;
        }
        prevOperator = false
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        if(operation == "-"){
            return a-b
        }
        else if(operation == "+"){
            return a+b
        }
        else if(operation == "/"){
            return a/b
        }
        else if(operation == "*"){
            return a*b
        }
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: Double, b:String, operation: String) -> Double {
        //let dA = Double(a)!
        let dA = a
        //let dA = Double(a)
        //let Da = exactValue
        let dB = Double(b)!
        if(operation == "-"){
            return dA-dB
        }
        else if(operation == "+"){
            return dA+dB
        }
        else if(operation == "/"){
            return dA/dB
        }
        else if(operation == "*"){
            return dA*dB
        }
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0.0
    }

    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        updateResultLabel(sender.content)
        print("The number \(sender.content) was pressed")
        // Fill me in!
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        if operators.contains(sender.content) || others.contains(sender.content) {
            print("The button \(sender.content) was pressed")
            updateResultLabel(sender.content)
        }
        else{
            return
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
        if special.contains(sender.content) {
            print("The button \(sender.content) was pressed")
            updateResultLabel(sender.content)
        }
        else{
            return
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

