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
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsManager.delegate = self
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        newsTableView.register(UINib(nibName: Constants.newsCellNibName, bundle: nil), forCellReuseIdentifier: Constants.newsCellIdentifier)
        newsTableView.register(UINib(nibName: Constants.loadingCellNibName, bundle: nil), forCellReuseIdentifier: Constants.loadingCellIdentifier)
        
        loadData()
    }
    
    func loadData() {
        print("loadData")
        if !isLoading {
            isLoading = true
            print("fetchLiveNews")
            newsManager.fetchLiveNews()
        }
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
            self.news += newsData.data
            self.newsTableView.reloadData()
            self.isLoading = false
        }
    }
    
    func didFailWithError(error: Error) {
        print("Fail on fetching news!!!", error)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //Return the amount of items
            return news.count
        } else if section == 1 {
            //Return the Loading cell
            return 1
        } else {
            //Return nothing
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCellIdentifier, for: indexPath) as! LoadingCell
            cell.loadingIndicator.startAnimating()
            return cell
        }
    }
}
//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 100) && !isLoading {
            loadData()
        }
    }
}

//MARK: - URLImageView
extension UIImageView {
    func load(url: URL) {
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
