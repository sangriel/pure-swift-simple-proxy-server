//
//  MyLogger.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/02/06.
//

import Foundation
import os

struct MyLogger {
    static func debug(_ message : String) {
        let subSystem = Bundle.main.bundleIdentifier ?? "just.some.other.subsystem"
        let osLog = OSLog(subsystem: subSystem, category: "DEBUG")
        os_log(.debug, log: osLog, "\(message)")
    }
}
