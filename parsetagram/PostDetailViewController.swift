//
//  PostDetailViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/21/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController {
    var post: PFObject?
    var isLiked: Bool?
    
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabelTop: UILabel!
    
    @IBOutlet weak var usernameLabelBottom: UILabel!
    
    @IBOutlet weak var allCommentsButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if 0 == post!["commentsCount"] as! Int {
            allCommentsButton.hidden = true
        }
        else {
            let likes = post!["commentsCount"] as! Int
            allCommentsButton.setTitle("View all \(likes) comments", forState: UIControlState.Normal
            )
        }
        //imageView.image = image
        let image = post!["media"] as! PFFile
        image.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                self.imageView.image = image
            }
            else {
                print(error)
            }
        }
        
        let numLikes = post!["likesCount"] as! Int
        if numLikes == 0 {
            likesLabel.text = ""
        }
        else if numLikes == 1 {
            likesLabel.text = "1 like"
        }
        else {
            likesLabel.text = "\(numLikes) likes"
        }

        
        let caption = post!["caption"] as! String
        captionLabel.text = caption
        
        let user = post!["author"] as! PFUser

        usernameLabelTop.text = user.username
        usernameLabelBottom.text = user.username
        
        let imageFile = user["profilePic"] as! PFFile
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                self.profPicView.image = image
            }
            else {
                print(error)
            }
        }
        
        if let time = post!["creationString"] as? String {
            timeLabel.text = time
        }
        else {
            timeLabel.text = ""
        }
        
        if isLiked! {
            let image = UIImage(named: "likedButton")
            likeButton.setImage(image, forState: UIControlState.Normal)
            post!.incrementKey("likesCount")
            isLiked = false
        }
        else {
            let image = UIImage(named: "likeButton")
            likeButton.setImage(image, forState: UIControlState.Normal)
            post!.incrementKey("likesCount", byAmount: -1)
            isLiked = false
        }
        
        usernameLabelBottom.hidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func onLike(sender: AnyObject) {
        /*
        if !isLiked! {
            let image = UIImage(named: "likedButton")
            likeButton.setImage(image, forState: UIControlState.Normal)
            post!.incrementKey("likesCount")
            isLiked = true
        }
        else {
            let image = UIImage(named: "likeButton")
            likeButton.setImage(image, forState: UIControlState.Normal)
            post!.incrementKey("likesCount", byAmount: -1)
            isLiked = false
            
        }
        post!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print("success")
                //self.loadView()
            }
            else {
                print(error)
            }
        }*/

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
