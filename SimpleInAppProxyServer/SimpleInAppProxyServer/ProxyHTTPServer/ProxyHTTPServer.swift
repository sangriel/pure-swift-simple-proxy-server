//
//  ProxyHTTPServier.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/05/02.
//

import Foundation
import UIKit

protocol ProxyHttpServerInterface {
    func startProxyServer(requestHandler : ((Data,(Data) -> ()) -> ())?)
    func closeProxyServer()
    func setOriginUrlHost(url : URL)
    func setOriginUrlQueryKey(key : String)
    var requestHandler : ((Data,(Data) -> ()) -> ())? { get set }
    
}

protocol ProxyHttpServerDelegate {
    func proxyHttpServer(onError : ProxyServerError)
}

class ProxyHTTPServer : NSObject, ProxyHttpServerInterface {
    typealias RequestHandler = ((Data, (Data) -> () ) -> ())
    
    private let originURLKey = "originKey"
    private var originURLHost : String?
    private var serverSocket: ServerSocket?
    private var clientSocket : ClientSocket?
    private var portNumber : Int = 8080
    
    var requestHandler: RequestHandler?
    
    var delegate : ProxyHttpServerDelegate?
    
    override init() {
        do {
            serverSocket = try ServerSocket(port: UInt16(portNumber))
        }
        catch(let error) {
            MyLogger.debug("error \(error)")
        }
    }
    
    func startProxyServer(requestHandler : RequestHandler?) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.requestHandler = requestHandler
            self.acceptAndCreateClientSocket()
        }
    }
    
    func closeProxyServer() {
        serverSocket?.stop()
        if let clientSocket = self.clientSocket {
            clientSocket.close()
            self.clientSocket = nil
        }
    }
    
    func setOriginUrlHost(url: URL) {
        guard let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        self.originURLHost = urlComponent.host
    }
    
    func setOriginUrlQueryKey(key: String) {
        self.originURLKey = key
    }
    
    private func destroyAndRemakeClientSocket() {
        self.clientSocket?.close()
        self.clientSocket = nil
        self.acceptAndCreateClientSocket()
    }
    
    private func acceptAndCreateClientSocket() {
        do {
            self.clientSocket = try self.serverSocket?.acceptClientSocket()
        }
        catch(let error) {
            MyLogger.debug("error \(error)")
        }
    }
    
    private func handleRequestFromClientSocket(socket : ClientSocket?) {
        guard let clientSocket = clientSocket else {
            MyLogger.debug("noClientSocket")
            return
        }
        
        do {
            guard let requestData = try clientSocket.receive(maxLength: 50000) else {
                self.destroyAndRemakeClientSocket()
                return
            }
            
            guard let requestHandler = requestHandler else {
                delegate?.proxyHttpServer(onError: .requestHandlerNotImplemented)
                return
            }
            
            requestHandler(requestData) { [weak self] responseData in
                self?.sendResponseToClientSocket(responseData: responseData)
            }
        }
        catch(let error) {
            MyLogger.debug("error \(error)")
        }
    }
    
    private func sendResponseToClientSocket(responseData : Data) {
        do {
            try clientSocket?.send(data: responseData)
        }
        catch(let error) {
            MyLogger.debug("clientResponse error \(error)")
        }
    }
    
    
}
