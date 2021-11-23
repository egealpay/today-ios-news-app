//
//  NewsManager.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import Foundation

// Delegation for NewsManager
protocol NewsManagerDelegate {
    func didFetchNews(_ newsData: NewsData)
    func didFailWithError(error: Error)
}


struct NewsManager {
    // API Related Information
    let API_KEY = "38847bd516d2669c13296f86c223bfec"
    let API_URL = "http://api.mediastack.com/v1/"
    
    // Offset to track latest news arrived
    var offset = 0
    
    // Delegate
    var delegate: NewsManagerDelegate?
    
    // Fetches Live News
    func fetchLiveNews() {
        let urlString = "\(API_URL)news?sort=popularity&access_key=\(API_KEY)&sources=en&offset=\(offset)"
        performRequest(urlString: urlString)
    }
    
    // Generic method to perform GET Request from given URL String
    func performRequest(urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URL Session
            let session = URLSession(configuration: .default)
            
            // Give task to session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    // If there is an error
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                // If data is not nil
                if let safeData = data {
                    // JSON Parse
                    if let newsData = self.parseJSON(safeData) {
                        // Update news on UI
                        self.delegate?.didFetchNews(newsData)
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    
    // Method to parse JSON
    func parseJSON(_ data: Data) -> NewsData? {
        // Create JSON Decoder
        let decoder = JSONDecoder()
        
        do {
            // Try to decode. If successful, return decoded data
            let decodedData = try decoder.decode(NewsData.self, from: data)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    // Update offset by given value
    mutating func increaseOffsetBy(limit: Int) {
        offset += limit
    }
}
