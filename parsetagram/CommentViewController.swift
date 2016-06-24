//
//  CommentViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/23/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var post: PFObject?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newCommentLabel: UITextField!
    var comments: [PFObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        let query = PFQuery(className: "Comment")
        query.orderByAscending("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error:NSError?) in
            if error != nil{
                print(error)
            } else {
                self.comments = objects
                self.tableView.reloadData()
            }
        }

    }
    
    @IBAction func onComment(sender: AnyObject) {
        Comment.newMessage(newCommentLabel) { (success: Bool, error: NSError?) in
            if error != nil {
                print("commented!")
            }
            else {
                print(error)
            }
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
        let comment = comments![indexPath.row]
        cell.commentLabel.text = comment["text"] as? String
        let user = comment["user"] as! PFUser
        cell.usernameLabel.text = user.username
        if let profpic = user["profilePic"] as? PFFile {
            profpic.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    cell.profPIcView.image = image
                }
                else {
                    print(error)
                }
            }
        }
        else {
            cell.profPIcView.image = UIImage()
        }
        
        if let time = comment["creationString"] as? String {
            cell.timeLabel.text = time
        }
        else {
            cell.timeLabel.text = ""
        }

        
        return cell
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
