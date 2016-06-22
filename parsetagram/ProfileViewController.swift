//
//  ProfileViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/21/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [PFObject]?
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.currentUser()
        usernameLabel.text = user?.username
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadMoreData()
    }
    
    func loadMoreData() {
        let query = PFQuery(className: "Post")
        query.limit = 20
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.posts = pics

                }
                self.tableView.reloadData()
            }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
        let post = posts![indexPath.row]
        cell.captionLabel.text = post["caption"] as? String
        let imageFile = post["media"] as! PFFile
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                cell.profileView.image = image
            }
            else {
                print(error)
            }
        }
        let numLikes = post["likesCount"] as! Int
        if numLikes == 0 {
            cell.likesLabel.text = ""
        }
        else {
            cell.likesLabel.text = "\(numLikes) likes"
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
            self.performSegueWithIdentifier("logoutSegue", sender: nil)
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if sender?.identifier ==
        if segue.identifier != "logoutSegue" {
            
        
        let detailViewController = segue.destinationViewController as! PostDetailViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let post = posts![indexPath!.row]
        detailViewController.post = post
        }

    }
    

}
