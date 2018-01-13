//
//  InputViewController.swift
//  DField
//
//  Created by Vikram Mullick on 1/9/18.
//  Copyright © 2018 Vikram Mullick. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
    var InputView = UIView()
    
    var homeViewController : ViewController = ViewController()
    let InputViewHeight : CGFloat = 220
    let InputViewWidth : CGFloat = 400
    let InputViewBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    var fields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        InputView = UIView(frame: CGRect(x: view.frame.width/2-InputViewWidth/2, y: view.frame.height*55/160-InputViewHeight/2-homeViewController.bezelHeight*3/8, width: InputViewWidth, height: InputViewHeight))
        InputView.backgroundColor = InputViewBackgroundColor
        InputView.clipsToBounds = true
        InputView.layer.cornerRadius = 5
        view.addSubview(InputView)
        
        let inputBanner = UIView(frame: CGRect(x: 0, y: 0, width: InputView.frame.width, height: 35))
        inputBanner.backgroundColor = homeViewController.settingsBlue
        InputView.addSubview(inputBanner)
        
        let inputLabel = AdaptiveLabel(frame: CGRect(x: 10, y: 0, width: InputView.frame.width-20, height: 35))
        inputLabel.text = "Differential Equation"
        inputLabel.textColor = .white
        inputBanner.addSubview(inputLabel)
        
        let equationTextFieldLabel = AdaptiveLabel(frame: CGRect(x: 4, y: 39, width: 50, height: 30))
        equationTextFieldLabel.text = "y' ="
        equationTextFieldLabel.textAlignment = .center
        equationTextFieldLabel.textColor = .black
        equationTextFieldLabel.layer.cornerRadius = 5
        equationTextFieldLabel.layer.borderColor = UIColor.black.cgColor
        equationTextFieldLabel.layer.borderWidth = 1
        InputView.addSubview(equationTextFieldLabel)
        
        let equationTextField = UITextField(frame: CGRect(x: 8+equationTextFieldLabel.frame.width, y: 39, width: InputView.frame.width-12-equationTextFieldLabel.frame.width, height: 30))
        equationTextField.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        equationTextField.layer.cornerRadius = 5
        equationTextField.tag = 0
        equationTextField.text = homeViewController.texts[0]
        InputView.addSubview(equationTextField)
        
        //keyboard setup
        let equationTextFieldKeyboardBack = UIView(frame: CGRect(x: 0, y: view.frame.height*55/80-homeViewController.bezelHeight, width: view.frame.width, height: view.frame.height*25/80+homeViewController.bezelHeight*3/4))
        equationTextFieldKeyboardBack.backgroundColor = homeViewController.blue
        let equationTextFieldKeyboard : keyboard = UINib(nibName: "mathBoardyt", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! keyboard
        equationTextFieldKeyboard.frame = CGRect(x: homeViewController.bezelHeight, y: 0, width: view.frame.width-2*homeViewController.bezelHeight, height: view.frame.height*25/80)
        equationTextFieldKeyboardBack.addSubview(equationTextFieldKeyboard)
        equationTextField.inputView = equationTextFieldKeyboardBack
        equationTextFieldKeyboard.textField = equationTextField
        equationTextFieldKeyboard.homeViewController = self
        equationTextFieldKeyboard.expressionArray = homeViewController.textArrays[0]
        fields.append(equationTextField)
        
        let windowBanner = UIView(frame: CGRect(x: 0, y: 73, width: InputView.frame.width, height: 35))
        windowBanner.backgroundColor = homeViewController.settingsBlue
        InputView.addSubview(windowBanner)
        
        let windowLabel = AdaptiveLabel(frame: CGRect(x: 10, y: 0, width: InputView.frame.width-20, height: 35))
        windowLabel.text = "Window Bounds"
        windowLabel.textColor = .white
        windowBanner.addSubview(windowLabel)
        //tMin
        let tMinLabel = AdaptiveLabel(frame: CGRect(x: 4, y: 112, width: 65, height: 30))
        tMinLabel.text = "t-min:"
        tMinLabel.textAlignment = .center
        tMinLabel.textColor = .black
        tMinLabel.layer.cornerRadius = 5
        tMinLabel.layer.borderColor = UIColor.black.cgColor
        tMinLabel.layer.borderWidth = 1
        InputView.addSubview(tMinLabel)
        
        let tMinField = UITextField(frame: CGRect(x: 8+tMinLabel.frame.width, y: 112, width: 125, height: 30))
        tMinField.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        tMinField.layer.cornerRadius = 5
        tMinField.tag = 1
        tMinField.text = homeViewController.texts[1]
        InputView.addSubview(tMinField)
        fields.append(tMinField)

        let tMinFieldKeyboardBack = UIView(frame: CGRect(x: 0, y: view.frame.height*55/80-homeViewController.bezelHeight, width: view.frame.width, height: view.frame.height*25/80+homeViewController.bezelHeight*3/4))
        tMinFieldKeyboardBack.backgroundColor = homeViewController.blue
        let tMinFieldKeyboard : keyboard = UINib(nibName: "mathBoard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! keyboard
        tMinFieldKeyboard.frame = CGRect(x: homeViewController.bezelHeight, y: 0, width: view.frame.width-2*homeViewController.bezelHeight, height: view.frame.height*25/80)
        tMinFieldKeyboardBack.addSubview(tMinFieldKeyboard)
        tMinField.inputView = tMinFieldKeyboardBack
        tMinFieldKeyboard.textField = tMinField
        tMinFieldKeyboard.homeViewController = self
        tMinFieldKeyboard.expressionArray = homeViewController.textArrays[1]

        //tMax
        let tMaxLabel = AdaptiveLabel(frame: CGRect(x: 202, y: 112, width: 65, height: 30))
        tMaxLabel.text = "t-max:"
        tMaxLabel.textAlignment = .center
        tMaxLabel.textColor = .black
        tMaxLabel.layer.cornerRadius = 5
        tMaxLabel.layer.borderColor = UIColor.black.cgColor
        tMaxLabel.layer.borderWidth = 1
        InputView.addSubview(tMaxLabel)
        
        let tMaxField = UITextField(frame: CGRect(x: 206+tMaxLabel.frame.width, y: 112, width: 125, height: 30))
        tMaxField.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        tMaxField.layer.cornerRadius = 5
        tMaxField.tag = 2
        tMaxField.text = homeViewController.texts[2]
        InputView.addSubview(tMaxField)
        fields.append(tMaxField)

        let tMaxFieldKeyboardBack = UIView(frame: CGRect(x: 0, y: view.frame.height*55/80-homeViewController.bezelHeight, width: view.frame.width, height: view.frame.height*25/80+homeViewController.bezelHeight*3/4))
        tMaxFieldKeyboardBack.backgroundColor = homeViewController.blue
        let tMaxFieldKeyboard : keyboard = UINib(nibName: "mathBoard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! keyboard
        tMaxFieldKeyboard.frame = CGRect(x: homeViewController.bezelHeight, y: 0, width: view.frame.width-2*homeViewController.bezelHeight, height: view.frame.height*25/80)
        tMaxFieldKeyboardBack.addSubview(tMaxFieldKeyboard)
        tMaxField.inputView = tMaxFieldKeyboardBack
        tMaxFieldKeyboard.textField = tMaxField
        tMaxFieldKeyboard.homeViewController = self
        tMaxFieldKeyboard.expressionArray = homeViewController.textArrays[2]

        //xMin
        let xMinLabel = AdaptiveLabel(frame: CGRect(x: 4, y: 146, width: 65, height: 30))
        xMinLabel.text = "x-min:"
        xMinLabel.textAlignment = .center
        xMinLabel.textColor = .black
        xMinLabel.layer.cornerRadius = 5
        xMinLabel.layer.borderColor = UIColor.black.cgColor
        xMinLabel.layer.borderWidth = 1
        InputView.addSubview(xMinLabel)
        
        let xMinField = UITextField(frame: CGRect(x: 8+xMinLabel.frame.width, y: 146, width: 125, height: 30))
        xMinField.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        xMinField.layer.cornerRadius = 5
        xMinField.tag = 3
        xMinField.text = homeViewController.texts[3]
        InputView.addSubview(xMinField)
        fields.append(xMinField)

        let xMinFieldKeyboardBack = UIView(frame: CGRect(x: 0, y: view.frame.height*55/80-homeViewController.bezelHeight, width: view.frame.width, height: view.frame.height*25/80+homeViewController.bezelHeight*3/4))
        xMinFieldKeyboardBack.backgroundColor = homeViewController.blue
        let xMinFieldKeyboard : keyboard = UINib(nibName: "mathBoard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! keyboard
        xMinFieldKeyboard.frame = CGRect(x: homeViewController.bezelHeight, y: 0, width: view.frame.width-2*homeViewController.bezelHeight, height: view.frame.height*25/80)
        xMinFieldKeyboardBack.addSubview(xMinFieldKeyboard)
        xMinField.inputView = xMinFieldKeyboardBack
        xMinFieldKeyboard.textField = xMinField
        xMinFieldKeyboard.homeViewController = self
        xMinFieldKeyboard.expressionArray = homeViewController.textArrays[3]

        //xMax
        let xMaxLabel = AdaptiveLabel(frame: CGRect(x: 202, y: 146, width: 65, height: 30))
        xMaxLabel.text = "x-max:"
        xMaxLabel.textAlignment = .center
        xMaxLabel.textColor = .black
        xMaxLabel.layer.cornerRadius = 5
        xMaxLabel.layer.borderColor = UIColor.black.cgColor
        xMaxLabel.layer.borderWidth = 1
        InputView.addSubview(xMaxLabel)
        
        let xMaxField = UITextField(frame: CGRect(x: 206+tMaxLabel.frame.width, y: 146, width: 125, height: 30))
        xMaxField.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        xMaxField.layer.cornerRadius = 5
        xMaxField.tag = 4
        xMaxField.text = homeViewController.texts[4]
        InputView.addSubview(xMaxField)
        fields.append(xMaxField)

        let xMaxFieldKeyboardBack = UIView(frame: CGRect(x: 0, y: view.frame.height*55/80-homeViewController.bezelHeight, width: view.frame.width, height: view.frame.height*25/80+homeViewController.bezelHeight*3/4))
        xMaxFieldKeyboardBack.backgroundColor = homeViewController.blue
        let xMaxFieldKeyboard : keyboard = UINib(nibName: "mathBoard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! keyboard
        xMaxFieldKeyboard.frame = CGRect(x: homeViewController.bezelHeight, y: 0, width: view.frame.width-2*homeViewController.bezelHeight, height: view.frame.height*25/80)
        xMaxFieldKeyboardBack.addSubview(xMaxFieldKeyboard)
        xMaxField.inputView = xMaxFieldKeyboardBack
        xMaxFieldKeyboard.textField = xMaxField
        xMaxFieldKeyboard.homeViewController = self
        xMaxFieldKeyboard.expressionArray = homeViewController.textArrays[4]

        let cancelButton = UIButton(frame: CGRect(x: InputView.frame.width-160, y: 180, width: 75, height: 35))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        cancelButton.setTitleColor(homeViewController.blue, for: .normal)
        cancelButton.setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .highlighted)
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action:#selector(cancel), for: .touchUpInside)
        InputView.addSubview(cancelButton)
        
        let plotButton = UIButton(frame: CGRect(x: InputView.frame.width-80, y: 180, width: 75, height: 35))
        plotButton.setTitle("Plot", for: .normal)
        plotButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        plotButton.setTitleColor(homeViewController.blue, for: .normal)
        plotButton.setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .highlighted)
        plotButton.layer.cornerRadius = 5
        plotButton.clipsToBounds = true
        plotButton.addTarget(self, action:#selector(cancel), for: .touchUpInside)
        InputView.addSubview(plotButton)
    }
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    @objc func cancel()
    {
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


