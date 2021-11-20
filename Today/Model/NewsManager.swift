//
//  NewsManager.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import Foundation

struct NewsManager {
    let API_KEY = "38847bd516d2669c13296f86c223bfec"
    let API_URL = "http://api.mediastack.com/v1/"
    
    var offset = 0
    var delegate: NewsManagerDelegate?
    
    func fetchLiveNews() {
        let urlString = "\(API_URL)news?access_key=\(API_KEY)&sources=en&offset=\(offset)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URL Session
            let session = URLSession(configuration: .default)
            
            // Give task to session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let newsData = self.parseJSON(safeData) {
                        self.delegate?.didFetchNews(newsData)
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> NewsData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(NewsData.self, from: data)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    mutating func increaseOffsetBy(limit: Int) {
        offset += limit
    }
}

protocol NewsManagerDelegate {
    func didFetchNews(_ newsData: NewsData)
    func didFailWithError(error: Error)
}
