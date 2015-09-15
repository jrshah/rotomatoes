//
//  MoviesViewController.swift
//  rotomatoes
//
//  Created by Jay Shah on 9/12/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableViewLabel: UITableView!
    
    var movies:NSArray?
    var dvds:NSArray?
    var pageNumber = 4
    
    let CELL_NAME = "com.jrshah.rotomatoes.moviecell"
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var networkErrorView: UIView!
    
    var refreshControl: UIRefreshControl!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let movieRow = movies![indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! MoviesCell
        
        cell.titleLabel.text = movieRow["title"] as? String
        cell.descriptionLabel.text = movieRow["synopsis"] as? String
        
        let posters = movieRow["posters"] as! NSDictionary
        
        let thumbUrl = NSURL(string: posters["thumbnail"] as! String)
        
        cell.thumbImage.setImageWithURL(thumbUrl!)
        
        return cell
        
    }
    
    func onRefresh () {
        self.fetchData(self.pageNumber++)
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        //hiding the network error view default
        self.networkErrorView.viewWithTag(20)?.hidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        self.tableViewLabel.insertSubview(refreshControl, atIndex: 0)
        
        self.fetchData(self.pageNumber)
    }
    
    func fetchData (pageNumber: Int) {
        
        let baseUrl = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&q=a&page_limit=10&page=\(pageNumber)"
 
        let url = NSURL(string: baseUrl)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                //show network error
                if (error?.code)! as Int == -1009 {
                    self.networkErrorView.viewWithTag(20)?.hidden = false
                }
            } else {
                self.networkErrorView.viewWithTag(20)?.hidden = true
                
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                
                SVProgressHUD.dismiss()
                
                self.movies = json["movies"] as! NSArray?
                self.tableViewLabel.reloadData()
                
            }
            
        }
    }
    
    func fetchDVD (pageNumber : Int) {
        let baseUrl = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/upcoming.json?page_limit=10&country=us&page=\(pageNumber)&apiKey=dagqdghwaq3e3mxyrp7kmmj5"
        
        let url = NSURL(string: baseUrl)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                //show network error
                if (error?.code)! as Int == -1009 {
                    self.networkErrorView.viewWithTag(20)?.hidden = false
                }
            } else {
                self.networkErrorView.viewWithTag(20)?.hidden = true
                
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                
                SVProgressHUD.dismiss()
                
                self.dvds = json["movies"] as! NSArray?
                self.tableViewLabel.reloadData()
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! MoviesCell
        let indexPath = tableViewLabel.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        
        movieDetailsViewController.movie = movie as? NSDictionary
        
    }


}


class MoviesCell:UITableViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}