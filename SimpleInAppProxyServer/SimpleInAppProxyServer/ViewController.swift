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
    private var playerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private var playerLayer : AVPlayerLayer = AVPlayerLayer()
    
    
    private let originUrlQueryKey = "originKey"
    private var originHostUrl : String = "https://livecloud.pstatic.net/selective/lip2_kr/anmss1181/h7g2jji3sgtxvvixvpi91rpibdj6zp4znqad/"
    lazy private var naverhlsParser : HLSParser = NaverHLSParser(originUrlHost: originHostUrl, originUrlQueryKey: originUrlQueryKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayout()
        
        proxyServer.startProxyServer { [weak self] receivedData, response in
            guard let requestString = String(data: receivedData, encoding: .utf8), let self = self else {
                return
            }
            let socketRequest = socketRequestParser.requestParser(requestString: requestString)
            
            if socketRequest.path.contains("stream.m3u8") && socketRequest.path.contains(".ts") == false {
                naverhlsParser.handleNormalPlayListM3U8(data: receivedData) { responseData  in
                    response?(responseData)
                }
            }
            else if socketRequest.path.contains(".m3u8") && socketRequest.path.contains(".ts") == false{
                naverhlsParser.handleMasterPlayListM3U8(data: receivedData) { responseData in
                    response?(responseData)
                }
            }
            else {
                naverhlsParser.handleTsFile(data: receivedData) { responseData in
                    response?(responseData)
                }
            }
        }
        
        guard let reverseUrl = ReverserProxyUrlMaker.makeReverProxyUrl(url: URL(string: "https://livecloud.pstatic.net/selective/lip2_kr/anmss1181/h7g2jji3sgtxvvixvpi91rpibdj6zp4znqad/playlist.m3u8?hdnts=st=1715353496~exp=1715385906~acl=*/h7g2jji3sgtxvvixvpi91rpibdj6zp4znqad/*~hmac=88584d5565177b7a6e0163f99a00ec7527a2c0edc2dcd4988b1f6d0c834ee77b")!, originUrlQueryKey: originUrlQueryKey) else { return }
        player = AVPlayer(url: reverseUrl )
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerView.layer.addSublayer(playerLayer)
        playerLayer.frame = self.playerView.bounds
        playerLayer.player = player
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }

}
extension ViewController {
    private func setLayout() {
        self.view.addSubview(imageView)
        self.view.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            
            playerView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
    }
}
extension ViewController : ProxyHttpServerDelegate {
    func proxyHttpServer(onError: ProxyServerError) {
        print(onError)
    }
}
