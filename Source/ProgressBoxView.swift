//
//  ProgressBoxView.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 24/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit

public class ProgressBoxView: UIView {

    var loaderView: UIView!
    var contentView: UIView!
    let label = UILabel()
    let label2 = UILabel()

    public init(loader: UIView) {
        super.init(frame: CGRect.zero)
        loaderView = loader
        initializeStyle()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeStyle() {
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        
        label.standardStyle(withFont: UIFont.boldSystemFont(ofSize: 15))
        label2.standardStyle(withFont: UIFont.boldSystemFont(ofSize: 12))
        
        contentView.stackViews([loaderView , label, label2])
        
        let centerYConstraint = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        let centerXConstraint = NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let vContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": contentView])
        let hContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": contentView])
        
        addConstraints(vContraints)
        addConstraints(hContraints)
        addConstraints([centerYConstraint, centerXConstraint])
        
        layer.cornerRadius = 10
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
}

public extension ProgressBoxView {
    public static var standard: ProgressBoxView {
        let view = ProgressBoxView(loader: ProgressRingView.light)
        view.backgroundColor =  UIColor.lightGray
        return view
    }
}

class SpaceView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: frame.width))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: frame.height))
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("[SpaceView init:coder:] not implemented")
    }
    
}

extension UILabel {
    
    func standardStyle(withFont font: UIFont) {
        self.font = font
        self.textColor = UIColor.white
        self.numberOfLines = 0
        self.textAlignment = .center
    }
}

extension UIView {
    
    func stackViews(_ views:[UIView]) {
        
        var lastView: UIView? = nil
        var stackConstraints = [NSLayoutConstraint]()
        
        views.forEach({ view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        })
        
        
        views.forEach { view in
            if let lastView = lastView {
                let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: lastView, attribute: .bottom, multiplier: 1.0, constant: 0)
                stackConstraints.append(topConstraint)
            } else {
                let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1.0, constant: 0)
                stackConstraints.append(topConstraint)
            }
            let centerXConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
            stackConstraints.append(centerXConstraint)
            
            let horizontalCOnstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|->=0-[view]->=0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view])
            stackConstraints.append(contentsOf: horizontalCOnstraints)
            lastView = view
        }
        
        if let lastView = lastView {
            let bottom = NSLayoutConstraint(item: lastView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1.0, constant: 0)
            stackConstraints.append(bottom)
        }
        self.addConstraints(stackConstraints)
    }
}