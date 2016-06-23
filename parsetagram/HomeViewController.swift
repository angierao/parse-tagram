//
//  HomeViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/20/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var feedView: UITableView!
    
    var posts: [PFObject]?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var queryLimit: Int? = 20
    var isLiked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedView.delegate = self
        self.feedView.dataSource = self

        // Do any additional setup after loading the view.
       
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadFeed(_:firstLoad:)), forControlEvents: UIControlEvents.ValueChanged)
        self.loadFeed(refreshControl, firstLoad: true)
        feedView.insertSubview(refreshControl, atIndex: 0)
        
        let frame = CGRectMake(0, feedView.contentSize.height, feedView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        feedView.addSubview(loadingMoreView!)
        
        var insets = feedView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        feedView.contentInset = insets
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.blackColor()
        
        return vw
    }
    
    func loadFeed(refresh: UIRefreshControl, firstLoad: Bool) {
        let query = PFQuery(className: "Post")
        query.limit = queryLimit!
        query.orderByDescending("createdAt")
        query.includeKey("author")
        if firstLoad {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.posts = pics
                self.isMoreDataLoading = false
                self.feedView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                refresh.endRefreshing()
                
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if !isMoreDataLoading {
            let scrollViewContentHeight = feedView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - feedView.bounds.size.height
            if (scrollView.contentOffset.y > scrollOffsetThreshold && feedView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, feedView.contentSize.height, feedView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                self.loadMoreData()
                
            }
        }
    }
    
    func loadMoreData() {
        let query = PFQuery(className: "Post")
        queryLimit = queryLimit! + 20
        query.limit = queryLimit!
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.posts = pics
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                self.feedView.reloadData()
            }
        }
    }

    
    @IBAction func onLike(sender: UIButton) {
//        sender.enabled = false
//        sender.userInteractionEnabled = false
//        sender.alpha = 0.5
        
        //get the point in the table view that corresponds to the button that was pressed
        //in my case these were a bunch of cells each with their own like button
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.feedView)
        let indexPath = self.feedView.indexPathForRowAtPoint(hitPoint)
        let post = posts![(indexPath?.row)!]
        let cell = self.feedView.cellForRowAtIndexPath((indexPath)!) as! PostCell
        //let object = self.feedView.cellForRowAtIndexPath(hitIndex!)
        //this is where I incremented the key for the object
        
        // if you just liked the pic
        if !isLiked {
            let image = UIImage(named: "likedButton")
            cell.likeButton.setImage(image, forState: UIControlState.Normal)
            post.incrementKey("likesCount")
            isLiked = true
        }
        else {
            let image = UIImage(named: "likeButton")
            cell.likeButton.setImage(image, forState: UIControlState.Normal)
            post.incrementKey("likesCount", byAmount: -1)
            isLiked = false
            
        }
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                self.feedView.reloadData()
            }
            else {
                print(error)
            }
        }

        
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.feedView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = posts![indexPath.row]
        let imageFile = post["media"] as! PFFile
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                cell.pictureView.image = image
            }
            else {
                print(error)
            }
        }
        
        cell.captionLabel.text = post["caption"] as? String
        
        let numLikes = post["likesCount"] as! Int
        if numLikes == 0 {
            cell.likeLabel.text = ""
        }
        else if numLikes == 1 {
            cell.likeLabel.text = "1 like"
        }
        else {
            cell.likeLabel.text = "\(numLikes) likes"
        }
        let user = post["author"] as! PFUser
        if let username = user.username {
            cell.usernameLabel.text = username
        }
        
        if let profpic = user["profilePic"] as? PFFile {
            profpic.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
                if imageData != nil {
                    let image = UIImage(data: imageData!)
                    cell.profPicView.image = image
                }
                else {
                    print(error)
                }
            }
        }
        else {
            cell.profPicView.image = UIImage()
        }
        
        if let date = post["creationString"] as? String {
            cell.timeLabel.text = date
        }
        else {
            cell.timeLabel.text = ""
        }
        
        
        return cell
        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //if sender?.identifier ==
        let detailViewController = segue.destinationViewController as! PostDetailViewController
        let indexPath = feedView.indexPathForCell(sender as! UITableViewCell)
        let post = posts![indexPath!.row]
        detailViewController.post = post

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
