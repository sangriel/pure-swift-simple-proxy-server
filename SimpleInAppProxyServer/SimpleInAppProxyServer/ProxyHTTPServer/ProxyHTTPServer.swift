//
//  ProxyHTTPServier.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/05/02.
//

import Foundation
import UIKit


class ProxyHTTPServer : NSObject {
    private let originURLKey = "originKey"
    private var originURLHost : String?
    private var serverSocket: ServerSocket?
    private var clientSocket : ClientSocket?
    private var portNumber : Int = 8080
    
    
    override init() {
        do {
            serverSocket = try ServerSocket(port: UInt16(portNumber))
        }
        catch(let error) {
            MyLogger.debug("error \(error)")
        }
    }
    
    
    func startProxyServer() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.acceptAndCreateClientSocket()
        }
    }
    
    
    private func acceptAndCreateClientSocket() {
        do {
            self.clientSocket = try self.serverSocket?.acceptClientSocket()
        }
        catch(let error) {
            MyLogger.debug("error \(error)")
        }
    }
    
    
    
    
    
    
    
    
}
