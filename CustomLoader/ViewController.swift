//
//  ViewController.swift
//  CustomLoader
//
//  Created by fritzgerald muiseroux on 23/01/2017.
//  Copyright © 2017 fritzgerald muiseroux. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var loader: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func showLoader(sender: Any) {
        
        loader = LoadingView.show(inView: view, box: .standard) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.loader!.removeFromSuperview(animated: true)
            }
        }
    }
}

