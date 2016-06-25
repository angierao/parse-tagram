//
//  CollectionViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/22/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var posts: [PFObject]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoreData()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        
        let user = PFUser.currentUser()
        usernameLabel.text = user?.username
        if let profpic = user!["profilePic"] as? PFFile {
            profpic.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
                if imageData != nil {
                    print("got em")
                    let image = UIImage(data: imageData!)
                    self.profPicView.layer.cornerRadius = self.profPicView.frame.height/2
                    //headerCell.profPicView.layer.cornerRadius = 20
                    self.profPicView.clipsToBounds = true
                    self.profPicView.image = image
                    self.profPicView.image = image
                    
                }
                else {
                    print(error)
                }
            }
        }
        else {
            self.profPicView.image = UIImage()
        }
        
    }
    
    
    @IBAction func onUpdateProfPic(sender: AnyObject) {

    }
    
    func postForIndexPath(indexPath: NSIndexPath, cell: CollectionViewCell) -> UIImage {
        let post = posts![indexPath.row]
        let imageFile = post["media"] as! PFFile
        let image = UIImage()
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                cell.pictureView.image = UIImage(data: imageData!)!
            }
            else {
                print(error)
            }
        }
        return image

    }
    
    func loadMoreData() {
        let query = PFQuery(className: "Post")
        query.limit = 20
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.posts = pics
                let numPosts = self.posts!.count
                if numPosts == 1 {
                    self.postsLabel.text =  "1 Post"
                }
                else {
                    self.postsLabel.text =  "\(numPosts) Posts"
                }
                
            }
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("hi")
        return posts?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        postForIndexPath(indexPath, cell: cell)
        return cell
        
    }

    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
            self.performSegueWithIdentifier("logoutSegue2", sender: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier != "logoutSegue2" && segue.identifier != "updateSegue" {
            
            
            let detailViewController = segue.destinationViewController as! PostDetailViewController
            let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
            let post = posts![indexPath!.row]
            detailViewController.post = post
            detailViewController.isLiked = false
        }
    }
    

}
