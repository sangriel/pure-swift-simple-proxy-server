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
    private var originHostUrl : String = "https://livecloud.pstatic.net/selective/lip2_kr/anmss1226/6frpwuipzbjzpwwrc5kboysyrdnzexxb8sj5/"
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
                hlsParser.handleMasterPlayListM3U8(data: receivedData) { response  in
                    
                }
            }
            
            
            response(Data())
        }
        
        guard let reverseUrl = ReverserProxyUrlMaker.makeReverProxyUrl(url: URL(string: "https://livecloud.pstatic.net/selective/lip2_kr/cnmss0207/imcm4aj96mr61ddyjmvu4hdqs6xbtd909wlz/playlist.m3u8?hdnts=st=1715009446~exp=1715041856~acl=*/imcm4aj96mr61ddyjmvu4hdqs6xbtd909wlz/*~hmac=889c9234e7f7318af957caabcb917a29a2bd7ceff92cf14562508dfa41cdbfbd")!, originUrlQueryKey: originUrlQueryKey) else { return }
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
