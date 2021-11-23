//
//  ViewController.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    // NewsManager object to reqeust news
    var newsManager = NewsManager()
    
    // News to display on UI
    var news: [News] = []
    
    // Boolean flag to control loading animation
    var isLoading = false
    
    var selectedNewsURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign delegates and datasource
        newsManager.delegate = self
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        // Register custom cells on Table View
        newsTableView.register(UINib(nibName: Constants.newsCellNibName, bundle: nil), forCellReuseIdentifier: Constants.newsCellIdentifier)
        newsTableView.register(UINib(nibName: Constants.loadingCellNibName, bundle: nil), forCellReuseIdentifier: Constants.loadingCellIdentifier)
        
        // When this view created, get news
        loadData()
    }
    
    // Method to request news from News Manager
    func loadData() {
        print("loadData")
        if !isLoading {
            isLoading = true
            print("fetchLiveNews")
            newsManager.fetchLiveNews()
        }
    }
    
    // Iso Format Date to Human Readable Format
    func getHumanReadableDate(dateInString: String?) -> String {
        if let safeDateInString = dateInString {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from:safeDateInString)!

            dateFormatter.dateFormat = "d MMMM"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.navigateToNewsDetails { // Segue'in hangisi olduğu kontrol edilir.
                let destinationVC = segue.destination as! NewsViewController // Gidilecek ekranı Segue'den alabiliriz.
                destinationVC.newsURL = selectedNewsURL // Gidilecek ekrandaki bir değişkenin değerini değiştiririz.
            }
        }
}

//MARK: - NewsManagerDelegate
extension ViewController: NewsManagerDelegate {
    // If fetching news was successful
    func didFetchNews(_ newsData: NewsData) {
        
        // Update offset
        newsManager.increaseOffsetBy(limit: newsData.pagination.limit)
        
        DispatchQueue.main.async {
            // Update UI
            self.news += newsData.data
            self.newsTableView.reloadData()
            self.isLoading = false
        }
    }
    
    // If fetching news fails
    func didFailWithError(error: Error) {
        print("Fail on fetching news!!!", error)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    // Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section for news
        if section == 0 {
            return news.count
        } else if section == 1 {
            // Return the Loading cell
            return 1
        } else {
            //Return nothing
            return 0
        }
    }
    
    // In total there are 2 sections: News and Loading
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Render row w.r.t current section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Get current news for the current row
            let currentNews = news[indexPath.row]
            
            // Create Message Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellIdentifier, for: indexPath) as! NewsCell
            
            // Update Title and Date
            cell.newsTitleLabel.text = currentNews.title
            cell.newsDateLabel.text = getHumanReadableDate(dateInString: currentNews.published_at)
            
            // Update ImageView by the given image URL
            if let imageURL = currentNews.image {
                if let url = URL(string: imageURL) {
                    cell.newsImageView.load(url: url)
                }
            }
            
            return cell
        } else {
            // Create cell for Loading Animation
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCellIdentifier, for: indexPath) as! LoadingCell
            cell.loadingIndicator.startAnimating()
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    // When Table hit the bottom, fetch more news (Infinite Scroll)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 100) && !isLoading {
            loadData()
        }
    }
    
    // When Row selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNews = news[indexPath.row]
        
        if let safeURL = currentNews.url {
            selectedNewsURL = safeURL
            self.performSegue(withIdentifier: Constants.navigateToNewsDetails, sender: self)
        }
    }
    
    
}

//MARK: - URLImageView
extension UIImageView {
    // Updating image view from URL
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
