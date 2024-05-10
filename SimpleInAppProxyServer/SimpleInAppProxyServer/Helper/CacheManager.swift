//
//  CacheManager.swift
//  SimpleInAppProxyServer
//
//  Created by sangmin han on 5/11/24.
//

import Foundation


class CacheManager : NSObject {
    static let shared = CacheManager()
    
    
    private var dirPathURL : URL? = {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.cachesDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirpath = paths.first {
            return URL(fileURLWithPath: dirpath).appendingPathComponent("Hsm/Caches")
        }
        else {
            return nil
        }
    }()
    
    private override init(){
        guard let dirPathURL = dirPathURL else { return }
        do {
            try FileManager.default.createDirectory(at: dirPathURL, withIntermediateDirectories: true)
        }
        catch(let error){
            MyLogger.debug(" filemanager cant create directory \(error.localizedDescription)")
        }
    }
    
    
    
    private func parseUrlToFileName(urlString : String) -> URL? {
        guard let dirPathURL = dirPathURL else { return nil }
        guard let url = URL(string: urlString) else { return nil }
        let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let path = urlComponent?.path.replacingOccurrences(of: "/", with: "_") else { return nil }
        
        MyLogger.debug("\(dirPathURL.appendingPathComponent(path, conformingTo: .data))")
        return dirPathURL.appendingPathComponent(path, conformingTo: .utf8PlainText)
    }
    
    func saveFileToDevice(url : String, data : Data) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let searchUrl = self?.parseUrlToFileName(urlString: url) else { return }
            do {
                try data.write(to: searchUrl)
            }
            catch(let error) {
                MyLogger.debug("[SHOPLIVECACHE] failed to write to device \(error.localizedDescription)")
            }
        }
    }
    
    func findCachedData(url : String) -> Bool {
        guard let searchUrl = self.parseUrlToFileName(urlString: url) else { return false }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: searchUrl.path) {
            return true
        }
        return false
    }
    
    func getCachedData(url : String, completion : ((Data) -> ())?) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            guard let searchUrl = self.parseUrlToFileName(urlString: url) else { return }
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: searchUrl.path) {
                guard let data = self.getCachedData(url: searchUrl) else { return }
                completion?(data)
            }
        }
    }
    
    private func getCachedData(url : URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        }
        catch(let error) {
            MyLogger.debug("[SHOPLIVECACHE] cant find data \(error.localizedDescription)")
        }
        return nil
    }
}
