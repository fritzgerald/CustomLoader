//
//  LoadingView.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 24/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    let loaderView: UIView
    
    init(loaderView theView: UIView) {
        loaderView = theView
        super.init(frame: CGRect.zero)
        
        theView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(theView)
        
        let centerXContraint = NSLayoutConstraint(item: theView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerYContraint = NSLayoutConstraint(item: theView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        addConstraints([centerXContraint, centerYContraint])
    }
    
    func removeFromSuperview(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { finished in
            if finished {
                self.removeFromSuperview()
            }
            if let completion = completion {
                completion(finished)
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func show(inView view:UIView, withProgressRing ringView: ProgressRingView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> LoadingView {
        
        let loadingView = LoadingView(loaderView: ringView)
        show(inView: view, loadingView: loadingView, animated: animated, completion: completion)
        
        return loadingView
    }
    
    class func show(inView view: UIView, box: ProgressBoxView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> LoadingView {
        
        let loadingView = LoadingView(loaderView: box)
        show(inView: view, loadingView: loadingView, animated: animated, completion: completion)
        
        return loadingView
    }
    
    class func show(inView view: UIView, loadingView: UIView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        loadingView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,]
        loadingView.frame = view.bounds
        view.addSubview(loadingView)
        
        if animated {
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                loadingView.alpha = 1.0
            }, completion: completion)
        } else if let completion = completion {
            completion(true)
        }
    }
}
