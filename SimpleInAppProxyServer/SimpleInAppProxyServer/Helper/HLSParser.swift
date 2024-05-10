//
//  HLSParser.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 5/6/24.
//

import Foundation


//this HLSParser works on sample based by naver shoppling live m3u8. could not work on other stream types

//masterPlayList
//https://livecloud.pstatic.net/selective/lip2_kr/anmss1226/6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5/playlist.m3u8?hdnts=st=1714932140~exp=1714964550~acl=*/6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5/*~hmac=ecc8340b8c353c149c0600bf6df0f6978f8c964414635b3928c9d4a00487438e
//#EXTM3U
//#EXT-X-VERSION:3
//
//#EXT-X-STREAM-INF:BANDWIDTH=4192000,CODECS="avc1.640028,mp4a.40.2",RESOLUTION=1080x1920
//hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/chunklist_1080.stream.m3u8
//#EXT-X-STREAM-INF:BANDWIDTH=2528000,CODECS="avc1.64001F,mp4a.40.2",RESOLUTION=720x1280
//hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/chunklist_720.stream.m3u8
//#EXT-X-STREAM-INF:BANDWIDTH=1628000,CODECS="avc1.4D401F,mp4a.40.2",RESOLUTION=480x854
//hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/chunklist_480.stream.m3u8
//#EXT-X-STREAM-INF:BANDWIDTH=928000,CODECS="avc1.4D401E,mp4a.40.2",RESOLUTION=360x640
//hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/chunklist_360.stream.m3u8
//#EXT-X-STREAM-INF:BANDWIDTH=496000,CODECS="avc1.4D4015,mp4a.40.2",RESOLUTION=272x480
//hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/chunklist_272.stream.m3u8
//#EXT-X-STREAM-INF:BANDWIDTH=164000,CODECS="avc1.4D400C,mp4a.40.2",RESOLUTION=144x256
//hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/chunklist_144.stream.m3u8

//m3u8
//https://livecloud.pstatic.net/selective/lip2_kr/anmss1226/6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5/hdntl=exp=1714964550~acl=*%2F6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5%2F*~data=hdntl~hmac=5c827547f364f32d8434914bb00cd0480dbf7b2c9fafad7659606dc8b76b2f24/720.stream_290746863_1714932146424_4386_0_2193.ts?bitrate=338212&filetype=.ts
//#EXTM3U
//#EXT-X-VERSION:3
//#EXT-X-ALLOW-CACHE:NO
//#EXT-X-TARGETDURATION:2
//#EXT-X-MEDIA-SEQUENCE:0
//#EXT-X-DISCONTINUITY-SEQUENCE:0
//#EXT-X-DATERANGE:ID="nmss-daterange",START-DATE="2024-05-05T16:49:20.424Z"
//#EXT-X-PROGRAM-DATE-TIME:2024-05-05T16:49:20.424Z
//
//#EXTINF:2.000000,
//720.stream_320128962_1714927760424_0_0_0.ts?bitrate=257842&filetype=.ts
//#EXTINF:2.000000,
//720.stream_3679896847_1714927762424_2_0_1.ts?bitrate=320164&filetype=.ts



//프록시로 들어온 마스터 플레이리스트 요청값
//GET /selective/lip2_kr/cnmss0207/imcm4aj96mr61ddyjmvu4hdqs6xbtd909wlz/playlist.m3u8?originKey=https://livecloud.pstatic.net/selective/lip2_kr/cnmss0207/imcm4aj96mr61ddyjmvu4hdqs6xbtd909wlz/playlist.m3u8?hdnts%3Dst%3D1715009446~exp%3D1715041856~acl%3D*/imcm4aj96mr61ddyjmvu4hdqs6xbtd909wlz/*~hmac%3D889c9234e7f7318af957caabcb917a29a2bd7ceff92cf14562508dfa41cdbfbd HTTP/1.1
//Host: 127.0.0.1:8888
//X-Playback-Session-Id: 132F79B7-7376-4E91-B5E1-26B1417DE719
//Accept: */*
//User-Agent: AppleCoreMedia/1.0.0.21E213 (iPhone; U; CPU OS 17_4 like Mac OS X; ko_kr)
//Accept-Language: ko-KR,ko;q=0.9
//Accept-Encoding: gzip
//Connection: keep-alive


//프록시로 들어온 ts 파일 요청값
//request String from avplayer
// GET /?originKey=https://livecloud.pstatic.net/selective/lip2_kr/cnmss9280/j46qka8vmaq7vmechpsailme3svmh2nzp9dh//hdntl=exp=1715384316~acl=*%2Fj46qka8vmaq7vmechpsailme3svmh2nzp9dh%2F*~data=hdntl~hmac=ea6161e2852284e86e0fc1a0882e76d955462bef748a6ab690d13d3f6e7bdb78/chunklist_720.stream.m3u8/720.stream_3179182285_1715352065957_5882_0_2941.ts?bitrate=167790&filetype=.ts HTTP/1.1
//Host: 127.0.0.1:8888
//X-Playback-Session-Id: A32AE63F-E249-4BCD-96B9-2AF65AA12DEE
//Accept: */*
//User-Agent: AppleCoreMedia/1.0.0.21E213 (iPhone; U; CPU OS 17_4 like Mac OS X; ko_kr)
//Accept-Language: ko-KR,ko;q=0.9
//Accept-Encoding: identity
//Connection: keep-alive
class HLSParser {
    
    //https://livecloud.pstatic.net/selective/lip2_kr/anmss1226/6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5/
    private let originUrlHost : String
    private let originUrlQueryKey : String
    
    private var tsFileBaseQuerySet: Set<String> = []
    
