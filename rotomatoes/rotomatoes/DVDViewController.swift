//
//  DVDViewController.swift
//  rotomatoes
//
//  Created by Jay Shah on 9/14/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class DVDViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var dvdTableViewLabel: UITableView!
    
    var dvds:NSArray?
    var pageNumber = 4
    
    let CELL_NAME_DVD = "com.jrshah.rotomatoes.dvdcell"
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var dvdNetworkErrorView: UIView!
    
    var dvdRefreshControl: UIRefreshControl!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dvds?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let movieRow = dvds![indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME_DVD) as! DVDCell
        
        
        cell.dvdTitleLabel.text = movieRow["title"] as? String
        cell.dvdDescriptionLabel.text = movieRow["synopsis"] as? String
        
        let posters = movieRow["posters"] as! NSDictionary
        
        let thumbUrl = NSURL(string: posters["thumbnail"] as! String)
        
        cell.dvdThumbImage.setImageWithURL(thumbUrl!)
        
        return cell
        
    }
    
    func onRefresh () {
        self.fetchDVD(self.pageNumber++)
        self.dvdRefreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        //hiding the network error view default
        self.dvdNetworkErrorView.viewWithTag(0)?.hidden = true
        
        dvdRefreshControl = UIRefreshControl()
        dvdRefreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        self.dvdTableViewLabel.insertSubview(dvdRefreshControl, atIndex: 0)
        
        self.fetchDVD(self.pageNumber)
    }
    
    func fetchDVD (pageNumber : Int) {
        
        let baseUrl = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/upcoming.json?page_limit=10&country=us&page=\(pageNumber)&apiKey=dagqdghwaq3e3mxyrp7kmmj5"
        
        let url = NSURL(string: baseUrl)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                //show network error
                if (error?.code)! as Int == -1009 {
                    self.dvdNetworkErrorView.viewWithTag(0)?.hidden = false
                }
            } else {
                self.dvdNetworkErrorView.viewWithTag(0)?.hidden = true
                
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                
                SVProgressHUD.dismiss()
                
                self.dvds = json["movies"] as! NSArray?
                self.dvdTableViewLabel.reloadData()
                
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
        
        let cell = sender as! DVDCell
        let indexPath = dvdTableViewLabel.indexPathForCell(cell)
        let dvd = dvds![indexPath!.row]
        let movieDetailsViewController = segue.destinationViewController as! DVDDetailsViewController
        
        movieDetailsViewController.dvd = dvd as? NSDictionary
        
    }
    
    
}


class DVDCell:UITableViewCell {
    
    @IBOutlet weak var dvdThumbImage: UIImageView!
    @IBOutlet weak var dvdDescriptionLabel: UILabel!
    @IBOutlet weak var dvdTitleLabel: UILabel!
    
}