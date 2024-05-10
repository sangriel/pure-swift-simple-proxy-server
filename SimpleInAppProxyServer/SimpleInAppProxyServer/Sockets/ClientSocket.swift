//
//  ClientSocket.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/02/06.
//

import Foundation
import CoreFoundation
#if os(Linux)
import Glibc
#else
import Darwin
#endif


extension OutputStream {

    func write(data: Data) -> Int {
        return data.withUnsafeBytes { buffer -> Int in
            return self.write(
                buffer.baseAddress!.assumingMemoryBound(to: UInt8.self),
                maxLength: (buffer.count)
            )
        }
    }
}

protocol ClientSocketInterface {
    func send(data : Data, completion : @escaping () -> () ) throws
    func receive(maxLength : Int) throws -> Data?
    func close()
}

class ClientSocket : NSObject, ClientSocketInterface {
    
    var fileDescriptor: Int32
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private var address : sockaddr!
    
    init(fileDescriptor: Int32, address: sockaddr) throws {
        var readStream : Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        self.fileDescriptor = fileDescriptor
        self.address = address
        CFStreamCreatePairWithSocket(nil, fileDescriptor, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.open()
        outputStream.open()
        super.init()
        
        outputStream.delegate = self
        inputStream.delegate = self
    }
    
    deinit {
        MyLogger.debug("client socket deinit")
    }
    
    private let dispatchQueue = DispatchQueue(label: "myQueue",qos: .background ,autoreleaseFrequency: .never)
    
    
    func send(data: Data, completion : @escaping () -> () ) throws {
        dispatchQueue.sync { [weak self] in
            var fileData : Data = data
            let preferredBufferSize : Int = 512 * 4
            while fileData.count > 0 {
                if (self?.outputStream.hasSpaceAvailable ?? false) == false {
                    completion()
                    break
                }
                var writeData : Data
                var writeBufferSize : Int
                if fileData.count > preferredBufferSize {
                    writeBufferSize = preferredBufferSize
                }
                else {
                    writeBufferSize = fileData.count
                }
                writeData = fileData.prefix(writeBufferSize)
                fileData = fileData.dropFirst(writeBufferSize)
                if (self?.outputStream.write(data: writeData) ?? -1) < 0 {
                    completion()
                    break
                }
            }
            completion()
        }
        
    }
    
    func receive(maxLength: Int) throws -> Data? {
        var buffer = [UInt8](repeating: 0, count: maxLength)
        let bytesRead = inputStream.read(&buffer, maxLength: maxLength)
        guard bytesRead >= 0 else {
            throw SocketError.SocketReadFailed
        }
        return bytesRead > 0 ? Data(bytes: buffer, count: bytesRead) : nil
    }
    
    func close() {
        self.inputStream.close()
        self.outputStream.close()
        Darwin.close(self.fileDescriptor)
    }
    
}
extension ClientSocket : StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .endEncountered:
            MyLogger.debug("[ClientSocket] endEncountered")
        case .errorOccurred:
            MyLogger.debug("[ClientSocket] errorOccurred")
        case .hasSpaceAvailable, .openCompleted, .hasBytesAvailable :
            MyLogger.debug("[ClientSocket] hasSpaceAvailable, .openCompleted, .hasBytesAvailable")
            break
        default:
            MyLogger.debug("[ClientSocket] default")
        }
    }
    
}
