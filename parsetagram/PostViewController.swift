//
//  PostViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/20/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var captionField: UITextField!
    //@IBOutlet weak var postControl: UISegmentedControl!
    let imagePicker = UIImagePickerController()
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            libraryButton.layer.borderColor = borderColor?.CGColor
            libraryButton.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        libraryButton.layer.cornerRadius = 10
        libraryButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 10
        cameraButton.clipsToBounds = true
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
        self.selectLabel.hidden = true
        imageView.backgroundColor = UIColor.whiteColor()
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
            let post = Post.postUserImage(imageView.image, withCaption: captionField.text, withCompletion: { (success: Bool, error: NSError?) in
                if error == nil {
                    print("success")
                    Post.getPFFileFromImage(self.imageView.image)
//                    self.performSegueWithIdentifier("uploadSuccess", sender: self)
                    self.tabBarController?.selectedIndex = 0
                }
                else {
                    print(error)
                }
            })
            //print(post.objectId)
            
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

extension CALayer {
    func borderUIColor() -> UIColor? {
        return borderColor != nil ? UIColor(CGColor: borderColor!) : nil
    }
    
    func setBorderUIColor(color: UIColor) {
        borderColor = color.CGColor
    }
}
