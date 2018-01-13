//
//  keyboard.swift
//  DField
//
//  Created by Vikram Mullick on 1/10/18.
//  Copyright © 2018 Vikram Mullick. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftTryCatch

class keyboard : UIView, UIKeyInput {
    public var hasText: Bool
    
    var expressionArray : [String]?
    
    var textField : UITextField?
    var homeViewController : InputViewController?
    
    var draftNumericExression = String()
    var draftValue = Double()
    
    var timer: Timer?
    
    override init(frame: CGRect) {
        self.hasText = false
        self.expressionArray = [String]()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hasText = false
        self.expressionArray = [String]()
        super.init(coder: aDecoder)
        
    }
    override func awakeFromNib() {
        setupButtons()
    }
    
    func setupButtons()
    {
        for v in self.subviews
        {
            for v2 in v.subviews
            {
                for v3 in v2.subviews
                {
                    let button : UIButton = v3 as! UIButton
                    button.layer.borderWidth = 0.50
                    if button.tag < 2
                    {
                        button.setTitleColor(button.backgroundColor, for: .highlighted)
                    }
                    button.addTarget(self, action:#selector(keyboardTapStart), for: .touchDown)
                    button.addTarget(self, action:#selector(keyboardTapEnd), for: .touchUpInside)
                    button.addTarget(self, action:#selector(keyboardTapStart), for: .touchDragEnter)
                    button.addTarget(self, action:#selector(keyboardTapEnd), for: .touchDragExit)
                    if button.titleLabel?.text == "delete"
                    {
                        button.addTarget(self, action:#selector(deleteStart), for: .touchDown)
                        button.addTarget(self, action:#selector(deleteEnd), for: .touchUpInside)
                        button.addTarget(self, action:#selector(deleteStart), for: .touchDragEnter)
                        button.addTarget(self, action:#selector(deleteEnd), for: .touchDragExit)
                        
                        button.addTarget(self, action:#selector(deleteBackward), for: .touchUpInside)
                    }
                    else if button.titleLabel?.text == "plot"
                    {
                        button.addTarget(self, action:#selector(plot), for: .touchUpInside)
                    }
                    else
                    {
                        button.addTarget(self, action:#selector(keyboardTap), for: .touchUpInside)
                    }
                    
                }
            }
        }
        
    }
    @objc func keyboardTap(sender: UIButton!)
    {
        let textToEnter : String = getString((sender.titleLabel?.text)!)
        if isFunction(textToEnter) || isVariable(textToEnter)
        {
            if isNumber(getLast()) || isVariable(getLast()) || getLast() == ")"
            {
                insertText("⋅")
            }
            else if isDecimal(getLast())
            {
                insertText("0")
                insertText("⋅")
            }
        }
        else if isNumber(textToEnter)
        {
            if isVariable(getLast()) || getLast() == ")"
            {
                insertText("⋅")
            }
        }
        else
        {
            if isDecimal(getLast())
            {
                insertText("0")
            }
        }
        
        insertText(textToEnter)
        
    }
    func confirmField() -> Bool
    {
        var execute = true
        let numericExpression = convertString(self.textField?.text)
        print(numericExpression)
        var d = Double()
        
        SwiftTryCatch.try({
            
            let expression = NSExpression(format: numericExpression.replacingOccurrences(of: "t", with: "1.0").replacingOccurrences(of: "y", with: "1.0"))
            let answer = expression.expressionValue(with: nil, context: nil)
            d = answer as! Double
            
            if d.isNaN || d.isInfinite
            {
                execute = false
            }
            
        }, catch: { (error) in
            execute = false
        }, finally: {})
        
        if execute
        {
            textField?.backgroundColor = UIColor.white.withAlphaComponent(0.75)
            if textField?.tag == 0
            {
                draftNumericExression = numericExpression
            }
            else
            {
                draftValue = d
            }
        }
        else
        {
            self.textField?.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
        
        return execute
        
    }
    func convertString(_ expression : String!) -> String
    {
        var numericExpression = expression!
        var i = 0
        while i < numericExpression.count
        {
            var hasNum = false
            var currentChar : String = String(Array(numericExpression)[i])
            while isNumber(currentChar)
            {
                i = i + 1
                hasNum = true
                if i < numericExpression.count
                {
                    currentChar = String(Array(numericExpression)[i])
                }
                else
                {
                    break
                }
            }
            if hasNum
            {
                if !isDecimal(currentChar)
                {
                    numericExpression.insert(".", at: numericExpression.index(numericExpression.startIndex, offsetBy: i))
                    numericExpression.insert("0", at: numericExpression.index(numericExpression.startIndex, offsetBy: i+1))
                    i = i + 2
                }
                else
                {
                    while(isNumber(String(Array(numericExpression)[i])) || isDecimal(String(Array(numericExpression)[i])))
                    {
                        i = i + 1
                        if i == numericExpression.count - 1
                        {
                            break
                        }
                    }
                }
            }
            i = i + 1
        }
        numericExpression = numericExpression.replacingOccurrences(of: "⋅", with: "*")
        numericExpression = numericExpression.replacingOccurrences(of: "^", with: "**")
        numericExpression = numericExpression.replacingOccurrences(of: "e", with: "(\(M_E))")
        numericExpression = numericExpression.replacingOccurrences(of: "π", with: "(\(Double.pi))")
        
        while(numericExpression.contains("sin"))
        {
            let range = numericExpression.range(of: "sin")
            var temp = numericExpression.index(before: (range?.upperBound)!)
            var numPar : Int = 0
            repeat
            {
                temp = numericExpression.index(after: temp)
                
                let currentChar : Character = numericExpression[temp]
                if(currentChar=="(")
                {
                    numPar = numPar + 1
                }
                if(currentChar==")")
                {
                    numPar = numPar - 1
                }
            }while(numPar>0 && numericExpression.distance(from: numericExpression.startIndex, to: (temp))+1<numericExpression.count)
            numericExpression.insert(contentsOf: ",'sn'", at: temp)
            numericExpression.replaceSubrange(range!, with: "FUNCTION")
        }
        while(numericExpression.contains("cos"))
        {
            let range = numericExpression.range(of: "cos")
            var temp = numericExpression.index(before: (range?.upperBound)!)
            var numPar : Int = 0
            repeat
            {
                temp = numericExpression.index(after: temp)
                
                let currentChar : Character = numericExpression[temp]
                if(currentChar=="(")
                {
                    numPar = numPar + 1
                }
                if(currentChar==")")
                {
                    numPar = numPar - 1
                }
            }while(numPar>0 && numericExpression.distance(from: numericExpression.startIndex, to: (temp))+1<numericExpression.count)
            numericExpression.insert(contentsOf: ",'cs'", at: temp)
            numericExpression.replaceSubrange(range!, with: "FUNCTION")
        }
        while(numericExpression.contains("ln"))
        {
            let range = numericExpression.range(of: "ln")
            var temp = numericExpression.index(before: (range?.upperBound)!)
            var numPar : Int = 0
            repeat
            {
                temp = numericExpression.index(after: temp)
                
                let currentChar : Character = numericExpression[temp]
                if(currentChar=="(")
                {
                    numPar = numPar + 1
                }
                if(currentChar==")")
                {
                    numPar = numPar - 1
                }
            }while(numPar>0 && numericExpression.distance(from: numericExpression.startIndex, to: (temp))+1<numericExpression.count)
            numericExpression.insert(contentsOf: ",'lg'", at: temp)
            numericExpression.replaceSubrange(range!, with: "FUNCTION")
        }
        while(numericExpression.contains("√"))
        {
            let range = numericExpression.range(of: "√")
            var temp = numericExpression.index(before: (range?.upperBound)!)
            var numPar : Int = 0
            repeat
            {
                temp = numericExpression.index(after: temp)
                
                let currentChar : Character = numericExpression[temp]
                if(currentChar=="(")
                {
                    numPar = numPar + 1
                }
                if(currentChar==")")
                {
                    numPar = numPar - 1
                }
            }while(numPar>0 && numericExpression.distance(from: numericExpression.startIndex, to: (temp))+1<numericExpression.count)
            numericExpression.insert(contentsOf: ",'sq'", at: temp)
            numericExpression.replaceSubrange(range!, with: "FUNCTION")
        }
        return numericExpression
        
    }
    @objc func keyboardTapEnd(sender: UIButton!)
    {
        sender.layer.borderColor = UIColor.black.cgColor
        if sender.subviews.count > 0
        {
            if let keyLabel : AdaptiveLabel = sender.subviews[sender.subviews.count-1] as? AdaptiveLabel
            {
                keyLabel.removeFromSuperview()
            }
        }
        
    }
    @objc func keyboardTapStart(sender: UIButton!)
    {
        if sender.tag < 2
        {
            sender.layer.borderColor = sender.backgroundColor?.cgColor
            let v = AdaptiveLabel(frame: CGRect(x: CGFloat(-10-10*sender.tag), y: -sender.frame.height-10, width: sender.frame.width+20, height: sender.frame.height+10.50))
            v.backgroundColor = sender.backgroundColor
            v.layer.borderWidth = 0.50
            v.clipsToBounds = true
            v.text = sender.titleLabel?.text
            v.textColor = sender.titleColor(for: .normal)
            v.textAlignment = .center
            sender.addSubview(v)
        }
        AudioServicesPlaySystemSound(1104)
    }
    @objc func plot()
    {
        if isDecimal(getLast())
        {
            insertText("0")
        }
        var confirmations = [Bool]()
        for i in 0...4
        {
            confirmations.append((homeViewController?.fields[i].inputView?.subviews[0] as! keyboard).confirmField())
        }
        var confirm = true
        for c in confirmations
        {
            confirm = confirm && c
        }
        if confirm
        {
            var a = false
            if (homeViewController?.fields[3].inputView?.subviews[0] as! keyboard).draftValue < (homeViewController?.fields[4].inputView?.subviews[0] as! keyboard).draftValue
            {
                homeViewController?.fields[3].backgroundColor = UIColor.white.withAlphaComponent(0.75)
                homeViewController?.fields[4].backgroundColor = UIColor.white.withAlphaComponent(0.75)
                a = true
            }
            else
            {
                homeViewController?.fields[3].backgroundColor = UIColor.red.withAlphaComponent(0.5)
                homeViewController?.fields[4].backgroundColor = UIColor.red.withAlphaComponent(0.5)
            }
            
            var b = false
            if (homeViewController?.fields[1].inputView?.subviews[0] as! keyboard).draftValue < (homeViewController?.fields[2].inputView?.subviews[0] as! keyboard).draftValue
            {
                homeViewController?.fields[1].backgroundColor = UIColor.white.withAlphaComponent(0.75)
                homeViewController?.fields[2].backgroundColor = UIColor.white.withAlphaComponent(0.75)
                b = true
            }
            else
            {
                homeViewController?.fields[1].backgroundColor = UIColor.red.withAlphaComponent(0.5)
                homeViewController?.fields[2].backgroundColor = UIColor.red.withAlphaComponent(0.5)
            }
            
            if a && b
            {
                homeViewController?.homeViewController.eqnExpression = (homeViewController?.fields[0].inputView?.subviews[0] as! keyboard).draftNumericExression
                
                homeViewController?.homeViewController.minT = CGFloat((homeViewController?.fields[1].inputView?.subviews[0] as! keyboard).draftValue)
                homeViewController?.homeViewController.maxT = CGFloat((homeViewController?.fields[2].inputView?.subviews[0] as! keyboard).draftValue)
                homeViewController?.homeViewController.minX = CGFloat((homeViewController?.fields[3].inputView?.subviews[0] as! keyboard).draftValue)
                homeViewController?.homeViewController.maxX = CGFloat((homeViewController?.fields[4].inputView?.subviews[0] as! keyboard).draftValue)
                
                for i in 0...4
                {
                    homeViewController?.homeViewController.texts[i] = (homeViewController?.fields[i].text)!
                    homeViewController?.homeViewController.textArrays[i] = (homeViewController?.fields[1].inputView?.subviews[0] as! keyboard).expressionArray!
                }
                
                homeViewController?.homeViewController.equationLabel.text = homeViewController?.homeViewController.texts[0]
                homeViewController?.view.endEditing(true)
                homeViewController?.homeViewController.render()
            }
        }
        
    }
    
    func insertText(_ text: String) {
        hasText = true
        textField?.text?.append(text)
        expressionArray?.append(text)
        
    }
    @objc func deleteStart()
    {
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(UIKeyInput.deleteBackward), userInfo: nil, repeats: true)
    }
    @objc func deleteEnd()
    {
        timer?.invalidate()
        timer = nil
    }
    func deleteBackward() {
        if hasText
        {
            let lastVariable = expressionArray?.removeLast()
            hasText = expressionArray?.count != 0
            let index = textField?.text?.index((textField?.text?.startIndex)!, offsetBy: (textField?.text?.count)! - (lastVariable?.count)!)
            textField?.text? = (textField?.text?.substring(to: index!))!
        }
    }
    func getLast() -> String
    {
        if (expressionArray?.count)! > 0
        {
            return expressionArray![expressionArray!.count - 1]
        }
        return ""
    }
    func isOperator(_ string : String) -> Bool
    {
        if string == "⋅"
        {
            return true
        }
        else if string == "/"
        {
            return true
        }
        else if string == "+"
        {
            return true
        }
        else if string == "_"
        {
            return true
        }
        else if string == "^"
        {
            return true
        }
        return false
    }
    func isFunction(_ string : String) -> Bool
    {
        if string == "cos("
        {
            return true
        }
        else if string == "sin("
        {
            return true
        }
        else if string == "ln("
        {
            return true
        }
        else if string == "√("
        {
            return true
        }
        else if string == "("
        {
            return true
        }
        return false
    }
    func isDecimal(_ string : String) -> Bool
    {
        return string == "."
    }
    func isNumber(_ string : String) -> Bool
    {
        for i in 0...9
        {
            if string == "\(i)"
            {
                return true
            }
        }
        return false
    }
    func isVariable(_ string : String) -> Bool
    {
        if string == "t"
        {
            return true
        }
        else if string == "y"
        {
            return true
        }
        else if string == "π"
        {
            return true
        }
        else if string == "e"
        {
            return true
        }

        return false
    }
    func getString(_ string : String) -> String
    {
        if string == "×"
        {
            return "⋅"
        }
        else if string == "÷"
        {
            return "/"
        }
        else if string == "ln" || string == "cos" || string == "sin" || string == "√"
        {
            return "\(string)("
        }
        return string
    }
    
}

