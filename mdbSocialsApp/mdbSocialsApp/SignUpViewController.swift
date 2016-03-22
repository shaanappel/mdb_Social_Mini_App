//
//  SignUpViewController.swift
//  mdbSocialsApp
//
//  Created by Shaan Appel on 3/8/16.
//  Copyright © 2016 Shaan Appel. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    
    func displayAlert(title: String, displayError: String) {
        
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        var displayError = ""
        if username.text == "" {
            displayError = "Please enter a username"
        } else if password.text == "" {
            displayError = "Please enter a password"
        } else if firstName.text == "" {
            displayError = "Please enter a first name"
        } else if lastName.text == "" {
            displayError = "Please enter a last name"
        } else if confirmPassword.text == "" {
            displayError = "Please confirm your password"
        } else if email.text == "" {
            displayError = "Please enter an email"
        }
        
        if displayError != "" {
            displayAlert("Incomplete Form", displayError: displayError)
        } else {
            let user = PFUser()
            user.username = username.text!
            user.password = password.text!
            user.email = email.text!
            user["firstName"] = firstName.text!
            user["lastName"] = lastName.text!
            
            user.signUpInBackgroundWithBlock { (succeeded, signupError) -> Void in
                
                if signupError == nil {
                    self.performSegueWithIdentifier("toMainVCFromSignup", sender: self)
                    print("did transition")
                } else {
                    if let error = signupError!.userInfo["error"] as? NSString {
                        displayError = error as String
                    } else {
                        displayError = "Please try again later!"
                    }
                    self.displayAlert("Could Not Signup", displayError: displayError)
                }
            }
        }
    }
    
    
    
    

}
