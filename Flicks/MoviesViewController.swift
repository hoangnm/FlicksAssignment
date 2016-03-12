//
//  MoviesViewController.swift
//  Flicks
//
//  Created by VietCas on 3/9/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit
import AFNetworking
import UIColor_Hex_Swift
import EZLoadingActivity

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Attributes
    
    @IBOutlet weak var movieTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var movies = [NSDictionary]()
    var endpoint: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.backgroundColor = UIColor(rgba: "#F2BB60")
        
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        movieTableView.insertSubview(refreshControl, atIndex: 0)
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSegmentChange(sender: AnyObject) {
        let segmentControl = sender as! UISegmentedControl
        let selectedSegmentIndex = segmentControl.selectedSegmentIndex
        
    }
    // MARK: - Methods
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData(true)
    }
    
    func loadData(refreshAction: Bool = false) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        if !refreshAction {
            EZLoadingActivity.show("Loading...", disableUI: true)
        }
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.movieTableView.reloadData()
                    }
                }
                if refreshAction {
                    self.refreshControl.endRefreshing()
                } else {
                    EZLoadingActivity.hide()
                }
        })
        task.resume()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
    
        cell.movieTitleLabel.text = (movie["title"] as! String)
        cell.movieDescriptionsLabel.text = (movie["overview"] as! String)
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = baseUrl + posterPath
            let imageRequest = NSURLRequest(URL: NSURL(string: imageURL)!)
            cell.movieImageView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    cell.movieImageView.alpha = 0.0
                    cell.movieImageView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.movieImageView.alpha = 1.0
                    })
                } else {
                    cell.movieImageView.image = image
                }
                }, failure: { (imageRequest, imageResponse, error) -> Void in
                    
            })
            //cell.movieImageView.setImageWithURL(NSURL(string: imageURL)!)
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let movieDetailVC = segue.destinationViewController as! MovieDetailViewController
        let indexPath = movieTableView.indexPathForCell(sender as! UITableViewCell)
        let movie = movies[indexPath!.row]
        movieDetailVC.movie = movie
    }

}
