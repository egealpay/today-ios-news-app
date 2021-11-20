//
//  LoadingCell.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
