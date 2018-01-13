//
//  SettingsViewController.swift
//  DField
//
//  Created by Vikram Mullick on 1/2/18.
//  Copyright © 2018 Vikram Mullick. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settingsView = UIView()
    
    var homeViewController : ViewController = ViewController()
    let settingsViewHeight : CGFloat = 240
    let widthToHeightRatio : CGFloat = 1.618
    let settingsViewBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    var colors = [UIColor]()
    var colorIndeces = [Int]()
    
    let colorSelectViews = [UIView(),UIView(),UIView(),UIView()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        colors = homeViewController.colors
        colorIndeces = homeViewController.colorIndeces
        
        let graphView = homeViewController.fieldView
        settingsView = UIView(frame: CGRect(x: graphView.frame.width/2-(widthToHeightRatio*settingsViewHeight)/2+graphView.frame.minX+homeViewController.mainView.frame.minX, y: graphView.frame.height/2-settingsViewHeight/2+graphView.frame.minY+homeViewController.mainView.frame.minY, width: widthToHeightRatio*settingsViewHeight, height: settingsViewHeight))
        settingsView.backgroundColor = settingsViewBackgroundColor
        settingsView.clipsToBounds = true
        settingsView.layer.cornerRadius = 5
        view.addSubview(settingsView)
        
        let settingsBanner = UIView(frame: CGRect(x: 0, y: 0, width: settingsView.frame.width, height: 35))
        settingsBanner.backgroundColor = homeViewController.settingsBlue
        settingsView.addSubview(settingsBanner)
        
        let settingsLabel = AdaptiveLabel(frame: CGRect(x: 10, y: 0, width: settingsView.frame.width-55, height: 35))
        settingsLabel.text = "Settings"
        settingsLabel.textColor = .white
        settingsBanner.addSubview(settingsLabel)
        
        let settingsImage = UIImage(named: "settings.png")
        let settingsImageView = UIImageView(frame: CGRect(x: settingsView.frame.width-35, y: 0, width: 35, height: 35))
        settingsImageView.image = settingsImage
        settingsBanner.addSubview(settingsImageView)
        
        for f in 0...3
        {
            colorSelectViews[f].backgroundColor = .clear
            colorSelectViews[f].layer.borderWidth = 1.5
            colorSelectViews[f].layer.borderColor = homeViewController.blue.cgColor
            colorSelectViews[f].frame = CGRect(x: settingsView.frame.width-240+CGFloat(colorIndeces[f])*40, y: 40*CGFloat(f+1), width: 35, height: 35)
            colorSelectViews[f].layer.cornerRadius = colorSelectViews[f].frame.height/2
            settingsView.addSubview(colorSelectViews[f])
        }
        
        
        for f in 0...3 //f - each row
        {
            for i in 0..<colors.count //i - each color
            {
                let button = UIButton(frame: CGRect(x: settingsView.frame.width-240+CGFloat(i)*40+2.5, y: 40*CGFloat(f+1)+2.5, width: 30, height: 30))
                button.backgroundColor = colors[i]
                button.layer.cornerRadius = button.frame.height/2
                button.tag = f*6+i
                button.addTarget(self, action:#selector(changeColor), for: .touchDown)
                settingsView.addSubview(button)
            }
        }
        
        let colorTitles : [String] = ["Axes","Vector Field","Point","Solution Curve"]
        for i in 0..<colorTitles.count
        {
            let colorTitleLabel = UILabel(frame: CGRect(x: 5, y: 40*CGFloat(i+1), width: settingsView.frame.width-255, height: 35))
            colorTitleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.75)
            colorTitleLabel.layer.cornerRadius = 5
            colorTitleLabel.clipsToBounds = true
            colorTitleLabel.textColor = .black
            colorTitleLabel.text = ""+colorTitles[i]
            colorTitleLabel.textAlignment = .center
            settingsView.addSubview(colorTitleLabel)
        }
        
        
        let doneButton = UIButton(frame: CGRect(x: settingsView.frame.width-80, y: 200, width: 75, height: 35))
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        doneButton.setTitleColor(homeViewController.blue, for: .normal)
        doneButton.setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .highlighted)
        doneButton.layer.cornerRadius = 5
        doneButton.clipsToBounds = true
        doneButton.addTarget(self, action:#selector(done), for: .touchUpInside)
        settingsView.addSubview(doneButton)
        
        let restoreButton = UIButton(frame: CGRect(x: 5, y: 200, width: 225, height: 35))
        restoreButton.setTitle("Restore Default Settings", for: .normal)
        restoreButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        restoreButton.setTitleColor(homeViewController.blue, for: .normal)
        restoreButton.setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .highlighted)
        restoreButton.layer.cornerRadius = 5
        restoreButton.clipsToBounds = true
        restoreButton.addTarget(self, action:#selector(restore), for: .touchUpInside)
        settingsView.addSubview(restoreButton)
    }
    @objc func changeColor(sender: UIButton)
    {
        colorIndeces[sender.tag/6] = sender.tag % 6
        colorSelectViews[sender.tag/6].frame = CGRect(x: settingsView.frame.width-240+CGFloat(colorIndeces[sender.tag/6])*40, y: 40*CGFloat(sender.tag/6+1), width: 35, height: 35)
        
        homeViewController.colorIndeces = colorIndeces
        homeViewController.defaults.set(colorIndeces, forKey: "colorIndeces")
        homeViewController.recolor()
    }
    @objc func restore()
    {
        colorIndeces = [2,4,1,5]
        for f in 0...3
        {
            colorSelectViews[f].frame = CGRect(x: settingsView.frame.width-240+CGFloat(colorIndeces[f])*40, y: 40*CGFloat(f+1), width: 35, height: 35)
        }
        homeViewController.colorIndeces = colorIndeces
        homeViewController.defaults.set(colorIndeces, forKey: "colorIndeces")
        homeViewController.recolor()
    }
    @objc func done()
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

