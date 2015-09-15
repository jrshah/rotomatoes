//
//  MovieDetailsViewController.swift
//  rotomatoes
//
//  Created by Jay Shah on 9/12/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var detailsPosterImageView: UIImageView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsDescriptionLabel: UILabel!
    
    var movie:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsDescriptionLabel.text = movie!["synopsis"] as? String
        detailsTitleLabel.text = movie!["title"]as? String
        
        let posters = movie!["posters"] as! NSDictionary
        
        let thumbUrl = NSURL(string: posters["original"] as! String)
        
        detailsPosterImageView.setImageWithURL(thumbUrl!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
