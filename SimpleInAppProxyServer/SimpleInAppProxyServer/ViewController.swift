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
    private var originHostUrl : String = "https://livecloud.pstatic.net/selective/lip2_kr/anmss1244/3grsv5crbpyug9rdxh2rmdcog3owjk8qn4mw/"
    lazy private var hlsParser = HLSParser(originUrlHost: originHostUrl, originUrlQueryKey: originUrlQueryKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayout()
        
        proxyServer.startProxyServer { [weak self] receivedData, response in
            guard let requestString = String(data: receivedData, encoding: .utf8), let self = self else {
                return
            }
            let socketRequest = socketRequestParser.requestParser(requestString: requestString)
            
            if socketRequest.path.contains("m3u8") {
                hlsParser.handleMasterPlayListM3U8(data: receivedData) { responseData  in
                    response?(responseData)
                }
            }
            
        }
        
        guard let reverseUrl = ReverserProxyUrlMaker.makeReverProxyUrl(url: URL(string: "https://livecloud.pstatic.net/selective/lip2_kr/anmss1244/3grsv5crbpyug9rdxh2rmdcog3owjk8qn4mw/playlist.m3u8?hdnts=st=1715180878~exp=1715213288~acl=*/3grsv5crbpyug9rdxh2rmdcog3owjk8qn4mw/*~hmac=0105459a2c390a63779b7d299bad3aae4217a5e1194eac53f5db71af89796a7a")!, originUrlQueryKey: originUrlQueryKey) else { return }
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
