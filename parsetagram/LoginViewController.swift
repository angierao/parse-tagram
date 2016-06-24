//
//  LoginViewController.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/19/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSignIn(sender: AnyObject) {
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsernameInBackground( username, password: password) { (user: PFUser?, error: NSError?) in
            if user != nil {
                print("You are now logged in.")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
    
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        //newUser.email = emailField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            if error?.code == 202 {
                print("Username is taken.")
            }
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
