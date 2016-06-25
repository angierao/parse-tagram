//
//  Post.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/20/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) -> PFObject {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour , .Minute, .Second], fromDate:date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let min = components.minute
        let sec = components.second
        
        let currentDate = NSDateComponents()
        currentDate.year = year
        currentDate.month = month
        currentDate.day = day
        currentDate.hour = hour
        currentDate.minute = min
        currentDate.second = sec
        
        let today = NSCalendar.currentCalendar().dateFromComponents(currentDate)!
        
        let dateFormatter = NSDateFormatter()
        //let date = NSDate()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.stringFromDate(today)
        
        // Add relevant fields to the object
        if getPFFileFromImage(image) == nil {
            print("nil")
        }
        if PFUser.currentUser() == nil {
            print("nil")
        }
        if caption == nil {
           
            print("nil")
        }
        print("objectid")
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["creationString"] = dateString
        post["comments"] = []
        post["commentID"] = ""
        post["commentId"] = Int(arc4random_uniform(1000))
        //post.objectId
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
        
        return post
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
