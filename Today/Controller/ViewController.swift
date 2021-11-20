//
//  ViewController.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsManager = NewsManager()
    var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsManager.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.register(UINib(nibName: Constants.newsCellNibName, bundle: nil), forCellReuseIdentifier: Constants.newsCellIdentifier)
        
        newsManager.fetchLiveNews()
    }
    
    
}

//MARK: - NewsManagerDelegate
extension ViewController: NewsManagerDelegate {
    func didFetchNews(_ newsData: NewsData) {
        print("News Fetched!")
        
        // Update offset
        newsManager.increaseOffsetBy(limit: newsData.pagination.limit)
        
        DispatchQueue.main.async {
            // Update News Array
            self.news = newsData.data
            self.newsTableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Fail on fetching news!!!", error)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentNews = news[indexPath.row]
        
        // Cell'i MessageCell objesi olması için cast ettik.
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellIdentifier, for: indexPath) as! NewsCell
        
        cell.newsTitleLabel.text = currentNews.title
        cell.newsDateLabel.text = currentNews.published_at
        
        if let imageURL = currentNews.image {
            if let url = URL(string: imageURL) {
                cell.newsImageView.load(url: url)
            }
        }
        
        return cell
    }
}

//MARK: - URLImageView
extension UIImageView {
    func load(url: URL) {
        print("Image View Load Called")
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
