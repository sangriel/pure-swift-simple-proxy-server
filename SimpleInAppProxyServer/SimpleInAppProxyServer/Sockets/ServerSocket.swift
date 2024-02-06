//
//  ServerSocket.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/02/05.
//

import Foundation
import CoreFoundation
import Darwin


class ServerSocket : NSObject {
    
    private let port : UInt16
    private var socket : CFSocket?
    private var fileDescriptor : CFSocketNativeHandle?
    
    init(port : UInt16) throws {
        self.port = port
        super.init()
        
    }
    
    deinit {
        
    }
    
}
