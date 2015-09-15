//
//  DVDDetailsViewController.swift
//  rotomatoes
//
//  Created by Jay Shah on 9/14/15.
//  Copyright © 2015 Jay Shah. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class DVDDetailsViewController: UIViewController {
    
    @IBOutlet weak var dvdDetailsPosterImageView: UIImageView!
    @IBOutlet weak var dvdDetailsTitleLabel: UILabel!
    @IBOutlet weak var dvdDetailsDescriptionLabel: UILabel!
    
    var dvd:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dvdDetailsDescriptionLabel.text = dvd!["synopsis"] as? String
        dvdDetailsTitleLabel.text = dvd!["title"]as? String
        
        let posters = dvd!["posters"] as! NSDictionary
        
        let thumbUrl = NSURL(string: posters["original"] as! String)
        
        dvdDetailsPosterImageView.setImageWithURL(thumbUrl!)
        
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
