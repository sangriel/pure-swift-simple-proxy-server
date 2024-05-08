//
//  SocketRequestParser.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 5/8/24.
//

import Foundation


class SocketRequestParser {
    
    func requestParser(requestString : String) -> SocketRequest {
        let parsed = requestString.components(separatedBy: .newlines).filter({ $0.isEmpty == false })
        let parsed2 = parsed[0].components(separatedBy: " ")
        return SocketRequest(method: parsed2[0], path: parsed[1], host: parsed[1])
    }
}
