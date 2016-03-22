//
//  LoginViewController.swift
//  mdbSocialsApp
//
//  Created by Jessica Cherny on 3/8/16.
//  Copyright © 2016 Jessica Cherny. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func displayAlert(title: String, displayError: String) {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //other stuff
    }
    
    @IBAction func login(sender: AnyObject) {
        var displayError = ""
        if username.text == "" && password.text == "" {
            displayError = "Please enter a username and password"
        } else if username.text == "" {
            displayError = "Please enter a username"
        } else if password.text == "" {
            displayError = "Please enter a password"
        }
        
        if displayError != "" {
            displayAlert("Error in Form", displayError: displayError)
        } else {
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
                (success, loginError) in
                
                if loginError == nil {
                    self.performSegueWithIdentifier("toMainVC", sender: self)
                } else {
                    if let errorString = loginError!.userInfo["error"] as? NSString {
                        displayError = errorString as String
                    } else {
                        displayError = "Please try again later!"
                    }
                    
                    self.displayAlert("Could Not Login", displayError:  displayError)
                }
            }
        }
    }
}
