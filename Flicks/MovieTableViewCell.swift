//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by VietCas on 3/11/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Attributes
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.grayColor()
        self.selectedBackgroundView = backgroundView
    }

}
