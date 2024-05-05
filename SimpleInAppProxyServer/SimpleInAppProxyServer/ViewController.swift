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
    
    private var player : AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayout()
        
        proxyServer.startProxyServer { receivedData, response in
            
            response(Data())
        }
        
        guard let reverseUrl = ReverserProxyUrlMaker.makeReverProxyUrl(url: URL(string: "someUrl")!, originUrlQueryKey: "originKey") else { return }
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
