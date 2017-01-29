//
//  LoadingView.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 24/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    let loaderView: UIView
    
    public init(loaderView theView: UIView) {
        loaderView = theView
        super.init(frame: CGRect.zero)
        
        theView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(theView)
        
        let centerXContraint = NSLayoutConstraint(item: theView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerYContraint = NSLayoutConstraint(item: theView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        addConstraints([centerXContraint, centerYContraint])
    }
    
    public func removeFromSuperview(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        let animaDuration: Double = animated ? 0.3 : 0
        UIView.animate(withDuration: animaDuration, animations: {
            self.alpha = 0
        }, completion: { finished in
            
            self.removeFromSuperview()
            if let completion = completion {
                completion(finished)
            }
        })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension LoadingView {
    // Instance presentation
    public func show(inView view: UIView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> LoadingView{
        LoadingView.show(inView: view, loadingView: self, animated: animated, completion: completion)
        return self
    }
}

public extension LoadingView {
    // MARK: LoadingView Presentation
    public class func show(inView view:UIView, withProgressRing ringView: ProgressRingView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> LoadingView {
        
        let loadingView = LoadingView(loaderView: ringView)
        show(inView: view, loadingView: loadingView, animated: animated, completion: completion)
        
        return loadingView
    }
    
    public class func show(inView view: UIView, box: ProgressBoxView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> LoadingView {
        
        let loadingView = LoadingView(loaderView: box)
        show(inView: view, loadingView: loadingView, animated: animated, completion: completion)
        
        return loadingView
    }
    
    public class func show(inView view: UIView, loadingView: UIView, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        loadingView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,]
        loadingView.frame = view.bounds
        view.addSubview(loadingView)
        
        if animated {
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                loadingView.alpha = 1.0
            }, completion: { finished in
                loadingView.alpha = 1.0
                completion?(finished)
            })
        } else if let completion = completion {
            completion(true)
        }
    }
    
    public class func removeLoadingViews(inView view: UIView, animated: Bool, completion: ((Void) -> Void)? = nil) {
        var loadingViews = [LoadingView]()
        view.subviews.forEach { view in
            if let loadingView = view as? LoadingView {
                loadingViews.append(loadingView)
            }
        }
        var numberOfViews = loadingViews.count
        for view in loadingViews {
            view.removeFromSuperview(animated: animated) { _ in
                numberOfViews -= 1
                if numberOfViews == 0,
                    let completion = completion {
                    completion()
                }
            }
        }
    }
}

// MARK: Style
public extension LoadingView {
    public static var lightProgressRing: LoadingView {
        return LoadingView(loaderView: ProgressRingView.light)
    }
    
    public static var darkProgressRing: LoadingView {
        return LoadingView(loaderView: ProgressRingView.dark)
    }
    
    public static var standardProgressBox: LoadingView {
        return LoadingView(loaderView: ProgressBoxView.standard)
    }
    
    public static func system(withStyle style: UIActivityIndicatorViewStyle) -> LoadingView {
        let loaderView = UIActivityIndicatorView(activityIndicatorStyle: style)
        loaderView.startAnimating()
        return LoadingView(loaderView: loaderView)
    }
    
    public static func systemBox(withStyle style: UIActivityIndicatorViewStyle) -> LoadingView {
        return LoadingView(loaderView: ProgressBoxView.system(withStyle: style))
    }
}

public extension LoadingView {
    public var progressBox: ProgressBoxView? {
        return loaderView as? ProgressBoxView
    }
    
    public var progressRing: ProgressRingView? {
        return loaderView as? ProgressRingView
    }
}


// MARK: UIView extensions
public extension UIView {
    public func removeLoadingViews(animated: Bool, completion: ((Void) -> Void)? = nil) {
        LoadingView.removeLoadingViews(inView: self, animated: animated, completion: completion)
    }
}
