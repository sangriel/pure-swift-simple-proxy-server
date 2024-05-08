//
//  SocketRequest.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 5/8/24.
//

import Foundation



class SocketRequest {
    
    var method : String
    var path : String
    var host : String
    
    
    init(method: String, path: String, host: String) {
        self.method = method
        self.path = path
        self.host = host
    }
    
}
