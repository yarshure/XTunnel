//
//  Tunmanager.swift
//  XTunnel
//
//  Created by yarshure on 2017/9/26.
//  Copyright © 2017年 yarshure. All rights reserved.
//

import Cocoa

class Tunmanager: NSObject {

    // MARK: Properties
    
    /// The virtual address of the tunnel.
    var tunnelAddress: String?
    
    /// The name of the UTUN interface.
    var utunName: String?
    
    /// A dispatch source for the UTUN interface socket.
    var utunSource: DispatchSource?
    
    /// A flag indicating if reads from the UTUN interface are suspended.
    var isSuspended = false
    
    func open() ->Bool {
        guard setupVirtualInterface(address: "10.10.0.1") else {
            return false
        }
        return false
    }
    /// Create a UTUN interface.
    func createTUNInterface() -> Int32 {
        
        let utunSocket = socket(PF_SYSTEM, SOCK_DGRAM, SYSPROTO_CONTROL)
        guard utunSocket >= 0 else {
            simpleTunnelLog("Failed to open a kernel control socket")
            return -1
        }
        
        let controlIdentifier = getUTUNControlIdentifier(utunSocket)
        guard controlIdentifier > 0 else {
            simpleTunnelLog("Failed to get the control ID for the utun kernel control")
            close(utunSocket)
            return -1
        }
        
        // Connect the socket to the UTUN kernel control.
        var socketAddressControl = sockaddr_ctl(sc_len: UInt8(MemoryLayout<sockaddr_ctl>.size), sc_family: UInt8(AF_SYSTEM), ss_sysaddr: UInt16(AF_SYS_CONTROL), sc_id: controlIdentifier, sc_unit: 0, sc_reserved: (0, 0, 0, 0, 0))
        
        let connectResult = withUnsafePointer(to: &socketAddressControl) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(utunSocket, $0, socklen_t(MemoryLayout.size(ofValue: socketAddressControl)))
            }

           // connect(utunSocket, UnsafePointer<sockaddr>($0), socklen_t(MemoryLayout.size(ofValue: socketAddressControl)))
        }
        
        if connectResult < 0 {
            let errorString = String(cString: strerror(errno))
            simpleTunnelLog("Failed to create a utun interface: \(errorString)")
            close(utunSocket)
            return -1
        }
        
        return utunSocket
    }

    /// Get the name of a UTUN interface the associated socket.
    func getTUNInterfaceName(utunSocket: Int32) -> String? {
        var buffer = [Int8](repeating: 0, count: Int(IFNAMSIZ))
        var bufferSize: socklen_t = socklen_t(buffer.count)
        let resultCode = getsockopt(utunSocket, SYSPROTO_CONTROL, getUTUNNameOption(), &buffer, &bufferSize)
        if  resultCode < 0 {
            let errorString = String(cString: strerror(errno))
            simpleTunnelLog("getsockopt failed while getting the utun interface name: \(errorString)")
            return nil
        }
        return String(cString: &buffer)
    }
    
    /// Set up the UTUN interface, start reading packets.
    func setupVirtualInterface(address: String) -> Bool {
        let utunSocket = createTUNInterface()
        guard let interfaceName = getTUNInterfaceName(utunSocket: utunSocket), utunSocket >= 0 &&
                setUTUNAddress(interfaceName, address)
            else { return false }
        
        startTunnelSource(utunSocket: utunSocket)
        utunName = interfaceName
        return true
    }
    /// Start reading packets from the UTUN interface.
    func startTunnelSource(utunSocket: Int32) {
    }
    
    
    
}
