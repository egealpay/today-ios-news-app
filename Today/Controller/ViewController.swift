//
//  ViewController.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var newsManager = NewsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsManager.delegate = self
    }


}

extension ViewController: NewsManagerDelegate {
    func didFetchNews(_ newsData: NewsData) {
        print("Fetch")
        newsManager.increaseOffsetBy(limit: newsData.pagination.limit)
    }
    
    func didFailWithError(error: Error) {
        print("Fail")
    }
    
    
}
