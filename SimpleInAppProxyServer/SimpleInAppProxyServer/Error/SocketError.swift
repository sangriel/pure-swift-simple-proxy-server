//
//  SocketError.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/02/06.
//

import Foundation

enum SocketError : Error {
    case SocketCreationFailed
    case FileDescriptionCreationFailed
    case SocketOptionSettingFailed
    case SocketBindingFailed
}

