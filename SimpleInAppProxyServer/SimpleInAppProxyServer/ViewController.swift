//
//  ViewController.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 2024/02/05.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_concept")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let proxyServer = ProxyHTTPServer()
    private let socketRequestParser = SocketRequestParser()
    
    
    private var player : AVPlayer?
    
    private let originUrlQueryKey = "originKey"
    private var originHostUrl : String = "https://livecloud.pstatic.net/selective/lip2_kr/cnmss9280/j46qka8vmaq7vmechpsailme3svmh2nzp9dh/"
    lazy private var hlsParser = HLSParser(originUrlHost: originHostUrl, originUrlQueryKey: originUrlQueryKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayout()
        
        proxyServer.startProxyServer { [weak self] receivedData, response in
            guard let requestString = String(data: receivedData, encoding: .utf8), let self = self else {
                return
            }
            MyLogger.debug("request String from avplayer \n \(requestString)")
            let socketRequest = socketRequestParser.requestParser(requestString: requestString)
            
            if socketRequest.path.contains("stream.m3u8") {
                hlsParser.handleNormalPlayListM3U8(data: receivedData) { responseData  in
                    response?(responseData)
                }
            }
            else if socketRequest.path.contains(".m3u8") {
                hlsParser.handleMasterPlayListM3U8(data: receivedData) { responseData  in
                    MyLogger.debug("masterPlaylistProxyData  \n \(String(data: responseData, encoding: .utf8)!)")
                    response?(responseData)
                }
            }
            else {
                hlsParser.handleTsFile(data: receivedData) { responseData in
                    response?(responseData)
                }
            }
        }
        
        guard let reverseUrl = ReverserProxyUrlMaker.makeReverProxyUrl(url: URL(string: "https://livecloud.pstatic.net/selective/lip2_kr/cnmss9280/j46qka8vmaq7vmechpsailme3svmh2nzp9dh/playlist.m3u8?hdnts=st=1715351906~exp=1715384316~acl=*/j46qka8vmaq7vmechpsailme3svmh2nzp9dh/*~hmac=fbefaa48249f356f96ab061049598ebd9b4885d2db0f7cad6efb6839d8c52259")!, originUrlQueryKey: originUrlQueryKey) else { return }
        player = AVPlayer(url: reverseUrl )
        
        
    }
    

}
extension ViewController {
    private func setLayout() {
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
}
extension ViewController : ProxyHttpServerDelegate {
    func proxyHttpServer(onError: ProxyServerError) {
        print(onError)
    }
}
