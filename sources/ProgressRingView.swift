//
//  LoadingIndicatorView.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 23/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressRingView: UIView {
    
    var addedLayer = [CALayer]()
    
    private var _innerColor: UIColor = UIColor.clear
    @IBInspectable
    var innerColor: UIColor {
        get { return _innerColor }
        set {
            _innerColor = newValue
            setNeedsLayout()
        }
    }
    
    private var _outterColor: UIColor = UIColor.clear
    @IBInspectable
    var outterColor: UIColor {
        get { return _outterColor }
        set {
            _outterColor = newValue
            setNeedsLayout()
        }
    }
    
    private var _lineWidth: CGFloat = 3.0
    @IBInspectable
    var lineWidth: CGFloat {
        get { return _lineWidth }
        set {
            _lineWidth = newValue
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func circleLayer(color: UIColor, scale: CGFloat = 1.0) -> CALayer {
        
        let shapeLayer = CAShapeLayer(circleInFrame: bounds, scale:scale, maxAngle: M_PI)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    func initialize() {
        
        let theLayer = circleLayer(color: outterColor)
        layer.addSublayer(theLayer)
        theLayer.addRotationAnimation(clockwise: true)
        
        let theLayer2 = circleLayer(color: innerColor, scale: 0.7)
        layer.addSublayer(theLayer2)
        theLayer2.addRotationAnimation(clockwise: false)
        
        addedLayer.append(theLayer)
        addedLayer.append(theLayer2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addedLayer.forEach { subLayer in
            subLayer.removeFromSuperlayer()
        }
        addedLayer.removeAll()
        initialize()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
}

extension ProgressRingView {
    
    static var light: ProgressRingView {
        let view = ProgressRingView()
        view.outterColor = .white
        view.innerColor = .darkGray
        return view
    }
    
    static var dark: ProgressRingView {
        let view = ProgressRingView()
        view.outterColor = .black
        view.innerColor = .darkGray
        return view
    }
}

extension CAShapeLayer {
    
    convenience init(circleInFrame drawingFrame: CGRect,
                     scale: CGFloat = 1.0,
                     maxAngle: Double = M_PI * 2,
                     clockwise: Bool = true) {
        self.init()
        var diameter = drawingFrame.width
        if drawingFrame.width > drawingFrame.height {
            diameter = drawingFrame.height
        }
        let center = CGPoint(x: drawingFrame.width / 2.0, y: drawingFrame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: (diameter * scale) / 2.0,
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(maxAngle),
                                      clockwise: clockwise)
        path = circlePath.cgPath
        frame = drawingFrame
    }
}

extension CALayer {
    
    /// Rotate forever around the Z axis
    func addRotationAnimation(clockwise: Bool) {
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = M_PI
        if clockwise {
            rotation.toValue = -M_PI
        }
        rotation.isCumulative = true
        rotation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        rotation.duration = 0.75
        rotation.isAdditive = true
        rotation.fillMode = kCAFilterLinear
        rotation.repeatCount = Float.greatestFiniteMagnitude;
        
        self.add(rotation, forKey: "rotation")
    }
}
