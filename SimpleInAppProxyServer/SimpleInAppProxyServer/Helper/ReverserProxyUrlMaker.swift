//
//  ReverserProxyUrlMaker.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 5/6/24.
//

import Foundation


struct ReverserProxyUrlMaker {
    static func makeReverProxyUrl(url : URL, originUrlQueryKey : String) -> URL? {
        guard var urlComponet = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        
        urlComponet.scheme = "http"
        urlComponet.host = "127.0.0.1"
        urlComponet.port = 8888
        
        let queryItem = URLQueryItem(name: originUrlQueryKey, value: url.absoluteString)
        urlComponet.queryItems = [queryItem]
        return urlComponet.url
    }
}