    private var urlSession : URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    init(originUrlHost : String, originUrlQueryKey : String){
        self.originUrlHost = originUrlHost
        self.originUrlQueryKey = originUrlQueryKey
    }
    
    
    func handleMasterPlayListM3U8(data : Data, completion : @escaping (Data) -> () ) {
        guard let requestString = String(data: data, encoding: .utf8) else {
            completion(data)
            return
        }
        let parsed = requestString.components(separatedBy: " ")
        guard let path = parsed.filter({ $0.contains("m3u8")}).first,
              let proxyUrl = URL(string: "https://\(self.originUrlHost)/\(path)"),
              let proxyUrlComponent = URLComponents(url: proxyUrl, resolvingAgainstBaseURL: false),
              let originUrl = self.parseOriginURL(from: proxyUrlComponent) else {
            completion(data)
            return
        }
        
        let request = URLRequest(url: originUrl)
        let task = self.urlSession.dataTask(with: request) { [weak self] result , response , error  in
            guard let result = result, let _ = response, let self = self else {
                completion(data)
                return
            }
            
            let proxyData = self.makeReversedProxyMasterPlaylistM3U8(data: result)
            
            completion(proxyData)
        }
        
        DispatchQueue.global(qos: .background).async {
            task.resume()
        }
    }
    
    func handleNormalPlayListM3U8(data : Data, completion : @escaping (Data) -> ()) {
        guard let requestString = String(data: data, encoding: .utf8) else  {
            completion(data)
            return
        }
        let parsed = requestString.components(separatedBy: " ")
        guard let path = parsed.filter({ $0.contains(".m3u8")}).first,
              let proxyUrl = URL(string: "https://\(self.originUrlHost)/\(path)"),
              let proxyUrlComponent = URLComponents(url: proxyUrl, resolvingAgainstBaseURL: false),
              let originUrl = self.parseOriginURL(from: proxyUrlComponent) else {
            completion(data)
            return
        }
        
        let request = URLRequest(url: originUrl)
        let task = self.urlSession.dataTask(with: request) { [weak self] result , response , error  in
            guard let result = result, let _ = response, let self = self else {
                completion(data)
                return
            }
            let proxyData = self.makeReversedProxyNormalPlayListM3U8(data: result)
            completion(proxyData)
        }
        
        DispatchQueue.global(qos: .background).async {
            task.resume()
        }
        
    }
    
    func handleTsFile(data : Data, completion : @escaping (Data) -> ()) {
        guard let requestString = String(data: data, encoding: .utf8) else {
            completion(data)
            return
        }
        
        let parsed = requestString.components(separatedBy: " ")
        guard let path = parsed.filter({ $0.contains(".ts") }).first else {
            completion(data)
            return
        }
        
        let originUrlString = path.replacingOccurrences(of: "/?\(originUrlQueryKey)=", with: "")
        guard let originUrl = URL(string: originUrlString) else {
            completion(data)
            return
        }
        
        var request = URLRequest(url: originUrl)
        request.httpMethod = "GET"
        let task = self.urlSession.dataTask(with: request) { result, response, error in
            guard let result = result else {
                completion(data)
                return
            }
            
            completion(result)
        }
        
        DispatchQueue.main.async {
            task.resume()
        } 
    }
    
    private func parseOriginURL(from request: URLComponents) -> URL? {
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
    
    
    
    
}
//MARK: - masterPlayList Reverse
extension HLSParser {
    private func makeReversedProxyMasterPlaylistM3U8(data : Data ) -> Data {
        guard let requestString = String(data: data, encoding: .utf8) else {
            return data
        }
        
        guard requestString.contains(".m3u8") else {
            return data
        }
        
        
        let reversedPlayList = requestString.components(separatedBy: .newlines)
            .map({ line in
                return makeReversedProxyM3u8ResolutionPath(resolutionPath: line)
            })
            .joined(separator: "\n")

        guard let result = reversedPlayList.data(using: .utf8) else {
            return data
        }
        return result
    }
    
    private func makeReversedProxyM3u8ResolutionPath(resolutionPath : String) -> String {
        guard resolutionPath.isEmpty == false else {
            return resolutionPath
        }
        
        guard resolutionPath.contains(".m3u8") && resolutionPath.contains("#") == false else {
            return resolutionPath
        }
        
        tsFileBaseQuerySet.insert(resolutionPath)
        return "http://127.0.0.1:8888?\(originUrlQueryKey)=\(self.originUrlHost)\(resolutionPath)"
    }
}
//MARK: - playList reverse
extension HLSParser {
    
    private func makeReversedProxyNormalPlayListM3U8(data : Data) -> Data {
        guard let requestString = String(data: data, encoding: .utf8) else {
            return data
        }
        
        let reversedPlayList = requestString.components(separatedBy: .newlines)
            .map({ line in
                return makeReversedProxyTsPath(tsPath: line)
            })
            .joined(separator: "\n")
        
        guard let result = reversedPlayList.data(using: .utf8) else {
            return data
        }
        return result
    }
    
    private func makeReversedProxyTsPath(tsPath : String) -> String {
        guard tsPath.isEmpty == false else {
            return tsPath
        }
        
        guard tsPath.contains(".ts") && tsPath.contains("#") == false else {
            return tsPath
        }
        
        let parsed = tsPath.components(separatedBy: ".")
        
        guard let resolution = Int(parsed[0]) else {
            return tsPath
        }
        
        let baseQuery = tsFileBaseQuerySet.filter({ $0.contains(String(resolution)) }).first ?? ""
        let resolutionPath = baseQuery.components(separatedBy: "/")[0]
        return "http://127.0.0.1:8888?\(originUrlQueryKey)=\(self.originUrlHost)\(resolutionPath)/\(tsPath)"
    }
}
