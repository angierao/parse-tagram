//
//  PostViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/20/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    //@IBOutlet weak var postControl: UISegmentedControl!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @IBAction func onUploadImage(sender: AnyObject) {
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func onTakePicture(sender: AnyObject) {
        
        if !(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                print("Dismiss UIAlertController");
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            
        }
        else {
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
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
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = newImage

            
        } else if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = pickedImage
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = newImage
        }
        
        
        
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onUpload(sender: AnyObject) {
    
        if imageView.image == nil {
            print("Image not uploaded")
        }
        else {
            Post.postUserImage(imageView.image, withCaption: captionField.text, withCompletion: { (success: Bool, error: NSError?) in
                if error == nil {
                    print("success")
                    Post.getPFFileFromImage(self.imageView.image)
                    self.performSegueWithIdentifier("uploadSuccess", sender: self)
                }
                else {
                    print(error)
                }
            })
        }
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
