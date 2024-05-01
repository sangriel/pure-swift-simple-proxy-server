//
//  ServerSocket.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/02/05.
//

import Foundation
import CoreFoundation
import Darwin


protocol ServerSocketInterface {
    func start() throws
    func stop()
    func acceptClientSocket() throws -> ClientSocket?
}

class ServerSocket : NSObject, ServerSocketInterface {
    
    private let port : UInt16
    private var socket : CFSocket?
    private var fileDescriptor : CFSocketNativeHandle?
    
    init(port : UInt16) throws {
        self.port = port
        super.init()
        
    }
    
    deinit {
        MyLogger.debug("server socket deinited")
    }
    
    
    func start() throws {
        let sock =  CFSocketCreate(kCFAllocatorDefault,
                                   AF_INET, SOCK_STREAM,
                                   IPPROTO_TCP,
                                   0,nil,nil)
        
        guard sock != nil else {
            throw SocketError.SocketCreationFailed
        }
        
        var reuse : Bool = true
        
        fileDescriptor = CFSocketGetNative(sock!)
        
        guard let fileDescriptor = fileDescriptor else {
            throw SocketError.FileDescriptionCreationFailed
        }
        
        if setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, &reuse, socklen_t(MemoryLayout<Int>.size)) < 0 {
            MyLogger.debug("socket option failed")
            throw SocketError.SocketOptionSettingFailed
        }
        
        var addr = sockaddr_in(sin_len: __uint8_t(MemoryLayout<sockaddr_in>.size),
                               sin_family: sa_family_t(AF_INET),
                               sin_port: port.bigEndian,
                               sin_addr: in_addr(s_addr: INADDR_ANY),
                               sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        
        let addrData = withUnsafePointer(to: &addr) { ptr in
            return ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { addrPtr in
                return Data(bytes: addrPtr, count: MemoryLayout<sockaddr_in>.size)
            }
        }
       
        let result = CFSocketSetAddress(sock!, addrData as CFData)
        guard result == .success else {
            throw SocketError.SocketBindingFailed
        }
        
        let source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sock!, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        
        socket = sock
    }
    
    
    func stop() {
        if let socket = socket {
            CFSocketInvalidate(socket)
        }
        self.socket = nil
    }
    
    func acceptClientSocket() throws ->  ClientSocket? {
        guard let socket = self.socket else {
            throw SocketError.FileDescriptionCreationFailed
        }
        let fileDescriptor = CFSocketGetNative(socket)
        var clientAddress = sockaddr()
        var clientAddressLength = socklen_t(MemoryLayout<sockaddr>.size)
        let clientFileDescriptor = Darwin.accept(fileDescriptor, &clientAddress, &clientAddressLength)
        guard clientFileDescriptor >= 0 else {
            throw SocketError.SocketAcceptFailed
        }
        do {
            return try ClientSocket(fileDescriptor: clientFileDescriptor, address: clientAddress)
        }
        catch(_) {
            throw SocketError.SocketAcceptFailed
        }
    }
}
