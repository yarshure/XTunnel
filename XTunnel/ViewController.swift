//
//  ViewController.swift
//  XTunnel
//
//  Created by yarshure on 2017/9/26.
//  Copyright © 2017年 yarshure. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let x = Tunmanager()
    override func viewDidLoad() {
        super.viewDidLoad()
        x.open()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

