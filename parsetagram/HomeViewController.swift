//
//  HomeViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/20/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedView: UITableView!

    var images: [PFFile]?
    
    var captions: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedView.delegate = self
        self.feedView.dataSource = self

        // Do any additional setup after loading the view.
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.images = []
                self.captions = []
                for pic in pics! {
                    self.images?.append(pic["media"] as! PFFile)
                    self.captions?.append(pic["caption"] as! String)
                }
                self.feedView.reloadData()
            }
        }
    }

    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
            self.performSegueWithIdentifier("logoutSegue", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.feedView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
    
        let image = images![indexPath.row]
        image.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                cell.pictureView.image = image
            }
            else {
                print(error)
            }
        }
        let caption = captions![indexPath.row] as String
        cell.captionLabel.text = caption
        //cell.pictureView.image = image
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images?.count ?? 0
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
