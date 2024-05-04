//
//  YoutubeService.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/03.
//

import Alamofire
import RxSwift
import RxAlamofire
import Foundation

enum YoutubeAPI {
    static let URL: String = "https://youtube.googleapis.com/youtube/v3/"
}

class YoutubeService {
    static let shared = YoutubeService()
    
    func getVideoInfo(for url: String) -> Observable<[String: String]> {
        guard let videoId = extractVideoId(from: url),
              let key = getYoutubeAPIKeyFromInfoPlist() else {
            return .just([:])
        }
        
        let url = YoutubeAPI.URL + "videos"
        let parameters = [
            "id": videoId,
            "part": "snippet",
            "regionCode": "KR",
            "key": key
        ]
        
        return RxAlamofire.json(.get, url, parameters: parameters, encoding: URLEncoding.default)
            .map { json in
                var result = [String: String]()
                if let json = json as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    for item in items {
                        if let snippet = item["snippet"] as? [String: Any],
                           let title = snippet["title"] as? String,
                           let thumbnails = snippet["thumbnails"] as? [String: Any],
                           let defaultThumbnail = thumbnails["default"] as? [String: Any],
                           let thumbnailURL = defaultThumbnail["url"] as? String {
                            result["title"] = title
                            result["thumbnailURL"] = thumbnailURL
                        }
                    }
                }
                return result
            }
    }
    
    private func extractVideoId(from url: String) -> String? {
        guard let url = URL(string: url) else { return "" }
        
        if let host = url.host, host.contains("youtu.be") {
            return url.lastPathComponent
        } else {
            if let item = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
                for i in item  {
                    if i.name == "v" {
                        return i.value ?? ""
                    }
                }
            }
        }
        
        return ""
    }
    
    private func getYoutubeAPIKeyFromInfoPlist() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "YoutubeAPIKey") as? String
    }
    
}
