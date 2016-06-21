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
    var image: PFFile?
    
    var caption: String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabelTop: UILabel!
    
    @IBOutlet weak var usernameLabelBottom: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView.image = image
        
        image!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) in
            if imageData != nil {
                let image = UIImage(data: imageData!)
                self.imageView.image = image
            }
            else {
                print(error)
            }
        }
        
        captionLabel.text = caption

        

        // Do any additional setup after loading the view.
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