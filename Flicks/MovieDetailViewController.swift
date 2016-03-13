//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by VietCas on 3/11/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Attributes
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var overviewScrollView: UIScrollView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var toggleInfoButton: UIButton!

    var infoToggled = false
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        // Do any additional setup after loading the view.
        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        
        let releaseDate = movie["release_date"] as! String
        releaseDateLabel.text = releaseDate
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = baseUrl + posterPath
            self.movieImageView.setImageWithURL(NSURL(string: imageURL)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upClick(sender: AnyObject) {
        let heightToggle: CGFloat = 120
        if(!infoToggled) {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.toggleInfoButton.setImage(UIImage(named: "arrowdown"), forState: .Normal)
                self.infoView.frame.origin.y = self.infoView.frame.origin.y - heightToggle
                var newFrame = self.infoView.frame
                newFrame.size.height += heightToggle
                self.infoView.frame = newFrame
                self.overviewLabel.numberOfLines = 0
                self.overviewLabel.sizeToFit()
                self.overviewScrollView.frame.size.height += heightToggle
                self.overviewScrollView.contentSize = CGSize(width: self.overviewScrollView.frame.size.width, height: self.overviewLabel.frame.size.height)
            }
        } else {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.toggleInfoButton.setImage(UIImage(named: "arrowup"), forState: .Normal)
                self.infoView.frame.origin.y += heightToggle
                var newFrame = self.infoView.frame
                newFrame.size.height -= heightToggle
                self.infoView.frame = newFrame
                self.overviewLabel.numberOfLines = 3
                self.overviewLabel.sizeToFit()
                self.overviewScrollView.frame.size.height -= heightToggle
                self.overviewScrollView.contentSize = CGSize(width: self.overviewScrollView.frame.size.width, height: self.overviewLabel.frame.size.height)
            }
        }
        infoToggled = !infoToggled
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
