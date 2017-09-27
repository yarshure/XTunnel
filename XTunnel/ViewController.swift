//
//  ViewController.swift
//  XTunnel
//
//  Created by yarshure on 2017/9/26.
//  Copyright © 2017年 yarshure. All rights reserved.
//

import Cocoa
import tun2socks
class ViewController: NSViewController,TSIPStackDelegate,TSTCPSocketDelegate {
    func localDidClose(_ socket: TSTCPSocket) {
        
    }
    
    func socketDidReset(_ socket: TSTCPSocket) {
        
    }
    
    func socketDidAbort(_ socket: TSTCPSocket) {
        
    }
    
    func socketDidClose(_ socket: TSTCPSocket) {
        
    }
    
    func didReadData(_ data: Data, from: TSTCPSocket) {
        if let s = String.init(data: data, encoding: .utf8) {
            print("recv " + s)
            
        }
        var new = Data()
        new.append(data)
        new.append("\r\n".data(using: .utf8)!)
        from.writeData(new)
    }
    
    func didWriteData(_ length: Int, from: TSTCPSocket) {
        
    }
    
    func didAcceptTCPSocket(_ sock: TSTCPSocket) {
        sock.delegate = self
        print("incoming socket")
        ss.append(sock)
    }
    
    var ss:[TSTCPSocket] = []
    let x = Tunmanager()
    override func viewDidLoad() {
        super.viewDidLoad()
        TSIPStack.stack.delegate = self
        x.open()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

