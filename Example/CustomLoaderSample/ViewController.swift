//
//  ViewController.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 23/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit
import CustomLoader

class ViewController: UIViewController {
    
    var timer: Timer!
    var value: CGFloat = -2
    var loader: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func showLoader(sender: Any) {
        
        value = -2
        loader = LoadingView.standardProgressBox.show(inView: view) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.view.removeLoadingViews(animated: true)
            }
        }
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
        
        if let box = loader.progressBox {
            box.label.text = "Loading ..."
            box.subLabel.text = "1 of 4"
            if let ring = box.loaderView as? ProgressRingView {
                ring.minimumValue = -2
                ring.maximumValue = 2
                ring.value = self.value
            }
        }
    }
    
    func timerFire() {
        if let box = loader.progressBox {
            if let ring = box.loaderView as? ProgressRingView {
                self.value += 0.4
                ring.value = self.value
            }
        }
    }
}

