//
//  HLSParserInterface.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 5/11/24.
//

import Foundation

protocol HLSParser {
    var originUrlHost : String { get set }
    var originUrlQueryKey : String { get set }
    var tsFileBaseQuerySet : Set<String> { get set }
    var urlSession : URLSession { get set }
    
    init(originUrlHost : String, originUrlQueryKey : String)
    
    func handleMasterPlayListM3U8(data : Data, completion : @escaping (Data) -> ())
    func handleNormalPlayListM3U8(data : Data, completion : @escaping (Data) -> ())
    func handleTsFile(data : Data, completion : @escaping (Data) -> ())
}
extension HLSParser {
    func parseOriginURL(from request: URLComponents) -> URL? {
        var encodedURLString : String?
        guard let queryArray = request.queryItems else { return nil }
        for queryItems in queryArray {
            if queryItems.name == self.originUrlQueryKey, let value = queryItems.value {
                encodedURLString = value
            }
        }
        guard let encodedURLString = encodedURLString else { return nil }
        guard let urlString = encodedURLString.removingPercentEncoding else { return nil }
        let url = URL(string: urlString)
        return url
    }
    func getOriginUrlForM3U8(requestString : String) -> URL? {
        let parsed = requestString.components(separatedBy: " ")
        guard let path = parsed.filter({ $0.contains("m3u8")}).first,
              let proxyUrl = URL(string: "https://\(self.originUrlHost)/\(path)"),
              let proxyUrlComponent = URLComponents(url: proxyUrl, resolvingAgainstBaseURL: false),
              let originUrl = self.parseOriginURL(from: proxyUrlComponent) else {
            return nil
        }
        return originUrl
    }
}
