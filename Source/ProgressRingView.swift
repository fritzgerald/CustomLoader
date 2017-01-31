//
//  LoadingIndicatorView.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 23/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit

@IBDesignable
public class ProgressRingView: UIView {
    
    var addedLayer = [CALayer]()
    
    @IBInspectable
    public var innerColor: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var outterColor: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var lineWidth: CGFloat = 3.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var isIndeterminate: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var minimumValue: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            if minimumValue >= maximumValue {
                maximumValue = minimumValue + 1
            }
        }
    }
    
    @IBInspectable
    public var maximumValue: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var value: CGFloat? {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var valueRatio: Double {
        guard let value = value else {
            return 0
        }
        return ProgressRingView.valueRatio(minumum: minimumValue, maximum: maximumValue, value: value)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func circleLayer(color: UIColor, radius: CGFloat, angle: Double, lineWith width: CGFloat) -> CALayer {
        
        let shapeLayer = CAShapeLayer(circleInFrame: bounds, radius:radius, maxAngle: angle)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    private func initialize() {
        
        if isIndeterminate {
            initializeIndeterminate()
        } else {
            initializeDeterminate()
        }
    }
    
    private func initializeDeterminate() {
        
        let bigRadius = (bounds.width / 2.0) - lineWidth
        let centerRadius = bigRadius - lineWidth
        var valueRatio: Double = 0
        if let value = value {
            valueRatio = ProgressRingView.valueRatio(minumum: minimumValue, maximum: maximumValue, value: value)
        }
        
        let theLayer = circleLayer(color: outterColor, radius: bigRadius, angle:(M_PI * 2 * valueRatio) - M_PI_2  , lineWith: lineWidth)
        layer.addSublayer(theLayer)
        
        let theLayer2 = circleLayer(color: innerColor, radius: centerRadius, angle: (M_PI * 2) - M_PI_2, lineWith: lineWidth)
        layer.addSublayer(theLayer2)
        
        
        addedLayer.append(theLayer)
        addedLayer.append(theLayer2)
    }
    
    
    private func initializeIndeterminate() {
        
        let bigRadius = (bounds.width / 2.0) - lineWidth
        let theLayer = circleLayer(color: outterColor, radius: bigRadius, angle: M_PI, lineWith: lineWidth)
        layer.addSublayer(theLayer)
        theLayer.addRotationAnimation(clockwise: true)
        
        let theLayer2 = circleLayer(color: innerColor, radius: bigRadius - lineWidth, angle: M_PI, lineWith: lineWidth)
        layer.addSublayer(theLayer2)
        theLayer2.addRotationAnimation(clockwise: false)
        
        addedLayer.append(theLayer)
        addedLayer.append(theLayer2)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        addedLayer.forEach { subLayer in
            subLayer.removeFromSuperlayer()
        }
        addedLayer.removeAll()
        initialize()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
}

extension ProgressRingView {
    // MARK: Helper
    static func valueRatio(minumum: CGFloat, maximum: CGFloat, value: CGFloat) -> Double{
        let amplitude = maximum - minumum
        let translatedValue = fabs(Double(value - minumum))
        let valueRatio = Double(translatedValue) / Double(amplitude)
        return fmin(fmax(0, valueRatio), 1.0)
    }
}

public extension ProgressRingView {
    
    public static var light: ProgressRingView {
        let view = ProgressRingView()
        view.outterColor = .white
        view.innerColor = .darkGray
        return view
    }
    
    public static var dark: ProgressRingView {
        let view = ProgressRingView()
        view.outterColor = .black
        view.innerColor = .darkGray
        return view
    }
}

extension CAShapeLayer {
    
    convenience init(circleInFrame drawingFrame: CGRect,
                     radius: CGFloat,
                     maxAngle: Double = M_PI * 2,
                     clockwise: Bool = true) {
        self.init()
        //let diameter = fmin(drawingFrame.width, drawingFrame.height)
        let center = CGPoint(x: drawingFrame.width / 2.0, y: drawingFrame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: CGFloat(-M_PI_2),
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
