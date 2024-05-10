//
//  SimpleInAppProxyServerTests.swift
//  SimpleInAppProxyServerTests
//
//  Created by sangmin han on 5/6/24.
//

import XCTest
@testable import SimpleInAppProxyServer


final class SimpleInAppProxyServerTests: XCTestCase {

    
    
    func testReverseProxyMaker() {
        
        //given
        let url = URL(string: "https://www.naver.com?somequery=somevalue")!
        let originKey = "origingKey"
        
        //when
        let proxyUrl = ReverserProxyUrlMaker.makeReverProxyUrl(url: url, originUrlQueryKey: originKey)
        
        
        //then
        XCTAssertNotNil(proxyUrl, "proxyUrl은 nil 되면 안됩니다.")
        let expectation = "http://127.0.0.1:8888?\(originKey)=\(url.absoluteString)"
        XCTAssertEqual(proxyUrl!.absoluteString.removingPercentEncoding,expectation)
    }
}
