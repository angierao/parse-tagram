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

    var images: [PFFile]?
    
    var captions: [String]?
    
    var users: [PFUser]?
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    
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
    
    func loadFeed(refresh: UIRefreshControl, firstLoad: Bool) {
        let query = PFQuery(className: "Post")
        query.limit = 20
        query.orderByDescending("createdAt")
        query.includeKey("user")
        if firstLoad {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.images = []
                self.captions = []
                self.users = []
                for pic in pics! {
                    self.images?.append(pic["media"] as! PFFile)
                    self.captions?.append(pic["caption"] as! String)
                    self.users?.append(pic["author"] as! PFUser)
                }
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
                
                loadMoreData()
                
            }
        }
    }
    
    func loadMoreData() {
        let query = PFQuery(className: "Post")
        query.limit = 20
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (pics: [PFObject]?, error: NSError?) in
            if error != nil {
                print(error)
                print("did not successfully get pics")
            }
            else {
                self.images = []
                self.captions = []
                self.users = []
                for pic in pics! {
                    self.images?.append(pic["media"] as! PFFile)
                    self.captions?.append(pic["caption"] as! String)
                    self.users?.append(pic["_p_author"] as! PFUser)
                }
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
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
        let user = users![indexPath.row]
        do {
            try user.fetchIfNeeded()
        }
        catch {
            print("catching failed")
        }
        /*
        user.fetchIfNeededInBackgroundWithBlock { (object: PFObject?, error: NSError?) in
            if object == nil {
                print(error)
            }
        } */
        
        cell.usernameLabel.text = user.username
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images?.count ?? 0
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let detailViewController = segue.destinationViewController as! PostDetailViewController
        let indexPath = feedView.indexPathForCell(sender as! UITableViewCell)
        let image = images![(indexPath?.row)!]
        let caption = captions![indexPath!.row]
        detailViewController.image = image
        detailViewController.caption = caption
        
    }
    

}
