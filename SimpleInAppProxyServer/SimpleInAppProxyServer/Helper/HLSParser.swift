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


class HLSParser {
    
    
    func playerListParser(data : Data, completion : @escaping (Data) -> ()) {
        guard let requestString = String(data: data, encoding: .utf8) else {
            //TODO: - 나중에 404 같은거라도 보내야하나
            completion(Data())
            return
        }
        
        let parsed = requestString.components(separatedBy: " ")
        
        
        
        
        
        
        
    }
}
