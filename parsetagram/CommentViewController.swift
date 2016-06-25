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
    var posts: [PFObject]?
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
//        query.includeKey("text")
        let id = post!["commentId"] as! Int
        query.whereKey("postID", equalTo: id)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error:NSError?) in
            if let error = error {
                print("error")
                print(error)
            } else {
                self.comments = objects
                self.post!["commentsCount"] = self.comments?.count
                print("commentsCount_CVC")
                print(self.post!["commentsCount"])

                self.post?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if error == nil {
                        //print("yay")
                    }
                    else {
                        print(error)
                    }
                })
                self.tableView.reloadData()
            }
        }
        
        /*
        let postquery = PFQuery(className: "Post")
        postquery.orderByDescending("createdAt")
        postquery.includeKey("comments")
        postquery.includeKey("comments.user")
        postquery.includeKey("commentsCount")
        postquery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
            }
            else {
                self.posts = objects
            }
        }*/
        

    }
    
    @IBAction func onComment(sender: AnyObject) {
        
        let id = post!["commentId"] as! Int
        let newComment = Comment.newMessage(newCommentLabel, id: id) { (success: Bool, error: NSError?) in
            if error != nil {
                print("commented!")
            }
            else {
                print(error)
            }
        }
        self.comments?.append(newComment)
        self.tableView.reloadData()
//        newComment["postID"] = post!["commentID"]
//        newComment.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
//            if success {
//                print("commented?")
//            }
//            else {
//                print(error)
//            }
//        }
        /*
        var postComments = post!["comments"] as! [AnyObject]
        postComments.append(newComment)
        post!["comments"] = postComments
        print(post!["comments"])
        print("adding comment")
        self.post!["commentsCount"] = postComments.count*
        post?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
            if success {
                print("commented?")
            }
            else {
                print(error)
            }
        })*/
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
        let comment = comments![indexPath.row]
        //let thecomments = post!["comments"]
        //let comment = thecomments[indexPath.row] as! PFObject
        //print(comment)
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
