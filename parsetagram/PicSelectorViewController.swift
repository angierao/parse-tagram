//
//  PicSelectorViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/23/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class PicSelectorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var profPicView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    
    @IBAction func onLibrary(sender: AnyObject) {
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func onCamera(sender: AnyObject) {
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        /*
         let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
         let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
         */     var newImage: UIImage
        /*
         if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
         imageView.contentMode = .ScaleAspectFit
         imageView.image = pickedImage
         } */
        
        if let pickedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = pickedImage
            
            profPicView.contentMode = .ScaleAspectFit
            profPicView.image = newImage
            
            
        } else if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = pickedImage
            
            profPicView.contentMode = .ScaleAspectFit
            profPicView.image = newImage
        }
        
        
        
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
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
