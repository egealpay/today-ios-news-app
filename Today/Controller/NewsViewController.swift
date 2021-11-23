//
//  NewsViewController.swift
//  Today
//
//  Created by Ege Alpay on 23.11.2021.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var newsURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let safeURL = newsURL {
            let url = URL(string: safeURL)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
