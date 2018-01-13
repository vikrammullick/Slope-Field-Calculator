//
//  ViewController.swift
//  DField
//
//  Created by Vikram Mullick on 6/9/17.
//  Copyright © 2017 Vikram Mullick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard

    let accuracy : CGFloat = 1
    let pointLabel = AdaptiveLabel()
    let equationLabel = UILabel()

    var texts = [String(), String(), String(), String(), String()]
    var textArrays = [[String](), [String](), [String](), [String](), [String]()]

    var slopeFieldLayers = [CAShapeLayer]()
    var axesLayers = [CAShapeLayer]()
    var pointLayers = [CAShapeLayer]()
    var curveLayers = [CAShapeLayer]()

    let mainView = UIView()
    let fieldView = UIView()
    
    var topHeight : CGFloat = 45
    var spacing : CGFloat = 3
    var bezelHeight : CGFloat = 0
    
    let selectedColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    let deselectedColor = UIColor(red: 207/255, green: 207/255, blue: 207/255, alpha: 1)
    let backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    let borderColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
    let blue = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    let clearBlue = UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.6)
    let skyBlue = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
    let settingsBlue = UIColor(red: 0, green: 130/255, blue: 210/255, alpha: 1)
    
    var colors = [UIColor]()
    var colorIndeces : [Int] = [2,4,1,5]
    /*var gridColorIndex = 2
    var vectorColorIndex = 4
    var pointColorIndex = 1
    var solutionCurveColorIndex = 5*/

    var selectedTabIndex = 0
    
    var eqnExpression = "t+y*y"
    var minX : CGFloat = -5
    var maxX : CGFloat  = 5
    var xRange : CGFloat  = CGFloat()
    var minT : CGFloat  = -5
    var maxT : CGFloat  = 5
    var tRange : CGFloat  = CGFloat()
    
    var fieldWidth : CGFloat = CGFloat()
    var fieldHeight : CGFloat = CGFloat()
    var rat : CGFloat = CGFloat()
    
    let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        colors = [UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 1),
                  UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1),
                  blue,
                  UIColor(red: 151/255, green: 85/255, blue: 183/255, alpha: 1),
                  UIColor(red: 255/255, green: 51/255, blue : 0/255, alpha: 1),
                  .white]
        if let colorIndeces = defaults.object(forKey: "colorIndeces") {
            self.colorIndeces = colorIndeces as! [Int]
        }
        setupPathAnimation()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        topHeight = 46
        spacing = (view.frame.height/30+35)/15
        if UIDevice().userInterfaceIdiom == .phone
        {
            if UIScreen.main.nativeBounds.height == 2436
            {
                bezelHeight = 30
        
            }
        }
    
        setupSettingsButton()
        setupEditEquationButton()
        setupEquationLabel()
        render()

        /*for _ in 0...10
        {
            graphCurve(point: CGPoint(x: randomInt(min: Int(minT), max: Int(maxT)), y: randomInt(min: Int(minX), max: Int(maxX))))
        }*/
    }
    func setupPointLabel()
    {
        pointLabel.frame = CGRect(x: spacing*6+5, y: spacing*2+5, width: 120, height: 30)
        pointLabel.text = ""
        pointLabel.adjustsFontSizeToFitWidth = true
        pointLabel.textAlignment = .center
        pointLabel.baselineAdjustment = .alignCenters
        pointLabel.backgroundColor = clearBlue
        pointLabel.textColor = .white
        pointLabel.layer.cornerRadius = 5
        pointLabel.layer.masksToBounds = true
        pointLabel.isHidden = true
        mainView.addSubview(pointLabel)

    }
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    func setupClearButton()
    {
        let button = UIButton(frame: CGRect(x: mainView.frame.width-spacing*3-60-5, y: spacing*2+5, width: 60, height: 30))
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = clearBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(clearBlue, for: .highlighted)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        mainView.addSubview(button)
    }
    func setupAxes()
    {
        let minT = self.minT.rounded(.down)
        let maxT = self.maxT.rounded(.up)
        let minX = self.minX.rounded(.down)
        let maxX = self.maxX.rounded(.up)
        let tRange = maxT-minT
        let xRange = maxX-minX
        
        let tInterval = getInterval(range: tRange)
        let xInterval = getInterval(range: xRange)*2
    
        var startT = Int(self.minT.rounded(.up))
        var startX = Int(self.minX.rounded(.up))
        
        startX = nextMultiple(num: startX, interval: Int(xInterval))
        startT = nextMultiple(num: startT, interval: Int(tInterval))
        
        for i in stride(from: CGFloat(startT), through: self.maxT, by: tInterval)
        {
            let  axis = UIBezierPath()
            axis.move(to: locationFromPoint(point: CGPoint(x: i, y: self.minX)))
            axis.addLine(to: locationFromPoint(point: CGPoint(x: i, y: self.maxX)))
            
            let p = locationFromPoint(point: CGPoint(x: i, y: self.minX))
            let l = AdaptiveLabel()
            l.frame = CGRect(x: p.x+3*spacing, y: p.y+spacing*3, width: spacing*6, height: spacing*4)
            l.text = "\(Int(i))"
            l.adjustsFontSizeToFitWidth = true
            l.textAlignment = .center
            l.baselineAdjustment = .alignCenters
            mainView.addSubview(l)
            
            let axisLayer = CAShapeLayer()
            axisLayer.path = axis.cgPath
            axisLayer.fillColor = UIColor.clear.cgColor
            axisLayer.strokeColor = colors[colorIndeces[0]].cgColor
            axisLayer.lineWidth = 1
            if i == 0
            {
                axisLayer.lineWidth = 5
            }
            axisLayer.lineDashPattern = [4, 4]
            fieldView.layer.addSublayer(axisLayer)
            axesLayers.append(axisLayer)
        }
        
        print()
        for i in stride(from: CGFloat(startX), through: self.maxX, by: xInterval)
        {
            print(Int(i))
            let  axis = UIBezierPath()
            axis.move(to: locationFromPoint(point: CGPoint(x: self.minT, y: i)))
            axis.addLine(to: locationFromPoint(point: CGPoint(x: self.maxT, y: i)))
            
            let p = locationFromPoint(point: CGPoint(x: self.minT, y: i))
            let l = AdaptiveLabel()
            l.frame = CGRect(x: p.x, y: p.y, width: spacing*6, height: spacing*4)
            l.text = "\(Int(i))"
            l.adjustsFontSizeToFitWidth = true
            l.textAlignment = .center
            l.baselineAdjustment = .alignCenters
            mainView.addSubview(l)

            let axisLayer = CAShapeLayer()
            axisLayer.path = axis.cgPath
            axisLayer.fillColor = UIColor.clear.cgColor
            axisLayer.strokeColor = colors[colorIndeces[0]].cgColor
            axisLayer.lineWidth = 1
            if i == 0
            {
                axisLayer.lineWidth = 5
            }
            axisLayer.lineDashPattern = [4, 4]
            fieldView.layer.addSublayer(axisLayer)
            axesLayers.append(axisLayer)
        }

        
    }
    func setupSlopeField()
    {
        let minT = self.minT.rounded(.down)
        let maxT = self.maxT.rounded(.up)
        let minX = self.minX.rounded(.down)
        let maxX = self.maxX.rounded(.up)
        let tRange = maxT-minT
        let xRange = maxX-minX
        
        var tInterval : CGFloat = getInterval(range: tRange)
        var xInterval : CGFloat = getInterval(range: xRange)*2
        
        var startT = Int(self.minT.rounded(.up))
        var startX = Int(self.minX.rounded(.up))
        
        startX = nextMultiple(num: startX, interval: Int(xInterval))
        startT = nextMultiple(num: startT, interval: Int(tInterval))
        
        let tPixels = Int(tInterval*fieldWidth/tRange)
        let numT : Int = tPixels/60+1
        tInterval = tInterval/CGFloat(numT)
        
        let xPixels = Int(xInterval*fieldHeight/xRange)
        let numX : Int = xPixels/60+1
        xInterval = xInterval/CGFloat(numX)
        
        for i in stride(from: CGFloat(startT)-tInterval*CGFloat(numT), through: self.maxT+tInterval*CGFloat(numT), by: tInterval)
        {
            for j in stride(from: CGFloat(startX)-xInterval*CGFloat(numX), through: self.maxX+xInterval*CGFloat(numX), by: xInterval)
            {
                let p = locationFromPoint(point: CGPoint(x: CGFloat(i),y: CGFloat(j)))
                drawVector(t: p.x, x: p.y, len: 10)
            }
        }
        
    }
    func drawVector(t: CGFloat, x: CGFloat, len: CGFloat)
    {
        let dxdt = differential(p: pointFromLocation(loc: CGPoint(x: t, y: x)))
        if dxdt.isInfinite || dxdt.isNaN
        {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: t,y: x), radius: CGFloat(4), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let nullVector = CAShapeLayer()
            nullVector.path = circlePath.cgPath
            nullVector.fillColor = colors[colorIndeces[1]].cgColor
            nullVector.strokeColor = colors[colorIndeces[1]].cgColor
            nullVector.lineWidth = 1
            fieldView.layer.addSublayer(nullVector)
            slopeFieldLayers.append(nullVector)
        }
        else
        {
            let deltaT = len/sqrt(dxdt*dxdt*rat*rat+1)
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x:t-deltaT, y:x+deltaT*rat*dxdt))
            linePath.addLine(to: CGPoint(x:t+deltaT, y:x-deltaT*rat*dxdt))
            let lineLayer = CAShapeLayer()
            lineLayer.path = linePath.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = colors[colorIndeces[1]].cgColor
            lineLayer.lineWidth = 2
            fieldView.layer.addSublayer(lineLayer)
            slopeFieldLayers.append(lineLayer)
        }
        
    }
    func setupPathAnimation()
    {
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.duration = 0.3
    }
    func setupEquationLabel()
    {
        let equationLabelBackground = UIView(frame: CGRect(x: 7*spacing+bezelHeight+topHeight, y: spacing, width: view.frame.width-bezelHeight*2-75-11*spacing-topHeight, height: topHeight))
        equationLabelBackground.backgroundColor = .white
        equationLabelBackground.layer.cornerRadius = 5
        view.addSubview(equationLabelBackground)

        let equationInset : CGFloat = 15
        equationLabel.frame = CGRect(x: 7*spacing+bezelHeight+topHeight+equationInset, y: spacing, width: view.frame.width-bezelHeight*2-75-11*spacing-topHeight-2*equationInset, height: topHeight)
        equationLabel.backgroundColor = .clear
        equationLabel.font = equationLabel.font.withSize(22)
        equationLabel.text = "y' = t+y⋅y"
        equationLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(equationLabel)

    }
    func setupSettingsButton()
    {
        let settingsButton = UIButton()
        settingsButton.frame = CGRect(x: 6*spacing+bezelHeight, y: spacing, width: topHeight, height: topHeight)
        settingsButton.setImage(UIImage(named: "settings.png"), for: .normal)
        settingsButton.layer.cornerRadius = 5
        settingsButton.backgroundColor = settingsBlue
        settingsButton.addTarget(self, action:#selector(ViewController.settings), for:.touchUpInside)
        view.addSubview(settingsButton)
    }
    func setupEditEquationButton()
    {
        let editEquationButton = UIButton()
        editEquationButton.frame = CGRect(x: view.frame.width-bezelHeight-75-3*spacing, y: spacing, width: 75, height: topHeight)
        editEquationButton.setTitle("Edit", for: .normal)
        editEquationButton.setTitleColor(blue, for: .highlighted)
        editEquationButton.titleLabel?.font = editEquationButton.titleLabel?.font.withSize(22)
        editEquationButton.layer.cornerRadius = 5
        editEquationButton.backgroundColor = settingsBlue
        editEquationButton.addTarget(self, action:#selector(ViewController.editEquation), for:.touchUpInside)
        view.addSubview(editEquationButton)
    }
    func setupMainView()
    {
        mainView.backgroundColor = .clear
        mainView.frame = CGRect(x: 0+bezelHeight, y: topHeight, width: view.frame.width-bezelHeight*2, height: view.frame.height-topHeight)
        view.addSubview(mainView)
        
        fieldView.backgroundColor = .black
        fieldView.clipsToBounds = true
        fieldView.layer.borderColor = UIColor.black.cgColor
        fieldView.layer.borderWidth = 1
        fieldView.frame = CGRect(x: 6*spacing, y: spacing*2, width: mainView.frame.width-9*spacing, height: mainView.frame.height-8*spacing)
        fieldView.layer.cornerRadius = 5
        mainView.addSubview(fieldView)
        
        tRange = maxT-minT
        xRange = maxX-minX
        fieldHeight = fieldView.frame.height
        fieldWidth = fieldView.frame.width
        rat = fieldHeight*tRange/(fieldWidth*xRange)
    
    }
    func render()
    {
        for subview in mainView.subviews
        {
            subview.removeFromSuperview()
        }
        fieldView.layer.sublayers = []
        pointLabel.isHidden = true
        
        axesLayers = []
        slopeFieldLayers = []
        
        setupMainView()
        setupClearButton()
        setupPointLabel()
        setupAxes()
        setupSlopeField()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tap(_ sender: UIGestureRecognizer) {
        
        if fieldView.frame.contains(sender.location(in: mainView))
        {
            let p = view.convert(sender.location(in: fieldView), from: nil)
            let point = pointFromLocation(loc: p)
            graphCurve(point: point)
        }

    }
    func graphCurve(point : CGPoint)
    {
        let p = locationFromPoint(point: point)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: p.x,y: p.y), radius: CGFloat(4), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        pointLabel.text = "(\(String(format: "%.3f", Double(point.x))),\(String(format: "%.3f", Double(point.y))))"
        pointLabel.isHidden = false
        let pointLayer = CAShapeLayer()
        pointLayer.path = circlePath.cgPath
        pointLayer.fillColor = colors[colorIndeces[2]].cgColor
        pointLayer.strokeColor = colors[colorIndeces[2]].cgColor
        pointLayer.lineWidth = 1
        fieldView.layer.addSublayer(pointLayer)
        pointLayers.append(pointLayer)
        
        let forwardPath = UIBezierPath()
        forwardPath.move(to: CGPoint(x: p.x,y: p.y))
        var currentX = p.y
        for temp in stride(from: p.x, to: fieldWidth, by: accuracy)
        {
            if currentX < 0
            {
                forwardPath.addLine(to: CGPoint(x: temp, y: -1))
            }
            else if currentX > fieldHeight
            {
                forwardPath.addLine(to: CGPoint(x: temp, y: fieldHeight+1))
            }
            else
            {
                forwardPath.addLine(to: CGPoint(x: temp, y: currentX))
            }
            let difference = accuracy*differential(p: pointFromLocation(loc: CGPoint(x: temp, y: currentX)))*rat
            if difference.isInfinite || difference.isNaN
            {
                break
            }

            currentX = currentX - difference
            
        }
        let forwardLayer = CAShapeLayer()
        forwardLayer.add(pathAnimation, forKey: "strokeEnd")
        forwardLayer.path = forwardPath.cgPath
        forwardLayer.fillColor = UIColor.clear.cgColor
        forwardLayer.strokeColor = colors[colorIndeces[3]].cgColor
        forwardLayer.lineWidth = 1
        fieldView.layer.addSublayer(forwardLayer)
        curveLayers.append(forwardLayer)

        let backwardPath = UIBezierPath()
        backwardPath.move(to: CGPoint(x: p.x,y: p.y))
        currentX = p.y
        for temp in stride(from: p.x, to: 0, by: -1*accuracy)
        {
            if currentX < 0
            {
                backwardPath.addLine(to: CGPoint(x: temp, y: -1))
            }
            else if currentX > fieldHeight
            {
                backwardPath.addLine(to: CGPoint(x: temp, y: fieldHeight+1))
            }
            else
            {
                backwardPath.addLine(to: CGPoint(x: temp, y: currentX))
            }
            let difference = -1*accuracy*differential(p: pointFromLocation(loc: CGPoint(x: temp, y: currentX)))*rat
            if difference.isInfinite || difference.isNaN
            {
                break
            }
            currentX = currentX - difference
            

        }
        let backwardLayer = CAShapeLayer()
        backwardLayer.add(pathAnimation, forKey: "strokeEnd")
        backwardLayer.path = backwardPath.cgPath
        backwardLayer.fillColor = UIColor.clear.cgColor
        backwardLayer.strokeColor = colors[colorIndeces[3]].cgColor
        backwardLayer.lineWidth = 1
        fieldView.layer.addSublayer(backwardLayer)
        curveLayers.append(backwardLayer)

        moveLayerToFront(layer: pointLayer, view: fieldView)
    }
    func recolor()
    {
        for axes in axesLayers
        {
            axes.strokeColor = colors[colorIndeces[0]].cgColor
        }
        for slope in slopeFieldLayers
        {
            slope.strokeColor = colors[colorIndeces[1]].cgColor
            slope.fillColor = colors[colorIndeces[1]].cgColor
        }
        for point in pointLayers
        {
            point.strokeColor = colors[colorIndeces[2]].cgColor
            point.fillColor = colors[colorIndeces[2]].cgColor
        }
        for curve in curveLayers
        {
            curve.strokeColor = colors[colorIndeces[3]].cgColor
        }
    }
    func differential(p: CGPoint) -> CGFloat
    {
        let x = round(p.y*10.0)/10.0
        let t = round(p.x*10.0)/10.0
        for i in -10...10
        {
            for j in -10...10
            {
                let d = differential(t: t+CGFloat(i)/1000, x: x+CGFloat(j)/1000)
                if d.isNaN || d.isInfinite
                {
                    return .nan
                }
            }
        }
        return differential(t: t, x: x)
    }
    func differential(t: CGFloat, x: CGFloat) -> CGFloat
    {
        /*var numericExpression : String = eqnExpression
        
        numericExpression = numericExpression.replacingOccurrences(of: "t", with: "(\(t))")
        numericExpression = numericExpression.replacingOccurrences(of: "y", with: "(\(x))")
        
        let expression = NSExpression(format: numericExpression)
        let result = expression.expressionValue(with: nil, context: nil) as! CGFloat*/
        return t+x*x
    }
    func pointFromLocation(loc : CGPoint) -> CGPoint
    {
        let x = loc.x/fieldWidth*tRange+minT
        let y = (1-loc.y/fieldHeight)*xRange+minX
        return CGPoint(x: x, y: y)
    }
    func locationFromPoint(point : CGPoint) -> CGPoint
    {
        let x = (point.x-minT)/tRange*fieldWidth
        let y = ((point.y-minX)/xRange-1) * -1*fieldHeight
        return CGPoint(x: x, y: y)
    }
    @objc func clear(sender: UIButton!)
    {
        fieldView.layer.sublayers = axesLayers
        for slope in slopeFieldLayers
        {
            fieldView.layer.addSublayer(slope)
        }
        pointLabel.isHidden = true
    }
    @objc func editEquation()
{
        /*let keyboardView = UIView(frame: CGRect(x: bezelHeight, y: view.frame.height*55/80, width: view.frame.width-2*bezelHeight, height: view.frame.height*25/80))
        keyboardView.backgroundColor = blue
        view.addSubview(keyboardView)
    
        print(view.frame.height*55/80)*/
        
        let inputViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        inputViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        inputViewController.homeViewController = self
        self.present(inputViewController, animated: true, completion: nil)
    }
    @objc func settings()
    {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        settingsViewController.homeViewController = self
        self.present(settingsViewController, animated: true, completion: nil)
    }
    func moveLayerToFront(layer: CAShapeLayer, view: UIView)
    {
        layer.removeFromSuperlayer()
        view.layer.addSublayer(layer)
    }
    func nextMultiple(num: Int, interval: Int) -> Int
    {
        var n = num
        if n == 0
        {
            return n
        }
        if (n % interval) != 0
        {
            var d = 0
            while(n < 0)
            {
                n = n + interval
                d = d + interval
            }
            n = n + interval - n % interval - d
        }
        return n
    }
    func getInterval(range: CGFloat) -> CGFloat
    {
        if(range <= 10)
        {
            return 1
        }
        else if(11 <= range && range <= 20)
        {
            return 2
        }
        else if(21 <= range && range <= 30)
        {
            return 3
        }
        else if(31 <= range && range <= 40)
        {
            return 4
        }
        else if(41 <= range && range <= 50)
        {
            return 5
        }
        else
        {
            var temp : CGFloat = 50
            while((2*temp) < range)
            {
                temp*=2
            }
            return 2*temp/10
        }

    }

}
public extension NSNumber {
    func sn() -> NSNumber {
        return NSNumber(value: sin(self.doubleValue))
    }
    func cs() -> NSNumber {
        return NSNumber(value: cos(self.doubleValue))
    }
    func lg() -> NSNumber {
        return NSNumber(value: log(self.doubleValue))
    }
    func sq() -> NSNumber {
        return NSNumber(value: sqrt(self.doubleValue))
    }
}
