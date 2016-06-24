//
//  Comment.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/23/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class Comment: NSObject {
    class func newMessage(content: UITextField?, withCompletion completion: PFBooleanResultBlock?) {
        let comment = PFObject(className: "Comment")
        
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
        dateFormatter.dateFormat = "MMM d, H:mm a"
        let dateString = dateFormatter.stringFromDate(today)
        
        comment["creationString"] = dateString
        comment["text"] = content?.text
        comment["user"] = PFUser.currentUser()
        comment.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print(comment["text"])
                print("not error")
            }
            else {
                print(error)
                print("error")
            }
        }
    }
}
