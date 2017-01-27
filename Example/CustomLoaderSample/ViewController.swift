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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func showLoader(sender: Any) {
        
        _ = LoadingView.standardProgressBox.show(inView: view) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.view.removeLoadingViews(animated: true)
            }
        }
    }
}

